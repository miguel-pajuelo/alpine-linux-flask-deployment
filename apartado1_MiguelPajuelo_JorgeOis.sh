#!/bin/sh

paquetes="pip python3 python3-dev git nano sudo bash gcc g++ musl-dev linux-headers wget curl htop"

for i in $paquetes;
do

if apk list --installed | grep -q "^${i}-";
then

echo "$i ya está instalado"

else

echo "Instalando $i..."
apk add $i

fi

done

echo "Instalando libc-dev"
apk add libc-dev
