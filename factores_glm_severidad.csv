"""
Descarga los datos públicos freMTPL2 (paquete CASdatasets de R) y los
guarda como CSV en la carpeta datos/.

Fuente: Dutang, C. & Charpentier, A. – CASdatasets
        https://github.com/dutangc/CASdatasets
Son ~678.000 pólizas de responsabilidad civil de autos de una aseguradora
francesa, observadas durante un año.

Uso:
    pip install pandas rdata
    python notebooks/00_descargar_datos.py
"""
from pathlib import Path
import urllib.request

import pandas as pd
import rdata

BASE = "https://raw.githubusercontent.com/dutangc/CASdatasets/master/data/"
DESTINO = Path(__file__).resolve().parent.parent / "datos"
DESTINO.mkdir(exist_ok=True)

ARCHIVOS = {
    "freMTPL2freq": "polizas.csv",     # características + cantidad de siniestros
    "freMTPL2sev": "siniestros.csv",   # monto de cada siniestro
}

for nombre, salida in ARCHIVOS.items():
    rda = DESTINO / f"{nombre}.rda"
    if not rda.exists():
        print(f"Descargando {nombre}...")
        urllib.request.urlretrieve(BASE + f"{nombre}.rda", rda)
    df = rdata.read_rda(rda)[nombre]
    # En el archivo original IDpol viene como texto (a veces "1e+05"):
    # lo pasamos a número entero para poder cruzar las tablas.
    df["IDpol"] = pd.to_numeric(df["IDpol"].astype(str)).astype(int)
    if "ClaimNb" in df:
        df["ClaimNb"] = df["ClaimNb"].astype(int)
    df.to_csv(DESTINO / salida, index=False)
    print(f"{salida}: {len(df):,} filas")
