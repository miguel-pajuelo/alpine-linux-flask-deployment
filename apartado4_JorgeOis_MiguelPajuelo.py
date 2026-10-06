import os
import requests
import time

# ==============================================================================
# Ejercicio 4: Script para realizar peticiones POST/GET a Flask
# Nombres de la pareja: Jorge Ois y Miguel Pajuelo
# ==============================================================================

ALPINE_IP = os.environ.get("ALPINE_IP", "127.0.0.1")
FLASK_PORT = os.environ.get("FLASK_PORT", "5000")
BASE_URL = f"http://{ALPINE_IP}:{FLASK_PORT}"

# Creamos el directorio donde se almacenaran los resultados
OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "descargas_resultados_flask")
os.makedirs(OUTPUT_DIR,exist_ok=True)

# Constantes
MODELO = "RandomForest"
NOMBRE_DATASET = "iris"

# Definimos las combinaciones 
combinaciones = []
for i in range(1,10):
    train_s = round(i/10,1)
    test_s = round(1-train_s,1)
    combinaciones.append((train_s,test_s))

print(f"Se van a probar {len(combinaciones)} para {NOMBRE_DATASET}/{MODELO}.")

# Funcion de Backoff exponencial para reintentar la conexion si falla
def fetch_reintentar(url, metodo="GET",data=None,intentos_max = 5):
    for intento in range(intentos_max):
        try:
            if metodo == "POST":
                respuesta = requests.post(url,data=data,timeout=10)
            else:
                respuesta = requests.get(url,timeout=10)

            # Cheque el estado de la respuesta
            if respuesta.status_code < 400:
                return respuesta
            
            print(f"Intento {intento+1}: Fallo de la peticion a {url}. Codigo: {respuesta.status_code}")

        except requests.exceptions.RequestException as e:
            print(f"Intento {intento + 1}: Error de conexión: {e}.")
        
        # Espera exponencial
        tiempo_espera = 2 ** intento
        time.sleep(tiempo_espera)

    print(f"Error: Fallo de la peticion a {url} despues de {intentos_max} intentos.")
    return None

def ejecutar_entreno_y_descarga():

    for train_s, test_s in combinaciones:
        print(f"\n--- Procesando Train: {train_s} / Test: {test_s} ---")

        train_url = f"{BASE_URL}/train"
        payload = {
            "dataset":NOMBRE_DATASET,
            "model":MODELO,
            "train_size":train_s,
            "test_size":test_s
        }

        post_respuesta = fetch_reintentar(train_url,metodo="POST",data=payload)

        if post_respuesta and post_respuesta.status_code == 200:
            print(f"Peticion POST exitosa.")
            
            # Construimos el nombre del archivo de imagen basado en la lógica del servidor
            result_name = f"{NOMBRE_DATASET}Tr{train_s}Tst{test_s}.png"
            image_url = f"{BASE_URL}/static/{result_name}"
            local_filepath = os.path.join(OUTPUT_DIR, result_name)

            # GET para descargar al imagen
            print(f"Descargando imagen desde: {image_url}")
            get_response = fetch_reintentar(image_url, metodo='GET')

            if get_response and get_response.status_code == 200:
                # Guardar el contenido de la imagen
                with open(local_filepath, 'wb') as f:
                    f.write(get_response.content)
                print(f"EXITO: Imagen guardada en {local_filepath}")
            else:
                print(f"ERROR: No se pudo descargar la imagen {result_name}. Verifique la ruta y el despliegue.")
                
        else:
            print("FAIL: Falló la petición POST al servicio /train.")
            
    print("\n--- PROCESO FINALIZADO ---")

if __name__ == "__main__":
    ejecutar_entreno_y_descarga()
    