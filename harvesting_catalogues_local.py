# Script de lectura y carga de datos de catálogos ceiba y biocultural a un servidor
# PostgreSQL utilizando conexión a base de datos y lectura e archivos .eml y .csv
# desde un directorio local en el sistema de archivos del servidor
# Autor: Diego Moreno-Vargas (github.com/damorenov)
# Última modificación: 2025-01-15

# Importar librerías: OS para funciones de python, psycopg2 para conexión a PostgreSQL,
# dotenv para cargar variables de entorno desde un archivo .env en la raíz del proyecto,
# re para expresiones regulares, html para procesamiento de tags 
# xml.etree.ElementTree para manipulación de archivos XML y csv para lectura de archivos
# delimitados por caracteres.
import os
import psycopg2
import re
import html
import xml.etree.ElementTree as ET
import csv
from dotenv import load_dotenv

# Función para limpiar texto importado desde XML
def clean_text(text):
    text = html.unescape(text)  # Eliminar entidades HTML
    text = re.sub(r'\s+', ' ', text)  # Reemplazar múltiples espacios por uno solo
    text = re.sub(r'[^\x20-\x7E]', '', text)  # Eliminar caracteres no imprimibles
    return text.strip()  # Eliminar espacios al inicio y al final

# Cargar las variables del archivo .env que contiene las credenciales de la base de datos
load_dotenv()

# Leer las variables de entorno desde el archivo .env
database_user = os.getenv('DATABASE_USER')
database_pass = os.getenv('DATABASE_PASS')
database_host = os.getenv('DATABASE_HOST')
database_port = os.getenv('DATABASE_PORT')
database_name = os.getenv('DATABASE_NAME')
ipt_resources_dir = os.getenv('IPT_RESOURCES_DIR')


# probar la conexión a la base de datos con los la variables de entorno
try:
    connection = psycopg2.connect(
        user=database_user,
        password=database_pass,
        host=database_host,
        port=database_port,
        database=database_name
    )
    # se crea el cursor para ejecutar la consulta sobre la tabla de resources en la base de datos
    cursor = connection.cursor()
    # Ejecuta la consulta para seleccionar todos los registros de la tabla resources
    cursor.execute("SELECT resource_id, identifier, url, catalogue, timestamp_created, timestamp_modified, harvested FROM resources;")
    # almacena los registros en la variable resources
    resources = cursor.fetchall()
    # Itera todos los registros de la variable resources
    for resource in resources:
        # La siguiente linea descompone la tupla en variables individuales
        resource_id, identifier, url, catalogue, timestamp_created, timestamp_modified, harvested = resource
        print(f"resource_id: {resource_id}, identifier: {identifier}, url: {url}, catalogue: {catalogue}, timestamp_created: {timestamp_created}, timestamp_modified: {timestamp_modified}, harvested: {harvested}")
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
                # Se genera una sentencia de actualizacion de la tabla resources con los valores definidos para placeholders
                update_query = "UPDATE resources SET title = %s, publication_date = %s WHERE resource_id = %s"
                cursor.execute(update_query, (title, publication_date, resource_id))
                connection.commit()
                print(f"Valores actualizados para resource_id: {resource_id}")
                # Leer el archivo ocurrence.txt y guardar los datos en la tabla biological_data
                # Se genera la ruta completa al archivo ocurrence.txt de cada recurso
                ocurrence_path = os.path.join(identifier_path, 'ocurrence.txt')
                # Se confirma la existencia del archivo ocurrence.txt
                if os.path.exists(ocurrence_path):
                    # Se abre el archivo para lectura. Se asume codificación utf-8 por defecto.
                    with open(ocurrence_path, 'r', encoding='utf-8') as file:
                        # Se lee el archivo con la librería csv y se define el delimitador de tabulación
                        reader = csv.DictReader(file, delimiter='\t')
                        for row in reader:
                            # Asumiendo que las columnas del archivo ocurrence.txt coinciden con las de la tabla biological
                            columns = ', '.join(row.keys())
                            placeholders = ', '.join(['%s'] * len(row))
                            insert_query = f"INSERT INTO biological ({columns}) VALUES ({placeholders})"
                            cursor.execute(insert_query, list(row.values()))
                        connection.commit()
                        print(f"Datos insertados en la tabla biological para resource_id: {resource_id}")
                else:
                    print(f"No se encontró el archivo ocurrence.txt en la carpeta {identifier}.")
            else:
                print("No se encontraron archivos eml.xml en la carpeta.")            
        else:
            print(f"La carpeta {identifier} no existe o no es un directorio.")

except (Exception, psycopg2.Error) as error:
    # Si se presenta error en la conexión de la base de datos, se imprime en consola.
    print(f"Error de conexión a PostgreSQL: {error}")
finally:
    # Se ejecuta en cualquier caso para cerrar la conexión a la base de datos.
    # Si la conexión fue exitosa, se cierra la conexión. 
    if connection:
        cursor.close()
        connection.close()
        print("Conexión a PostgreSQL cerrada")