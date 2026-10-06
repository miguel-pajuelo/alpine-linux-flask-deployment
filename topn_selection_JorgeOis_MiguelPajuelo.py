import sys
import os
import argparse
from collections import Counter


def topn_selection(input_file, top_n, output_file):

    if not os.path.exists(input_file):
        print(f"Error: El fichero de entrada no existe en la ruta: {input_file}", file=sys.stderr)
        return

    # User IDs extraídos del fichero filtrado (columna 1)
    user_ids = []
    
    try:
        # Los ficheros filtered contienen las columnas 1, 2 y 5 (user_id, time, location_id)
        # Separados por tabulaciones.
        with open(input_file, 'r', encoding='utf-8') as f:
            for line in f:
                fields = line.strip().split('\t')
                if len(fields) >= 1:
                    user_ids.append(fields[0])

        # Contar la frecuencia de cada usuario
        user_counts = Counter(user_ids)
        
        # Obtener el Top N de usuarios (devuelve una lista de tuplas: (user_id, count))
        top_users_with_count = user_counts.most_common(top_n)
        
        # Extraer solo los user_id
        top_user_ids = [user_id for user_id, count in top_users_with_count]

        # Escribir los IDs de usuario en el fichero de salida (uno por línea)
        with open(output_file, 'w', encoding='utf-8') as out_f:
            for user_id in top_user_ids:
                out_f.write(f"{user_id}\n")
        
        print(f"Éxito: Se ha guardado el Top {top_n} de usuarios en {output_file}")

    except Exception as e:
        print(f"Ocurrió un error al procesar el fichero {input_file}: {e}", file=sys.stderr)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Calcula el Top N de usuarios con más interacciones.")
    parser.add_argument('--input_file', type=str, required=True)
    parser.add_argument('--top', type=int, required=True)
    parser.add_argument('--output_file', type=str, required=True)
    
    args = parser.parse_args()
    
    topn_selection(args.input_file, args.top, args.output_file)