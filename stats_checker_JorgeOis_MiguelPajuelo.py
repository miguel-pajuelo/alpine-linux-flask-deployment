import sys
import os

# Comprobar argumentos
if len(sys.argv) != 2:
    print("Uso: python3 stats.py <fichero>")
    sys.exit(1)

fichero = sys.argv[1]

# Comprobar si existe
if not os.path.isfile(fichero):
    print(f"Error: el fichero '{fichero}' no existe.")
    sys.exit(1)

usuarios = set()
lugares = set()
filas = 0
julio = 0
agosto = 0

with open(fichero, "r", encoding="utf-8") as f:
    for linea in f:
        fila = linea.strip().split("\t")

        if len(fila) < 5:
            continue

        filas += 1

        usuario = fila[0]
        lugar = (fila[2],fila[3],fila[4])
        fecha = fila[1] 

        usuarios.add(usuario)
        lugares.add(lugar)

        if "2010-07" in fecha:
            julio += 1
        if "2010-08" in fecha:
            agosto += 1

nombre_fichero = os.path.basename(fichero)
nombre_ciudad = nombre_fichero.replace("Gowalla.txt","")

print(f"Estadísticas para {fichero}")
print(f"Numero de usuarios distintos      : {len(usuarios)}")
print(f"Numero de localizaciones distintas: {len(lugares)}")
print(f"Numero de filas completas         : {filas}")
print(f"Numero de check-ins en 2010-07    : {julio}")
print(f"Numero de check-ins en 2010-08    : {agosto}")
