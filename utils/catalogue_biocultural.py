import os
import requests
from utils.functions import update_resource
from dotenv import load_dotenv


def process_biocultural(connection, cursor, dataverse_url, biocultural_download_dir, identifier, resource_id):
    """Función process_biocultural para procesar recursos desde el catalogador biocultural.

    La función procesa un metadato en formato XML desde la API de Biocultura en dataverse y actualiza
    la base de datos con el título del recurso.
    en un directorio local. Si el archivo no existe, se informa al usuario.
    Se requiere la librería dotenv para cargar las variables de entorno desde un archivo .env.
    Se requiere la librería os para manejar rutas de archivos y directorios.
    Se requiere la librería requests para manejar solicitudes HTTP.

    Se lee desde la tabla de resources el indentificador y se revisa, se conecta a la API de biocultural y se llena la información

    Args:
        connection: Conexión a la base de datos PostgreSQL.
        cursor: Cursor para ejecutar consultas SQL.
        dataverse_url: URL base de la API de biocultural.
        dataverse_token: Token de autenticación para la API de biocultural.
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
       
    header = os.getenv('BIOCULTURAL_API_TOKEN')
    headers = {'X-Dataverse-key': header}

    biocultural_download_dir = os.getenv('BIOCULTURAL_DOWNLOAD_DIR')

    try:
        # Se contruye la URL de la API de biocultural con el identificador    
        url_metadata = f"{dataverse_url}/datasets/:persistentId/?persistentId={identifier}"
        print(f"Consultando Biocultural API: {url_metadata}")
        response = requests.get(url_metadata, headers=headers)
        response.raise_for_status()  # Error en caso de excepción HTTP
        # Se obtiene la información del JSON de la respuesta
        data =  response.json()
        title_element = data['data']['latestVersion']['metadataBlocks']['citation']['fields'][0]['value'] if 'data' in data and 'latestVersion' in data['data'] and 'metadataBlocks' in data['data']['latestVersion'] and 'citation' in data['data']['latestVersion']['metadataBlocks'] and 'fields' in data['data']['latestVersion']['metadataBlocks']['citation'] and len(data['data']['latestVersion']['metadataBlocks']['citation']['fields']) > 0 else 'No contiene título'
        pubDate_element = data['data']['publicationDate'] if 'data' in data and 'publicationDate' in data['data'] else 'No contiene título'
        abstract_element = data['data']['latestVersion']['metadataBlocks']['citation']['fields'][3]['value'][0]['dsDescriptionValue']['value'] if 'data' in data and 'latestVersion' in data['data'] and 'metadataBlocks' in data['data']['latestVersion'] and 'citation' in data['data']['latestVersion']['metadataBlocks'] and 'fields' in data['data']['latestVersion']['metadataBlocks']['citation'] and len(data['data']['latestVersion']['metadataBlocks']['citation']['fields']) > 1 else 'No contiene resumen'
        update_resource(connection, cursor, resource_id, title_element, pubDate_element, abstract_element, 'biocultural')

        # Se contruye la URL de descarga de los archivos
        url_download = f"{dataverse_url}/access/dataset/:persistentId/?persistentId={identifier}"
        
        if not os.path.exists(biocultural_download_dir + "/" + 'resource'):
            os.makedirs(biocultural_download_dir + "/" + 'resource')
            path_exists = True
        # Rutas para recursos descargados
        resource_path = os.path.join(biocultural_download_dir, 'resource')
        zip_file_path = os.path.join(resource_path, f"biocultural.zip")

        # Descargar el archivo
        with requests.get(url_download, headers=headers, stream=True) as r:
            r.raise_for_status()
            with open(zip_file_path, 'wb') as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)
        print(f"Archivo descargado: {zip_file_path}")

    except requests.exceptions.RequestException as e:
        print(f"Error al conectar con dataverse api: {e}")
    except Exception as e:
        print(f"Error inesperado: {e}")    