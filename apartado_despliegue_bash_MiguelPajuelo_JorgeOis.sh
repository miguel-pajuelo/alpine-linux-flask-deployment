#!/bin/sh
set -eu
cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
if [ ! -d "ProyectoFUSO/.git" ]; then
    git clone https://github.com/pablosanchezp/ProyectoFUSO.git ProyectoFUSO
fi
python3 -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt
cd ProyectoFUSO
exec python main.py
