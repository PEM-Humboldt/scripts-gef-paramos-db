# Autor: Diego Moreno-Vargas (github.com/damorenov)
# Última modificación: 2025-01-15

# Importar librerías: OS para funciones de python, psycopg2 para conexión a PostgreSQL,
# dotenv para cargar variables de entorno desde un archivo .env en la raíz del proyecto,
# re para expresiones regulares, html para procesamiento de tags 
# xml.etree.ElementTree para manipulación de archivos XML y csv para lectura de archivos
# delimitados por caracteres.
import os
import psycopg2
import psycopg2.pool 

from dotenv import load_dotenv
from utils.functions import clean_text
from utils.catalogue_ceiba import process_ceiba
from utils.catalogue_geonetwork import process_geonetwork
from utils.catalogue_biocultural import process_biocultural


def main():
    # Cargar las variables del archivo .env que contiene las credenciales de la base de datos
    load_dotenv()

    # Leer las variables de entorno desde el archivo .env
    database_user = os.getenv('DATABASE_USER')
    database_pass = os.getenv('DATABASE_PASS')
    database_host = os.getenv('DATABASE_HOST')
    database_port = os.getenv('DATABASE_PORT')
    database_name = os.getenv('DATABASE_NAME')
    # ipt_resources_dir = os.getenv('IPT_RESOURCES_DIR')
    ipt_download_url_ceiba = os.getenv('IPT_DOWNLOAD_URL_CEIBA')
    ipt_download_url_dir = os.getenv('IPT_DOWNLOAD_URL_DIR')
    geonetwork_api_url = os.getenv('GEONETWORK_API_URL')
    geonetwork_user = os.getenv('GEONETWORK_USER')
    geonetwork_pass = os.getenv('GEONETWORK_PASS')
    dataverse_url = os.getenv('BIOCULTURAL_API_URL')
    biocultural_download_dir = os.getenv('BIOCULTURAL_DOWNLOAD_DIR')

    # probar la conexión a la base de datos con las variables de entorno creando un pool de conexiones para mantener
    # la conexión abierta y usarla en el resto del código
    try:
        pool = psycopg2.pool.SimpleConnectionPool(1, 3,
            user=database_user,
            password=database_pass,
            host=database_host,
            port=database_port,
            database=database_name,
            options="-c client_encoding=UTF8" 
        )
        connection = pool.getconn()
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
            # De acuerdo al catalogador, se llama a la función correspondiente para procesar el recurso
            if(catalogue == 'ceiba'):
                """Llamada a la función process_ceiba para procesar el recurso de Ceiba.
                
                Args:
                    connection: Conexión a la base de datos PostgreSQL.
                    cursor: Cursor para ejecutar consultas SQL.
                    ipt_resources_dir: Directorio donde se almacenan los recursos IPT.
                    identifier: Identificador del recurso.
                    resource_id: ID del recurso en la base de datos.

                Returns:
                    None
                """
                process_ceiba(connection, cursor, ipt_download_url_ceiba, ipt_download_url_dir, identifier, resource_id)
            elif(catalogue == 'geonetwork'):
                """Llamada a la función process_geonetwork para procesar el recurso de Geonetwork.
                Args:
                    connection: Conexión a la base de datos PostgreSQL.
                    cursor: Cursor para ejecutar consultas SQL.
                    geonetwork_api_url: URL de la API de Geonetwork.
                    geonetwork_user: Usuario para autenticación en Geonetwork.
                    geonetwork_pass: Contraseña para autenticación en Geonetwork.
                    identifier: Identificador del recurso.
                    resource_id: ID del recurso en la base de datos.
                Returns:
                    None"""
                process_geonetwork(connection, cursor, geonetwork_api_url, geonetwork_user, geonetwork_pass, identifier, resource_id)
            elif(catalogue == 'biocultural'):
                """Llamada a la función process_biocultural para procesar el recurso de Biocultural.
                Args:
                    connection: Conexión a la base de datos PostgreSQL.
                    cursor: Cursor para ejecutar consultas SQL.
                    dataverse_url: URL de la API de Biocultural.
                    dataverse_token: Token para autenticación en Biocultural.
                    identifier: Identificador del recurso.
                    resource_id: ID del recurso en la base de datos.
                Returns:
                    None
                """
                process_biocultural(connection, cursor, dataverse_url, biocultural_download_dir, identifier, resource_id)      
            else:
                print("El catalogador no está definido, se omite el procesamiento.")
                continue
    except (Exception, psycopg2.Error) as error:
        # Si se presenta error en la conexión de la base de datos, se imprime en consola.
        print(f"Error de conexión a PostgreSQL: {error}")
    finally:
        # Se ejecuta en cualquier caso para cerrar el pool de conexión a la base de datos.
        # Si la conexión fue exitosa, se cierra la conexión. 
        if pool:
            cursor.close()
            pool.putconn(connection)
            pool.closeall()
            print("Conexión a PostgreSQL cerrada")

if __name__ == "__main__":
    main()