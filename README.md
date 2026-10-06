# Despliegue de Flask y análisis de datos sobre Alpine Linux

Proyecto académico de **Miguel Pajuelo Gómez y Jorge Ois de Pascual** para Fundamentos de los Sistemas Operativos, ICAI, Universidad Pontificia Comillas.

Automatización del despliegue de una aplicación Flask en una máquina virtual Alpine Linux, procesamiento de check-ins de Gowalla y descarga de resultados de entrenamiento desde el ordenador anfitrión. El servidor de aprendizaje automático procede del [framework externo ProyectoFUSO](https://github.com/pablosanchezp/ProyectoFUSO); aquí se presentan los scripts de despliegue, procesamiento y comunicación y las evidencias de la entrega.

## Recorrido por el proyecto

| Material | Función |
|---|---|
| `apartado1_MiguelPajuelo_JorgeOis.sh` | Instalación de paquetes en Alpine; ejecutar con permisos de administración. |
| `apartado_despliegue_bash_MiguelPajuelo_JorgeOis.sh` | Descarga del framework externo, creación del entorno e inicio de Flask. |
| `apartado3_MiguelPajuelo_JorgeOis.sh` | Procesamiento de Gowalla, estadísticas, selección de usuarios y mapas. |
| `stats_checker_JorgeOis_MiguelPajuelo.py` | Usuarios, lugares, filas y check-ins de julio/agosto. |
| `topn_selection_JorgeOis_MiguelPajuelo.py` | Selección de los usuarios con más check-ins. |
| `apartado4_JorgeOis_MiguelPajuelo.py` | POST de entrenamiento y GET de figuras para nueve repartos train/test. |
| [resultados/](resultados/) | Nueve figuras históricas de Iris incluidas en el material original. |
| [Memoria](documentacion/memoria.pdf) y [póster](documentacion/poster.pdf) | Explicación y presentación del proyecto entregado. |

## Preparación en Alpine Linux

El despliegue requiere Alpine Linux, conectividad y los paquetes `python3`, `py3-pip`, `python3-dev`, `git`, `bash`, `gcc`, `g++`, `musl-dev`, `linux-headers`, `wget`, `curl` y `unzip`. Instalar el conjunto con `apk add` desde una sesión con los permisos adecuados. El script histórico del apartado 1 usa el nombre `pip`; en versiones de Alpine que lo empaqueten como `py3-pip`, usar ese nombre al instalar.

Desde la carpeta del proyecto:

```sh
sh apartado_despliegue_bash_MiguelPajuelo_JorgeOis.sh
```

El servidor se clona en `ProyectoFUSO/` y el entorno se crea en `.venv/`. Ambos se excluyen de Git: el framework externo conserva su autoría y su propio historial. Consultar [PROCEDENCIA.md](PROCEDENCIA.md) para la referencia remota comprobada y los ajustes de portabilidad.

Para procesar Gowalla, preparar la distribución docente con `ElPasoGowalla.txt`, `GlasgowGowalla.txt`, `ManchesterGowalla.txt` y `WashingtonDCGowalla.txt` dentro de `DatasetsGowalla/`, y tener el framework clonado:

```sh
bash apartado3_MiguelPajuelo_JorgeOis.sh
```

El script conserva el enlace de Google Drive de la práctica y admite `GOWALLA_URL` como alternativa. No se ha comprobado la disponibilidad de ese enlace. El [dataset original de Gowalla en SNAP](https://snap.stanford.edu/data/loc-Gowalla.html) documenta el esquema usuario, fecha, latitud, longitud e identificador de lugar; el conjunto completo de SNAP necesita el filtrado por ciudades para reproducir esta distribución docente.

## Descarga desde el anfitrión

Crear un entorno Python e instalar `requests` en el ordenador que vaya a realizar las peticiones. Con Flask en marcha, indicar la IP de la máquina virtual y, si procede, el puerto. En PowerShell:

```powershell
$env:ALPINE_IP = "IP_DE_LA_MAQUINA_VIRTUAL"
$env:FLASK_PORT = "5000"
python apartado4_JorgeOis_MiguelPajuelo.py
```

En un shell POSIX, usar `export ALPINE_IP=...`. `.env.example` muestra los nombres de variables; no se carga automáticamente. Las nuevas descargas van a `descargas_resultados_flask/`; las evidencias originales están separadas en `resultados/`.

## Resultados y límites

![Resultado histórico de Iris: 70 % entrenamiento y 30 % prueba](resultados/irisTr0.7Tst0.3.png)

La memoria documenta la instalación, las peticiones, los mapas y la comparación de ejecución secuencial/paralela. Estas imágenes son resultados previos; la preparación del repositorio no ha repetido los entrenamientos ni arrancado la máquina virtual. Las OVA y los ZIP se conservan en el archivo local de la asignatura y se excluyen de esta carpeta por tamaño y redundancia. El repositorio contiene el material para estudiar y preparar el despliegue; el funcionamiento completo requiere el entorno descrito.

La validación del empaquetado está en [VALIDACION.md](VALIDACION.md).
