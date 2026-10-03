# Guía para armar el tablero en Power BI

Los CSV de esta carpeta los genera el notebook. Con ellos armás un tablero de 3 páginas.
Cuando lo termines, guardalo como `tarificacion.pbix` en esta carpeta y sacale capturas
para el portfolio (o publicalo con **Publicar en la web** y pegá el link).

## 1. Cargar los datos
**Inicio → Obtener datos → Texto/CSV**, y cargá:

| Archivo | Qué tiene |
|---|---|
| `frecuencia_por_variable.csv` | Exposición, siniestros y frecuencia por tramo de cada variable |
| `factores_glm_frecuencia.csv` | Factor de tarifa de cada tramo (GLM Poisson) |
| `factores_glm_severidad.csv` | Factor de severidad de cada tramo (GLM Gamma) |
| `comparacion_modelos.csv` | Desvío y Gini de cada modelo |
| `lift_por_decil.csv` | Frecuencia observada vs. predicha por decil |
| `predicciones_muestra.csv` | 20.000 pólizas de prueba con sus predicciones |

En Power Query, revisá que las columnas numéricas tengan tipo **Número decimal**
(si usás configuración regional en español, elegí *Configuración regional: Inglés (Estados Unidos)*
al cambiar el tipo, porque los CSV usan punto decimal).

## 2. Medidas DAX (tabla `predicciones_muestra`)
```DAX
Exposición = SUM(predicciones_muestra[Exposure])
Siniestros = SUM(predicciones_muestra[ClaimNb])
Frecuencia observada = DIVIDE([Siniestros], [Exposición])
Frecuencia GLM = DIVIDE(SUMX(predicciones_muestra, predicciones_muestra[pred_glm] * predicciones_muestra[Exposure]), [Exposición])
Prima pura media = DIVIDE(SUM(predicciones_muestra[prima_glm]), [Exposición])
Costo real por año = DIVIDE(SUM(predicciones_muestra[costo_real]), [Exposición])
```

## 3. Páginas sugeridas
1. **Cartera:** tarjetas con Exposición, Siniestros y Frecuencia observada; gráfico combinado
   (columnas = exposición, línea = frecuencia) desde `frecuencia_por_variable`, con un
   segmentador por `nombre` para elegir la variable.
2. **Factores de tarifa:** gráfico de barras de `factor` por `nivel`, segmentado por `variable`;
   agregá una línea constante en 1 (Analítica → Línea constante) para marcar el nivel base.
3. **Modelos:** gráfico de líneas de `lift_por_decil` (observada, glm, gbm por decil) y una tabla
   con `comparacion_modelos`. En otra visual: Frecuencia observada vs Frecuencia GLM por `tramo_edad`
   y por `Region`.

## 4. Para explicar en una entrevista
- Por qué el lift sube de izquierda a derecha: el modelo ordena a los clientes por riesgo.
- Qué significa un factor de 2,5 en Bonus-Malus 70-79: 2,5 veces la frecuencia del tramo base.
- Por qué la línea del GLM y la observada se parecen: el modelo está bien calibrado.
