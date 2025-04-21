import os
import requests
import xml.etree.ElementTree as ET
from requests.auth import HTTPBasicAuth
from utils.functions import update_resource
from dotenv import load_dotenv

from utils.functions import clean_text

def process_geonetwork(connection, cursor, geonetwork_api_url, geonetwork_user, geonetwork_pass, identifier, resource_id):
    """Función process_geonetwork para procesar recursos desde el catalogador geonetwork.

    La función procesa un metadato en formato XML desde la API de GeoNetwork y actualiza
    la base de datos con el título del recurso.
    en un directorio local. Si el archivo no existe, se informa al usuario.
    Se requiere la librería dotenv para cargar las variables de entorno desde un archivo .env.
    Se requiere la librería zipfile para manejar archivos ZIP.
    Se requiere la librería os para manejar rutas de archivos y directorios.
    Se requiere la librería requests para manejar solicitudes HTTP.

    Se lee desde la tabla de resources el indentificador y se revisa, se conecta a la API de geonetwork y se llena la información

    Args:
        connection: Conexión a la base de datos PostgreSQL.
        cursor: Cursor para ejecutar consultas SQL.
        geonetwork_api_url: URL base de la API de Geonetwork.
        geonetwork_user: Usuario de conexión a la API de Geonetwork.
        geonetwork_pass: Contraseña de usuario de conexión a API de Geonetwork.
        identifier: Identificador del recurso.
        resource_id: ID del recurso en la base de datos.

    Returns:
        None

    Raises:
        requests.exceptions.RequestException: Si hay un error en la solicitud del API
        ET.ParseError: Si hay error en el procesamiento del XML.
    """ 
    load_dotenv()

    # Cargar las variables de entorno desde el archivo .env para encabezados.
    # Se usa el User:agent para evitar bloqueos por error 403 por parte del servidor de Ceiba. 
       
    header = os.getenv('USER_AGENTS')
    headers = {'content-type': 'application/xml', 'Accept': 'application/xml', 'User-Agent': header}

    # Define namespaces para manejar el XML de GeoNetwork
    namespaces = {
        'gmd': 'http://www.isotc211.org/2005/gmd',
        'gco': 'http://www.isotc211.org/2005/gco'
    }

    try:
        # Se contruye la URL de la API de GeoNetwork conel identificado
        url = f"{geonetwork_api_url}/{identifier}"
        print(f"Consultado GeoNetwork API: {url} con {geonetwork_user} y {geonetwork_pass}")
        # Se hace el request a la API de GeoNetwork
        response = requests.get(url, auth=HTTPBasicAuth(geonetwork_user, geonetwork_pass), headers=headers)
        response.raise_for_status()  # Error en caso de excepción HTTP
        
        # Se itera la salida
        tree = ET.ElementTree(ET.fromstring(response.content))
        root = tree.getroot()
        
       # Extrae el título del metadato
        title_element = root.find('.//gmd:title/gco:CharacterString', namespaces)      
        publication_date_element = root.find('.//gmd:dateStamp/gco:DateTime', namespaces)  
        abstract_element = root.find('.//gmd:abstract/gco:CharacterString', namespaces)
        update_resource(connection, cursor, resource_id, title_element, publication_date_element, abstract_element, 'geonetwork')

    except requests.exceptions.RequestException as e:
        print(f"Error al conectar con GeoNetwork API: {e}")
    except ET.ParseError as e:
        print(f"Error al analizar el XML: {e}")
    except Exception as e:
        print(f"Error inesperado: {e}")    
