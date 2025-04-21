import html
import requests
import zipfile
import re
import os
import csv
import xml.etree.ElementTree as ET
from dotenv import load_dotenv

#  Función para limpiar texto importado desde XML
def clean_text(text):
    """ 
    Función para limpiar texto importado desde diferentes fuentes.
    
    Args:
        text (str): Texto a limpiar.
    Returns:
        str: Texto limpio de entidades html y espacios al principio y final.
    """
    text = html.unescape(text)  # Eliminar entidades HTML
    text = re.sub(r'\s+', ' ', text)  # Reemplazar múltiples espacios por uno solo
    return text.strip()  # Eliminar espacios al inicio y al final

def update_resource(connection, cursor, resource_id, title_element, publication_element, abstract_element, catalogue):
    """
    Función para actualizar los valores de un recurso en la tabla resources.
    
    Args:
        connection: Conexión a la base de datos PostgreSQL.
        cursor: Cursor para ejecutar consultas SQL.
        resource_id (int): ID del recurso a actualizar.
        title_element (str): Título del recurso.
        publication_date_element (str): Fecha de publicación del recurso.
        abstract_element (str): Resumen del recurso
        catalogue (str): Nombre del catálogo del que proviene el recurso.
    """
    title = None
    publication_date = None
    abstract = None
    if catalogue == 'biocultural':
        title = clean_text(title_element) if title_element else 'No contiene título'
        publication_date = clean_text(publication_element) if publication_element else 'No contiene fecha de publicación'
        abstract = clean_text(abstract_element) if abstract_element else 'No tiene resumen'
    else:
        print(f"Elemento title: {title_element.text}")
        title = clean_text(title_element.text) if title_element.text else 'No contiene título'
        publication_date = clean_text(publication_element.text) if publication_element.text else 'No contiene fecha de publicación'
        abstract = clean_text(abstract_element.text) if abstract_element.text else 'No tiene resumen'

    update_query = "UPDATE resources SET title = %s, publication_date = %s, abstract = %s WHERE resource_id = %s"
    try:
        cursor.execute(update_query, (title, publication_date, abstract, resource_id))
        connection.commit()
        print(f"Valores actualizados para resource_id: {resource_id}")
    except (Exception) as error:
    # Si se presenta error en la conexión de la base de datos, se imprime en consola.
        print(f"Error de conexión a PostgreSQL: {error}")
        
def read_dwca_files(file_path, table, connection, cursor, resource_id):
    """
    Función para leer archivos ocurrence y event desde un dwca y guardar los datos en la tabla correspondiente.
    
    Args:
        file_path (str): Ruta del archivo de ocurrence/events.
        table (str): Nombre de la tabla donde se guardarán los datos.
        connection: Conexión a la base de datos PostgreSQL.
        cursor: Cursor para ejecutar consultas SQL.
        resource_id (INT): ID del recurso en la base de datos para relacionar los datos.
    
    Returns:
        None
    
    Raises:
        FileNotFoundError: Si el archivo no se encuentra en la ruta especificada.
        csv.Error: Si hay un error al leer el archivo CSV.  
    """
    # Define las columnas que se desean insertar en la tabla
    # Se filtra el archivo csv y se copian las columnas que se van a insertar
    # de acuerdo con el tipo de dato: Occurrence o Event
    occurrence_columns = ['occurrenceID', 'basisOfRecord', 'type', 'institutionCode', 'institutionID', 'recordNumber', 'recordedBy', 'individualCount', 'organismQuantity', 'organismQuantityType', 'sex', 'lifeStage', 'occurrenceStatus', 'preparations', 'disposition', 'occurrenceRemarks', 'eventID', 'eventType', 'samplingProtocol', 'samplingEffort', 'eventDate', 'eventTime', 'habitat', 'eventRemarks', 'continent', 'country', 'countryCode', 'stateProvince', 'county', 'municipality', 'locality', 'minimumElevationInMeters', 'maximumElevationInMeters', 'locationRemarks', 'verbatimLatitude', 'verbatimLongitude', 'decimalLatitude', 'decimalLongitude', 'geodeticDatum', 'coordinateUncertaintyInMeters', 'identifiedBy', 'dateIdentified', 'identificationRemarks', 'identificationQualifier', 'scientificName', 'scientificNameAuthorship', 'kingdom', 'phylum', 'class', 'order', 'superfamily', 'family', 'subfamily', 'tribe', 'subtribe', 'genus', 'subgenus', 'specificEpithet', 'infraspecificEpithet', 'taxonRank', 'vernacularName', 'taxonRemarks']
    event_columns = ['eventID', 'eventType', 'samplingProtocol', 'sampleSizeValue', 'sampleSizeUnit', 'samplingEffort', 'eventDate', 'habitat', 'eventRemarks', 'institutionCode', 'continent', 'country', 'countryCode', 'stateProvince', 'county', 'locality', 'minimumElevationInMeters', 'maximumElevationInMeters', 'locationRemarks', 'decimalLatitude', 'decimalLongitude', 'geodeticDatum', 'coordinateUncertaintyInMeters']
    # Selecciona las columnas de acuerdo al tipo de tabla
    selected_columns = occurrence_columns if table == 'occurrence' else event_columns  
    with open(file_path, 'r', encoding='utf-8') as file:
        # Se lee el archivo con la librería csv y se define el delimitador de tabulación
        try:
            reader = csv.DictReader(file, delimiter='\t')
            for row in reader:
                # Filtrar las columnas que se desean insertar en la tabla
                filtered_row = {col: row[col] for col in selected_columns if col in row}
                # Agrega el campo para relacionar el recurso
                filtered_row['resource_id'] = int(resource_id)
                # Envolver los nombres de las columnas en comillas dobles para no tener problemas con palabras reservadas
                # También se convierte el nombre de la columna a minúsculas por conflictos en sentencias SQL
                columns = ', '.join([f'"{col.lower()}"' for col in filtered_row.keys()])
                placeholders = ', '.join(['%s'] * len(filtered_row))
                insert_query = f"INSERT INTO ceiba_" + table + f" ({columns}) VALUES ({placeholders})"
                cursor.execute(insert_query, list(filtered_row.values()))
                connection.commit()
            print(f"filas insertadas en la tabla ceiba para resource_id: {resource_id}")
        except csv.Error as e:
            print(f"Error al leer el archivo {file_path}: {e}")

def download_and_decompress_file(file_url, download_dir, identifier, catalogue):
    """
    Función para descargar un archivo desde una URL y guardarlo en un directorio específico.
    
    Args:
        file_url (str): URL del archivo a descargar.
        download_dir (str): Directorio donde se guardará el archivo descargado.
        identifier (str): Identificador del recurso.
    
    Returns:
        str: Ruta completa del archivo descargado.
    
    Raises:
        requests.exceptions.RequestException: Si hay un error en la solicitud de descarga del archivo.
    """

    
    # Cargar las variables de entorno desde el archivo .env para encabezados.
    # Se usa el User:agent para evitar bloqueos por error 403 por parte del servidor de Ceiba. 
    load_dotenv()
    header = None
    headers = None

    if catalogue == 'ceiba':
        header = os.getenv('USER_AGENTS')
        headers = {'User-Agent': header} 

    if catalogue == 'biocultural':
        header = os.getenv('BIOCULTURAL_API_TOKEN')
        headers = {'X-Dataverse-key': header}

    # Variable para indicar si existe un archivo dwca.zip descargado para el recurso y poder procesarlo
    zip_exists = False
    # Variable para indicar si al menos se descargó un archivo ZIP para proceder a borrarlo al finalizar del procesamiento
    path_exists = False

    # Verificar si el archivo existe en la URL
    response = requests.head(file_url, headers=headers)
    # Verificar el código de estado de la respuesta. 200: archivo encontrado, 404: archivo no encontrado
    if response.status_code == 200:

        # Rutas para recursos descargados
        resource_path = os.path.join(download_dir, identifier)

        if not os.path.exists(resource_path):
            os.makedirs(resource_path)
            path_exists = True

        # Rutas para zip
        zip_file_path = os.path.join(resource_path, 'dwca.zip')

        try:
            response = requests.get(file_url, headers=headers, stream=True)
            response.raise_for_status()  # Verifica si la solicitud fue exitosa
            with open(zip_file_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            print(f"Archivo descargado: {zip_file_path}")
        except requests.exceptions.RequestException as e:
            print(f"Error al descargar el archivo: {e}")

        # Descomprimir el archivo ZIP
        try:
            with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
                zip_ref.extractall(resource_path)
            print(f"Archivo descomprimido")
            zip_exists = True
        except zipfile.BadZipFile:
            print(f"Error: El archivo descargado no es un archivo ZIP válido.")
            zip_exists = False
        return zip_exists
    else:
        return zip_exists

def read_files_ceiba_directly(connection, cursor, ipt_resources_dir, identifier, resource_id):
    """Función para leer archivos directamente desde el directorio de recursos IPT.

    (Obsoleto) esta función se usa para el acceso a los achivos de ceiba directamente. Se debe
    ejecutar el script en el servidor, pero no se puede asegurar la instalación de requerimientos
    en el ambiente de producción

    Args:
        connection: Conexión a la base de datos PostgreSQL.
        cursor: Cursor para ejecutar consultas SQL.
        ipt_resources_dir: Ruta del directorio donde se almacenan los recursos IPT.
        identifier: Identificador del recurso.
        resource_id: ID del recurso en la base de datos.
    Returns:
        None
    """
    # Genera la ruta completa al directorio al recurso que se está iterando
    identifier_path = os.path.join(ipt_resources_dir, identifier)
    # Verifica si el directorio existe y que sea un directorio
    if os.path.exists(identifier_path) and os.path.isdir(identifier_path):
        # Genera un listado con los archivos en el directorio y filtra los archivos que coincidan
        # con la expresion regular de nombre eml.xml o eml-X.X.xml
        eml_files = [f for f in os.listdir(identifier_path) if re.match(r'eml(-\d+\.\d+)?\.xml$', f)]
        # Se comprueba si hay archivos eml.xml en el directorio
        if eml_files:
            # Ordenar los archivos por versión y obtener el último, se utiliza una expresión lambda
            # que toma los nombres de los archivos eml (x), busca si el archivo tiene o no version y crea una lista
            # con los números de versión, si no tiene versión se asigna [0, 0].
            # Los archivos se ordenarán primero por la primera versión (mayor número) y luego por la segunda versión (menor número).
            eml_files.sort(key=lambda x: [int(num) for num in re.findall(r'\d+', x)] if '-' in x else [0, 0])
            # Se obtiene el último archivo de la lista ordenada
            latest_eml = eml_files[-1]
            print(f"Última versión del archivo eml.xml: {latest_eml}")
            # Se genera la ruta completa a la última versión del archivo eml
            eml_path = os.path.join(identifier_path, latest_eml)
            # Se lee el archivo eml.xml con la librería ElementTree
            tree = ET.parse(eml_path)
            # Se obtiene la raíz del la última versión de archivo eml
            root = tree.getroot()
            # Obtener valores de los nodos (ejemplo: título, fecha), y limpiados de caracteres
            title = clean_text(root.find('.//title').text if root.find('.//title') is not None else 'No contiene título')
            publication_date = clean_text(root.find('.//pubDate').text if root.find('.//pubDate') is not None else 'No contiene fecha de publicación')
            abstract = clean_text(root.find('.//abstract/para').text if root.find('.//abstract/para') is not None else 'No tiene resumen')
            # Se genera una sentencia de actualizacion de la tabla resources con los valores definidos para placeholders
            update_query = "UPDATE resources SET title = %s, publication_date = %s, abstract = %s WHERE resource_id = %s"
            cursor.execute(update_query, (title, publication_date, abstract, resource_id))
            connection.commit()
            print(f"Valores actualizados para resource_id: {resource_id}")
            # Leer el archivo ocurrence.txt y guardar los datos en la tabla biological_data
            # Se genera la ruta completa al archivo event.txt de cada recurso
            event_path = os.path.join(identifier_path + 'sources', 'event.txt')
            # Se confirma la existencia del archivo event_path
            if os.path.exists(event_path):
                # Se abre el archivo para lectura. Se asume codificación utf-8 por defecto.
                with open(event_path, 'r', encoding='utf-8') as file:
                    # Se lee el archivo con la librería csv y se define el delimitador de tabulación
                    reader = csv.DictReader(file, delimiter='\t')
                    for row in reader:
                        row_counter = 0 # Contador de filas
                        # Asumiendo que las columnas del archivo event.txt coinciden con las de la tabla ceiba
                        columns = ', '.join(row.keys()) + ', resource_id'
                        placeholders = ', '.join(['%s'] * len(row)) + ', %s'
                        insert_query = f"INSERT INTO ceiba_events ({columns}) VALUES ({placeholders})"
                        cursor.execute(insert_query, list(row.values()))
                    connection.commit()
                    print(f"{row_counter} filas insertadas en la tabla ceiba para resource_id: {resource_id}")
            else:
                print(f"No se encontró el archivo event.txt en la carpeta {identifier}.")
        else:
            print("No se encontraron archivos eml.xml en la carpeta.")            
    else:
        print(f"La carpeta {identifier} no existe o no es un directorio.")