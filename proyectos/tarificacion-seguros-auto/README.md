# Tarificación de seguros de auto con datos

**Autora:** Jessica Ojeda Arenas · [Ver el dashboard interactivo](https://adrianajoa18-bot.github.io/portfolio-jessica/proyectos/tarificacion-seguros-auto/)

Proyecto integrador de ciencia actuarial y ciencia de datos: a partir de 678.000 pólizas
reales de seguro de auto, estimo la **prima pura** (costo esperado de siniestros) de cada
cliente y comparo un modelo actuarial clásico con uno de machine learning.

## Herramientas
**SQL** (SQL Server / SQLite) · **Python** (pandas, statsmodels, scikit-learn) ·
**GLM** Poisson y Gamma · **Gradient Boosting** · **Power BI** (datos exportados + guía) · Dashboard web (HTML + Chart.js)

## Estructura
```
sql/
  01_crear_tablas.sql          Modelo de datos (pólizas 1:N siniestros)
  02_cargar_datos.sql          Carga con BULK INSERT (SQL Server)
  03_analisis_exploratorio.sql Frecuencia, severidad, prima pura, JOINs y subconsultas
notebooks/
  00_descargar_datos.py        Descarga los datos públicos y genera los CSV
  tarificacion_seguros_auto.ipynb  Análisis completo, modelos y conclusiones
power-bi/                      CSV de resultados + guía para armar el tablero
index.html + resultados.js     Dashboard web con calculadora de prima
```

## Resultados principales
| Modelo | Desvío Poisson (prueba) | Gini |
|---|---|---|
| Tarifa única (sin modelo) | 0,479 | 0,00 |
| GLM Poisson | 0,456 | 0,29 |
| Gradient Boosting | 0,449 | 0,32 |

- El **Bonus-Malus** es la variable que más explica la frecuencia, y absorbe gran parte del
  efecto de la edad (los conductores nuevos empiezan en 100).
- El Gradient Boosting ordena algo mejor el riesgo, pero el GLM da una **tabla de factores**
  explicable, que es lo que se usa en una tarifa real.
- El 0,8 % de los siniestros (los mayores a 20.000 EUR) explica el 37 % del costo: se topean en
  el percentil 99 y se cubren con un recargo.
- La tarifa está **equilibrada**: primas puras / siniestros ≈ 1 sobre montos topeados.

## Cómo reproducirlo
```bash
pip install pandas numpy statsmodels scikit-learn matplotlib rdata jupyter
python notebooks/00_descargar_datos.py
jupyter notebook notebooks/tarificacion_seguros_auto.ipynb
```

## Datos
`freMTPL2freq` y `freMTPL2sev`, del paquete [CASdatasets](https://github.com/dutangc/CASdatasets)
(Dutang & Charpentier). Responsabilidad civil de autos, Francia, montos en euros.
