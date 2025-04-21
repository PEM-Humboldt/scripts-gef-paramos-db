# Scripts carga de datos para base GEF-P

Script de lectura y carga de datos de catálogos ceiba y biocultural a un servidor PostgreSQL utilizando conexión a base de datos y lectura e archivos .eml y .csv desde un directorio local en el sistema de archivos del servidor

El script se encuentra en modificación permanente.

## Prerequisitos

El script está desarrollado en Python versión 3.10, el cual se conecta a una base de datos PostgreSQL versión 14. Los requisitos están en el archivo de requirements.txt (psycopg2 conexión a postgres, pandas para manejo de archivos). También se tiene un archivo .env_template para definir las variables de conexión y otras de entorno.

```
Dar ejemplos
```

### [Opcional] Archivos Necesarios

URL para descargar los archivos y/o plantillas necesarias para descargar, antes de ejecutar cada script.

```
Da ejemplos, como nombres de conjuntos de datos y dónde descargarlos.
```

## Como ejecutar

Es preferible establecer un virtual environment para ejecutar el script.

python3 -m venv gef

source myvenv/bin/activate

Instalar los requerimientos con PIP

pip install -r requirements.txt

Hacer copia del archivo .env_template y dejarlo como .env

cp .env_template .env

Modificar los parámetros de conexión

vi .env

Ejecutar el script 

Di cuál será el paso.
```
Da el ejemplo
```

Y repetir
```
hasta terminar
```

**Termine con un ejemplo de cómo sacar algunos datos del sistema o usarlos para una pequeña demostración.**

## Autores(as) y contacto

* **Diego Moreno** - *PS* - [damorenov](https://github.com/damorenov)


## Licencia

Este proyecto está bajo la licencia MIT, 
mira la [LICENCIA](licencia.md) 
para obtener más detalles.


## [Opcional] Agradecimientos

* Un consejo para cualquiera cuyo código se haya utilizado
* Inspiración
* etc

## [Opcional] Contribuciones

Suele tener su propio archivo: [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426), que detalla el código de conducta y el proceso para enviarnos solicitudes de extracción (Pull Request).

[Regresar al inicio](README.md)