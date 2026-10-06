#!/bin/bash

# ==============================================================================
# Ejercicio 3: Script para Descarga, Procesamiento de Datos y Generación de Mapas
# Nombres de la pareja: Jorge Ois y Miguel Pajuelo
# ==============================================================================


# Ejecutar respecto a esta carpeta, independientemente del directorio de llamada.
set -e
cd "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Variables para bash
URL="${GOWALLA_URL:-https://drive.google.com/uc?export=download&id=1PHWBGuwDHw4ZEIlCbgMTiEUrG8FmlJK2}"
PATH_MAIN_PYTHON="ProyectoFUSO/generate_maps.py"
PATH_INDIVIDUAL_PYTHON="ProyectoFUSO/generate_individual_maps.py"
PATH_GOWALLA_FILES="DatasetsGowalla/"
PATH_OUTPUT_GOWALLA_FILES="ProyectoFUSO/templates/html_files/"
ARCHIVO_ZIP="DatasetsGowalla.zip"
PATH_GOWALLA_FILES="DatasetsGowalla/" 

# Variables para los scripts Python
SCRIPT_STATS_PYTHON="stats_checker_JorgeOis_MiguelPajuelo.py"
SCRIPT_TOPN_PYTHON="topn_selection_JorgeOis_MiguelPajuelo.py"
VENV_PATH="./.venv" 

# Ficheros de datos principales (sin la extensión .txt)
CIUDADES=("ElPaso" "Glasgow" "Manchester" "WashingtonDC")
ALL_LOCATIONS_FILE="ALL_LOCATIONS.txt"
FILTERED_DIR="FilteredDatasets/"

echo "---------------------------------------------------------"
echo "INICIO DEL EJERCICIO 3: DESCARGA Y PROCESAMIENTO DE DATOS"
echo "---------------------------------------------------------"

# Activamos el entorno virtual al principio para usar Python 3 más fácilmente
if [ -d "$VENV_PATH" ]; then
    source "$VENV_PATH/bin/activate"
    echo "   Entorno virtual activado."
else
    echo "   ADVERTENCIA: No se encontró el entorno virtual en $VENV_PATH."
fi


# 1. Descargar el conjunto de datos (si no existe)
if [ ! -f "$ARCHIVO_ZIP" ]; then
    echo "1. Descargando el archivo ZIP de Gowalla."
    wget "$URL" -O "$ARCHIVO_ZIP"
else
    echo "1. El archivo $ARCHIVO_ZIP ya existe. Saltando descarga."
fi

# 2. Descomprimir el archivo (si el directorio de datos no existe)
if [ ! -d "$PATH_GOWALLA_FILES" ]; then
    echo "2. Descomprimiendo $ARCHIVO_ZIP..."
    unzip "$ARCHIVO_ZIP"
else
    echo "2. El directorio $PATH_GOWALLA_FILES ya existe. Saltando descompresión."
fi

# 3. Procesamiento de Ficheros y Estadísticas
echo -e "\n3. Procesando archivos de ciudad y calculando estadísticas:"

# Crear/vaciar el archivo ALL_LOCATIONS.txt
> "$ALL_LOCATIONS_FILE" 

# Crear el directorio para los ficheros filtrados si no existe
mkdir -p "$FILTERED_DIR"


# Bucle para procesar cada fichero .txt dentro del directorio DatasetsGowalla
for fichero in "$PATH_GOWALLA_FILES"/*Gowalla.txt; do
    # Verificación de que el fichero existe para evitar errores en el loop
    # Extraemos el nombre de la ciudad
    BASENAME=$(basename "$fichero" .txt)
    CIUDAD=$(echo "$BASENAME" | sed "s/Gowalla//") # sed elimina Gowalla del basename
    
    # Definición del fichero filtrado (usando la convención de la sección 5 del PDF)
    FILTERED_FILE="$FILTERED_DIR/${CIUDAD}Filtered.txt"

    echo -e "\n-----------------------------------------------------"
    echo "   Procesando: $BASENAME"
    echo "-----------------------------------------------------"

    # Parte A: Redirigir columnas 3, 4 y 5 a ALL_LOCATIONS.txt (latitud, longitud, lugar_id)
    cut -f 3,4,5 "$fichero" >> "$ALL_LOCATIONS_FILE"
    echo "   -> Columnas 3,4 y 5 añadidas a $ALL_LOCATIONS_FILE"

    # Parte B: Redirigir columnas 1, 2 y 5 a <ciudad>filtered.txt (usuario_id, fecha, lugar_id)
    cut -f 1,2,5 "$fichero" > "$FILTERED_FILE"
    echo "   -> Columnas 1, 2 y 5 guardadas en $FILTERED_FILE"

    # Parte C: Estadísticas usando comandos Bash (usando -f para tabulador explícito)
    echo -e "\n   [Estadísticas en Bash]"
    NUM_FILAS=$(wc -l < "$fichero")
    NUM_USUARIOS=$(cut -f1 "$fichero" | sort -u | wc -l)
    NUM_LUGARES=$(cut -f5 "$fichero" | sort -u | wc -l)
    CHECKINS_JUL=$(grep -c "2010-07" "$fichero" || true) 
    CHECKINS_AUG=$(grep -c "2010-08" "$fichero" || true) 

    echo "Estadisticas para ${CIUDAD}.txt"
    echo "Numero de usuarios distintos      : $NUM_USUARIOS"
    echo "Numero de localizaciones distintas: $NUM_LUGARES"
    echo "Numero de filas completas         : $NUM_FILAS"
    echo "Numero de check-ins en 2010-07    : $CHECKINS_JUL"
    echo "Numero de check-ins en 2010-08    : $CHECKINS_AUG"

    # Parte D: Estadísticas usando el script Python para comparación
    if [ -f "$SCRIPT_STATS_PYTHON" ]; then
        echo -e "\n   [Estadísticas en Python para comparación]"
        python3 "$SCRIPT_STATS_PYTHON" "$fichero"
    else
        echo " Error: No se encontró el script $SCRIPT_STATS_PYTHON. Saltando comparación con Python."
    fi
done

# 4. Generación de Mapas de Ciudad (generate_maps.py)
echo -e "\n4. Generación de Mapas de Ciudad (generate_maps.py)"
mkdir -p "$PATH_OUTPUT_GOWALLA_FILES" # Asegura que el directorio de salida existe

for CIUDAD_NAME in "${CIUDADES[@]}"; do
    INPUT_FILE="$PATH_GOWALLA_FILES/${CIUDAD_NAME}Gowalla.txt"
    OUTPUT_HTML_NAME="${CIUDAD_NAME}GowallaMap.html"
    OUTPUT_PATH="$PATH_OUTPUT_GOWALLA_FILES/$OUTPUT_HTML_NAME"

    echo "   -> Generando mapa para $CIUDAD_NAME..."
    # Se llama al script Python
    python3 "$PATH_MAIN_PYTHON" --input_file "$INPUT_FILE" --city_name "$CIUDAD_NAME" --output_html "$OUTPUT_PATH"
done


# 5. Generación de Mapas Individuales de Usuarios Seleccionados
# Se selecciona un usuario de cada ciudad que tenga al menos 2 visitas distintas.
echo -e "\n5. Generación de Mapas Individuales de Usuarios Seleccionados (Verificados en datos reales)"
# IDs verificados manualmente de los ficheros para asegurar mas de 2 check-ins
USUARIOS_SELECCIONADOS=(
    "ElPaso:667"        
    "Glasgow:268"       
    "Manchester:759"    
    "WashingtonDC:22" 
)

for ITEM in "${USUARIOS_SELECCIONADOS[@]}"; do
    # Separamos el string en CIUDAD_NAME y USER_ID
    IFS=":" read -r CIUDAD_NAME USER_ID <<< "$ITEM"
    INPUT_FILE="$PATH_GOWALLA_FILES/${CIUDAD_NAME}Gowalla.txt"
    OUTPUT_HTML_NAME="${CIUDAD_NAME}_User${USER_ID}_Map.html"
    OUTPUT_PATH="$PATH_OUTPUT_GOWALLA_FILES/$OUTPUT_HTML_NAME"

    echo "   -> Generando mapa para el usuario $USER_ID en $CIUDAD_NAME..."
    # Se llama al script Python individual
    python3 "$PATH_INDIVIDUAL_PYTHON" --input_file "$INPUT_FILE" --city_name "$CIUDAD_NAME" --user_id "$USER_ID" --output_html "$OUTPUT_PATH"
done

# 6. Implementación Python Adicional (Top N)
echo -e "\n6. Cálculo de Top 5 Usuarios por Ciudad y Generación de Mapas Individuales"

if [ -f "$SCRIPT_TOPN_PYTHON" ]; then
    for CIUDAD_NAME in "${CIUDADES[@]}"; do
        INPUT_FILTERED_FILE="$FILTERED_DIR/${CIUDAD_NAME}Filtered.txt"
        TOPN_OUTPUT_FILE="${CIUDAD_NAME}Gowalla_top5.txt"
        TOP_N=5

        echo -e "\n   -> Calculando el Top $TOP_N usuarios para $CIUDAD_NAME en $TOPN_OUTPUT_FILE..."
        # Llama al script topn_selection.py
        python3 "$SCRIPT_TOPN_PYTHON" --input_file "$INPUT_FILTERED_FILE" --top "$TOP_N" --output_file "$TOPN_OUTPUT_FILE"

        echo "   -> Generando mapas individuales para los usuarios del Top $TOP_N..."
        # Lee línea a línea el fichero de salida (cada línea es un ID de usuario)
        while IFS= read -r USER_ID; do
            # Aseguramos que el ID no esté vacío
            if [ ! -z "$USER_ID" ]; then
                INPUT_FILE="$PATH_GOWALLA_FILES/${CIUDAD_NAME}Gowalla.txt"
                OUTPUT_HTML_NAME="${CIUDAD_NAME}_TopUser${USER_ID}_Map.html"
                OUTPUT_PATH="$PATH_OUTPUT_GOWALLA_FILES/$OUTPUT_HTML_NAME"

                echo "      - Generando mapa para Top User $USER_ID en $CIUDAD_NAME..."
                python3 "$PATH_INDIVIDUAL_PYTHON" --input_file "$INPUT_FILE" --city_name "$CIUDAD_NAME" --user_id "$USER_ID" --output_html "$OUTPUT_PATH"
            fi
        done < "$TOPN_OUTPUT_FILE"
    done
else
    echo "   ERROR: No se encontró el script $SCRIPT_TOPN_PYTHON. Saltando cálculo de Top 5 y generación de mapas."
fi


# 7. Relanzar el Proyecto Flask (como pide el enunciado para ver los HTML)
echo -e "\n7. Reiniciando la aplicación Flask (main.py) para que los mapas estén disponibles..."

(cd ProyectoFUSO && python3 main.py)

echo "---------------------------------------------------------"
echo "FIN DEL EJERCICIO 3. Verifique los mapas en el navegador."
echo "---------------------------------------------------------"

# Desactivar el entorno virtual si se activó
if [ -d "$VENV_PATH" ]; then
    deactivate
fi