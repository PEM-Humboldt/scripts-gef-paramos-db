"""
Módulo para procesar recursos desde el catalogador GeoNetwork.

Este módulo contiene la función principal `process_geonetwork`, que realiza lo siguiente:
- Consulta la API de GeoNetwork para obtener el metadato de un recurso en formato XML.
- Extrae información relevante (título, fecha de publicación, resumen) del XML.
- Actualiza la base de datos PostgreSQL con los metadatos extraídos.

Requiere configuración de rutas, credenciales y user-agent en variables de entorno.
"""

import os
import xml.etree.ElementTree as ET
import logging

import requests
from requests.auth import HTTPBasicAuth
from dotenv import load_dotenv

from utils.functions import update_resource

logging.basicConfig(level=logging.INFO)

def process_geonetwork(connection, cursor, geonetwork_api_url, geonetwork_user, geonetwork_pass, identifier, resource_id):
    """
    Procesa un recurso del catalogador GeoNetwork: consulta la API, extrae metadatos y actualiza la base de datos.

    Flujo general:
    1. Construye la URL de la API de GeoNetwork usando el identificador del recurso.
    2. Realiza una petición HTTP autenticada para obtener el XML del recurso.
    3. Extrae los metadatos relevantes (título, fecha de publicación, resumen) usando los namespaces apropiados.
    4. Actualiza la base de datos PostgreSQL con los metadatos extraídos.

    Args:
        connection: Conexión activa a la base de datos PostgreSQL.
        cursor: Cursor para ejecutar consultas SQL.
        geonetwork_api_url (str): URL base de la API de Geonetwork.
        geonetwork_user (str): Usuario para autenticación en la API de Geonetwork.
        geonetwork_pass (str): Contraseña para autenticación en la API de Geonetwork.
        identifier (str): Identificador único del recurso a procesar.
        resource_id (int): ID del recurso en la base de datos.

    Returns:
        None

    Raises:
        requests.exceptions.RequestException: Si hay un error en la solicitud a la API.
        ET.ParseError: Si hay error en el procesamiento del XML.
        ValueError: Si la variable de entorno USER_AGENTS no está definida.
    """
    load_dotenv()

    # Cargar el User-Agent desde variables de entorno para evitar bloqueos por error 403.
    header = os.getenv('USER_AGENTS')
    if not header:
        logging.error("USER_AGENTS no está definido en el entorno")
        raise ValueError("USER_AGENTS no está definido en el entorno")
    headers = {'content-type': 'application/xml', 'Accept': 'application/xml', 'User-Agent': header}

    # Namespaces requeridos para extraer información del XML de GeoNetwork
    namespaces = {
        'gmd': 'http://www.isotc211.org/2005/gmd',
        'gco': 'http://www.isotc211.org/2005/gco'
    }

    try:
        # Construir la URL de la API de GeoNetwork con el identificador del recurso
        url = f"{geonetwork_api_url}/{identifier}"
        logging.info(f"Consultando GeoNetwork API: {url}")
        # Realizar la petición HTTP autenticada
        response = requests.get(url, auth=HTTPBasicAuth(geonetwork_user, geonetwork_pass), headers=headers)
        response.raise_for_status()  # Lanza excepción en caso de error HTTP
        
        # Procesar el XML recibido
        tree = ET.ElementTree(ET.fromstring(response.content))
        root = tree.getroot()
        
        # Extraer metadatos relevantes usando los namespaces
        title_element = root.find('.//gmd:title/gco:CharacterString', namespaces)      
        publication_date_element = root.find('.//gmd:dateStamp/gco:DateTime', namespaces)  
        abstract_element = root.find('.//gmd:abstract/gco:CharacterString', namespaces)
        update_resource(connection, cursor, resource_id, title_element, publication_date_element, abstract_element, 'geonetwork')

    except requests.exceptions.RequestException as e:
        logging.error(f"Error al conectar con GeoNetwork API: {e}")
    except ET.ParseError as e:
        logging.error(f"Error al analizar el XML: {e}")
    except Exception as e:
        logging.error(f"Error inesperado: {e}")    
