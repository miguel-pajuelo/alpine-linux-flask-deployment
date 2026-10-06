# Comprobaciones de preparación

Fecha: 6 de octubre de 2026. Python 3.12.14 para las comprobaciones locales.

- Los tres scripts Bash pasan la comprobación de sintaxis `bash -n`; no se han ejecutado instalaciones ni descargas en Alpine.
- Las estadísticas y la selección Top N se han comprobado con tres registros sintéticos.
- El cliente realiza nueve POST y nueve GET correctamente contra un servidor HTTP local simulado. Se comprueban la clave `model`, los nombres de las nueve figuras y su escritura. Es una prueba del cliente; no entrena modelos ni certifica el servidor Flask externo.
- Los scripts Python se analizan sintácticamente sin errores.

Las figuras y documentos incluidos son evidencias históricas copiadas íntegramente. No se ha arrancado la OVA, descargado la distribución docente de Gowalla ni repetido el despliegue completo. Para validarlo, preparar Alpine, ejecutar el despliegue y comprobar las peticiones desde el anfitrión según el README.
