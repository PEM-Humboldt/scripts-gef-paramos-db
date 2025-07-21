"""
Módulo para procesar recursos desde el catalogador Ceiba.
Descarga, descomprime y procesa archivos de recursos, actualizando la base de datos PostgreSQL.
Requiere configuración de rutas y credenciales en variables de entorno.
"""

import os
import shutil
import xml.etree.ElementTree as ET
from utils.functions import read_dwca_files, update_resource, download_and_decompress_file

def process_ceiba(connection, cursor, ipt_download_url_ceiba, ipt_download_url_dir, identifier, resource_id):
    """
    Procesa un recurso del catalogador Ceiba: descarga, descomprime y actualiza la base de datos.

    Flujo general:
    1. Descarga el archivo ZIP del recurso desde la URL de Ceiba.
    2. Descomprime el archivo en un directorio temporal.
    3. Procesa el archivo eml.xml para extraer metadatos y actualiza la base de datos.
    4. Procesa los archivos occurrence.txt y event.txt si existen, insertando datos en la base de datos.
    5. Elimina el directorio temporal de trabajo.

    Args:
        connection: Conexión activa a la base de datos PostgreSQL.
        cursor: Cursor para ejecutar consultas SQL.
        ipt_download_url_ceiba (str): URL base para descarga de recursos de Ceiba.
        ipt_download_url_dir (str): Directorio local para almacenar recursos descargados temporalmente.
        identifier (str): Identificador único del recurso a procesar.
        resource_id (int): ID del recurso en la base de datos.

    Returns:
        None

    Raises:
        requests.exceptions.RequestException: Si hay un error en la descarga del archivo.
        zipfile.BadZipFile: Si el archivo descargado no es un ZIP válido.
    """

    # Construir la URL de descarga y descargar/descomprimir el archivo ZIP
    file_url = f"{ipt_download_url_ceiba}{identifier}"
    zip_exists = download_and_decompress_file(file_url, ipt_download_url_dir, identifier, 'ceiba')

    if zip_exists:
        resource_path = os.path.join(ipt_download_url_dir, identifier)
        # Procesar metadatos del recurso
        eml_file_path = os.path.join(resource_path, "eml.xml")
        if os.path.exists(eml_file_path):
            print(f"Archivo eml.xml encontrado: {eml_file_path}")
            tree = ET.parse(eml_file_path)
            root = tree.getroot()
            title_element = root.find('.//title')
            publication_date_element = root.find('.//pubDate')
            abstract_element = root.find('.//abstract/para')
            update_resource(connection, cursor, resource_id, title_element, publication_date_element, abstract_element, 'ceiba')
        else:
            print(f"El archivo eml.xml no existe en el directorio especificado.")

        # Procesar archivos de datos (occurrence y event)
        occurrence_file_path = os.path.join(resource_path, "occurrence.txt")
        event_file_path = os.path.join(resource_path, "event.txt")
        if os.path.exists(occurrence_file_path):
            read_dwca_files(occurrence_file_path, 'occurrence', connection, cursor, resource_id)
        else:
            print(f"El archivo occurrence.txt no existe en el directorio especificado.")
        if os.path.exists(event_file_path):
            read_dwca_files(event_file_path, 'event', connection, cursor, resource_id)
        else:
            print(f"El archivo event.txt no existe en el directorio especificado.")
        
        # Eliminar el directorio de trabajo temporal
        shutil.rmtree(resource_path)
        print(f"Archivo ZIP eliminado: {resource_path}")
    else:
        print(f"El archivo {file_url} no existe")


