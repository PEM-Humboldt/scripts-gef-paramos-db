# Scripts carga de datos para base GEF-P

Script de lectura y carga de datos de catálogos ceiba y biocultural a un servidor PostgreSQL utilizando conexión a base de datos y lectura de archivos a través de descargas y API

El script se encuentra en modificación permanente.

## Prerequisitos

El script está desarrollado en Python versión 3.10, el cual se conecta a una base de datos PostgreSQL versión 14. Los requisitos están en el archivo de requirements.txt (psycopg2 conexión a postgres, request para descargas y llamados a API, y python-dotenv para carga de datos desde un archivo de variables de entorno). También se tiene un archivo .env_template para definir las variables de conexión y otras configuraciones

Se debe restaurar la base de datos en blanco (encontrada dentro de la carpeta dump). El nombre por defecto de la base de datos es `gef`. El dump es un archivo plano por lo que se puede restaurar con el comando `psql gef < dump_gef_blankdb.sql`.
También es preferible utilizar un usuario y contraseña con privilegios de consulta, actualización, inserción y borrado sólo a esta base de datos.

### Archivos Necesarios

Dentro de la base de datos se encuentra la tabla _resources_, que es el origen para generación de las URL para consulta y/o descarga de archivos.

Las columnas que se deben llenar para funcionamiento son:
* identifier: Nombre corto o identificador del recurso según el catalogador
* catalogue: Catalogador de origen del recurso. Es un valor de 3 posibles: ceiba, geonetwork, biocultural

El identificador es dependiente de cada catalogador:
* Ceiba: Es el nombre corto del recurso. Por ejemplo, del recurso con URL https://i2d.humboldt.org.co/resource?r=rrbb_paramos_plantae_2017 es el valor después de `r=` el cual es __rrbb_paramos_plantae_2017__
* Geonetwork: Es el UUID o identificador. Por ejemplo, del recurso con URL https://geonetwork.humboldt.org.co/geonetwork/srv/spa/catalog.search#/metadata/b1ad521f-4a2b-46ac-a644-807bf43360a7 es el valor después de /metadata/ o __b1ad521f-4a2b-46ac-a644-807bf43360a7__
* Biocultural: Es el doi del recurso. Por ejemplo para la URL http://ec2-34-238-22-20.compute-1.amazonaws.com:8080/dataset.xhtml?persistentId=doi:10.21068/WK1KS4 es el valor después de `persistentId=` para el ejemplo __doi:10.21068/WK1KS4__ . Es importante que en el identifier quede la palabra doi:

Por lo que en la base de datos se debe crear las filas al menos con identificador y catalogador de origen.

## Como ejecutar

Clonar el código

Es preferible establecer un virtual environment para ejecutar el script.
```
python3 -m venv myvenv
source myvenv/bin/activate
```
(Se puede cambiar `myvenv` con otro nombre)

Instalar los requerimientos con PIP
```
pip install -r requirements.txt
```

Hacer copia del archivo .env_template y dejarlo como .env
```
cp .env_template .env
```
Modificar los parámetros dentro del .env
```
vi .env
```

Ejecutar el script 

```
python3 main.py
```

Un ejemplo de ejecución se encuentra dentro de la carpeta dump con la base de datos dump-gef-202504211642.sql

## Problemas conocidos

Cuando se ejecuta el código para consulta del API del geonetwork, se puede presentar error 400 en varios intentos de consulta. No se ha determinado la razón del error, pero se considera que es por la respuesta del API desde el geonetwork por que se presenta respuesta, a veces en el primer intento. 

## Autores(as) y contacto

* **Diego Moreno** - *PS* - [damorenov](https://github.com/damorenov)


## Licencia

Este proyecto está bajo la licencia MIT, 
mira la [LICENCIA](https://mit-license.org/) 
para obtener más detalles.
