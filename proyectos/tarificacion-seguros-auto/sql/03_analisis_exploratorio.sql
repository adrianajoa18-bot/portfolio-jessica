/* =====================================================================
   PASO 3 – Análisis exploratorio en SQL

   Conceptos actuariales que usamos:
     Frecuencia  = siniestros / exposición   (siniestros por año-póliza)
     Severidad   = monto total / siniestros  (costo promedio por siniestro)
     Prima pura  = frecuencia × severidad    (costo esperado por año-póliza)

   Las consultas son SQL estándar: corren igual en SQL Server y SQLite.
   Cada una empieza con "-- @consulta" para que el notebook las pueda
   ejecutar automáticamente.
   ===================================================================== */


-- @consulta control_calidad
-- ¿Coincide la cantidad de siniestros declarada con los montos cargados?
SELECT
    (SELECT SUM(ClaimNb) FROM polizas)                         AS siniestros_declarados,
    (SELECT COUNT(*)     FROM siniestros)                      AS siniestros_con_monto,
    (SELECT COUNT(*) FROM polizas p
      WHERE p.ClaimNb > 0
        AND NOT EXISTS (SELECT 1 FROM siniestros s WHERE s.IDpol = p.IDpol))
                                                               AS polizas_con_siniestro_sin_monto,
    (SELECT COUNT(*) FROM polizas WHERE Exposure > 1)          AS polizas_exposicion_mayor_1;


-- @consulta kpis_cartera
-- Indicadores generales de la cartera
SELECT
    COUNT(*)                                          AS polizas,
    ROUND(SUM(Exposure), 0)                           AS anios_poliza,
    SUM(ClaimNb)                                      AS siniestros,
    ROUND(CAST(SUM(ClaimNb) AS FLOAT) / SUM(Exposure), 4) AS frecuencia
FROM polizas;


-- @consulta frecuencia_por_edad
-- Frecuencia por tramo de edad del conductor
SELECT
    CASE
        WHEN DrivAge < 21 THEN '18-20'
        WHEN DrivAge < 26 THEN '21-25'
        WHEN DrivAge < 31 THEN '26-30'
        WHEN DrivAge < 41 THEN '31-40'
        WHEN DrivAge < 51 THEN '41-50'
        WHEN DrivAge < 61 THEN '51-60'
        WHEN DrivAge < 71 THEN '61-70'
        ELSE '71+'
    END                                               AS tramo_edad,
    COUNT(*)                                          AS polizas,
    ROUND(SUM(Exposure), 0)                           AS anios_poliza,
    SUM(ClaimNb)                                      AS siniestros,
    ROUND(CAST(SUM(ClaimNb) AS FLOAT) / SUM(Exposure), 4) AS frecuencia
FROM polizas
GROUP BY
    CASE
        WHEN DrivAge < 21 THEN '18-20'
        WHEN DrivAge < 26 THEN '21-25'
        WHEN DrivAge < 31 THEN '26-30'
        WHEN DrivAge < 41 THEN '31-40'
        WHEN DrivAge < 51 THEN '41-50'
        WHEN DrivAge < 61 THEN '51-60'
        WHEN DrivAge < 71 THEN '61-70'
        ELSE '71+'
    END
ORDER BY tramo_edad;


-- @consulta frecuencia_por_bonus_malus
-- El Bonus-Malus resume el historial: 50 = sin siniestros hace años
SELECT
    CASE
        WHEN BonusMalus = 50  THEN '50 (máximo bonus)'
        WHEN BonusMalus < 60  THEN '51-59'
        WHEN BonusMalus < 80  THEN '60-79'
        WHEN BonusMalus < 100 THEN '80-99'
        ELSE '100+ (malus)'
    END                                               AS tramo_bm,
    COUNT(*)                                          AS polizas,
    SUM(ClaimNb)                                      AS siniestros,
    ROUND(CAST(SUM(ClaimNb) AS FLOAT) / SUM(Exposure), 4) AS frecuencia
FROM polizas
GROUP BY
    CASE
        WHEN BonusMalus = 50  THEN '50 (máximo bonus)'
        WHEN BonusMalus < 60  THEN '51-59'
        WHEN BonusMalus < 80  THEN '60-79'
        WHEN BonusMalus < 100 THEN '80-99'
        ELSE '100+ (malus)'
    END
ORDER BY MIN(BonusMalus);


-- @consulta severidad_por_combustible
-- JOIN entre pólizas y siniestros: costo promedio según combustible
SELECT
    p.VehGas                                          AS combustible,
    COUNT(*)                                          AS siniestros,
    ROUND(AVG(s.ClaimAmount), 0)                      AS severidad_media,
    ROUND(MAX(s.ClaimAmount), 0)                      AS siniestro_maximo
FROM siniestros s
INNER JOIN polizas p ON p.IDpol = s.IDpol
GROUP BY p.VehGas;


-- @consulta prima_pura_por_area
-- Subconsulta + LEFT JOIN: prima pura observada por zona (A rural … F urbana)
SELECT
    p.Area                                            AS area,
    ROUND(SUM(p.Exposure), 0)                         AS anios_poliza,
    ROUND(CAST(SUM(p.ClaimNb) AS FLOAT) / SUM(p.Exposure), 4)            AS frecuencia,
    ROUND(SUM(COALESCE(m.monto, 0)) / NULLIF(SUM(p.ClaimNb), 0), 0)      AS severidad,
    ROUND(SUM(COALESCE(m.monto, 0)) / SUM(p.Exposure), 1)                AS prima_pura
FROM polizas p
LEFT JOIN (
    SELECT IDpol, SUM(ClaimAmount) AS monto
    FROM siniestros
    GROUP BY IDpol
) m ON m.IDpol = p.IDpol
GROUP BY p.Area
ORDER BY p.Area;


-- @consulta concentracion_siniestros_grandes
-- ¿Cuánto del costo total explican los siniestros más grandes?
SELECT
    CASE
        WHEN ClaimAmount <   1000 THEN '1. < 1.000'
        WHEN ClaimAmount <   5000 THEN '2. 1.000 - 5.000'
        WHEN ClaimAmount <  20000 THEN '3. 5.000 - 20.000'
        WHEN ClaimAmount < 100000 THEN '4. 20.000 - 100.000'
        ELSE '5. > 100.000'
    END                                               AS rango_monto,
    COUNT(*)                                          AS siniestros,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM siniestros), 2)              AS pct_cantidad,
    ROUND(100.0 * SUM(ClaimAmount) / (SELECT SUM(ClaimAmount) FROM siniestros), 2) AS pct_monto
FROM siniestros
GROUP BY
    CASE
        WHEN ClaimAmount <   1000 THEN '1. < 1.000'
        WHEN ClaimAmount <   5000 THEN '2. 1.000 - 5.000'
        WHEN ClaimAmount <  20000 THEN '3. 5.000 - 20.000'
        WHEN ClaimAmount < 100000 THEN '4. 20.000 - 100.000'
        ELSE '5. > 100.000'
    END
ORDER BY rango_monto;
