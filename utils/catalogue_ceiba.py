import os
import shutil
import xml.etree.ElementTree as ET
from utils.functions import read_dwca_files, update_resource, download_and_decompress_file

def process_ceiba(connection, cursor, ipt_download_url_ceiba, ipt_download_url_dir, identifier, resource_id):
    """Función process_ceiba para procesar recursos desde el catalogador Ceiba.

    La función descarga un archivo ZIP desde una URL específica, lo descomprime y guarda los archivos
    en un directorio local. Si el archivo no existe, se informa al usuario.
    Se requiere la librería dotenv para cargar las variables de entorno desde un archivo .env.
    Se requiere la librería zipfile para manejar archivos ZIP.
    Se requiere la librería os para manejar rutas de archivos y directorios.
    Se requiere la librería requests para manejar solicitudes HTTP.
    Se requiera la libraría shutil para borrar directorios no vacíos.

    Se lee desde la tabla de resources el indentificador y se revisa si el archivo corrspondiente
    al recurso en Ceiba existe. Si existe se descarga el archivo ZIP y se descomprime en la ruta
    definido en el archivo .env. Si no existe se informa al usuario.

    Args:
        connection: Conexión a la base de datos PostgreSQL.
        cursor: Cursor para ejecutar consultas SQL.
        ipt_download_url_ceiba: URL base de descarga de recursos de Ceiba.
        ipt_download_url_dir: Directorio local donde se almacenan los recursos descargados.
        ipt_resources_dir: Directorio donde se almacenan los recursos IPT.
        identifier: Identificador del recurso.
        resource_id: ID del recurso en la base de datos.

    Returns:
        None

    Raises:
        requests.exceptions.RequestException: Si hay un error en la solicitud de descarga del archivo.
        zipfile.BadZipFile: Si el archivo descargado no es un ZIP válido.
    """

    # Variable para indicar si existe un archivo dwca.zip descargado para el recurso y poder procesarlo
    zip_exists = False
    # Variable para indicar el directorio de trabajo temporal para el recurso
    file_url = f"{ipt_download_url_ceiba}{identifier}"   

    # Llamado a la función download_and_decompress_file para descargar y descomprimir el archivo ZIP retorna True o False
    zip_exists = download_and_decompress_file(file_url, ipt_download_url_dir, identifier)

    if zip_exists:
        # Define la ruta de descarga del dwca.zip
        resource_path = os.path.join(ipt_download_url_dir, identifier)
        # Verificar si el archivo eml.xml existe en el directorio descomprimido
        eml_file_path = os.path.join(resource_path, "eml.xml")
        if os.path.exists(eml_file_path):
            print(f"Archivo eml.xml encontrado: {eml_file_path}")
            # Se lee el archivo eml.xml con la librería ElementTree
            tree = ET.parse(eml_file_path)
            # Se obtiene la raíz del la última versión de archivo eml
            root = tree.getroot()
            # Obtener valores de los nodos (ejemplo: título, fecha)
            title_element = root.find('.//title')
            publication_date_element = root.find('.//pubDate')
            abstract_element = root.find('.//abstract/para')
            update_resource(connection, cursor, resource_id, title_element, publication_date_element, abstract_element, 'ceiba')
        else:
            print(f"El archivo eml.xml no existe en el directorio especificado.")

        #revisar si hay ocurrencias y/o eventos en el archivo dwca
        occurrence_file_path = os.path.join(resource_path, "occurrence.txt")
        event_file_path = os.path.join(resource_path, "event.txt")
        if os.path.exists(occurrence_file_path):
            read_dwca_files(occurrence_file_path, 'occurrence', connection, cursor, resource_id)
        else:
            print(f"El archivo occurrence.txt no existe en el directorio especificado.")
        if os.path.exists(event_file_path):
            read_dwca_files(occurrence_file_path, 'event', connection, cursor, resource_id)
        else:
            print(f"El archivo event.txt no existe en el directorio especificado.")
        
        # Eliminar el directorio de trabajo temporal
        shutil.rmtree(resource_path)
        print(f"Archivo ZIP eliminado: {resource_path}")
    else:
        print(f"El archivo {file_url} no existe")


