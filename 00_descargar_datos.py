/* =====================================================================
   PASO 2 – Cargar los datos (SQL Server)

   Antes de correr esto, generá los CSV con:
       python notebooks/00_descargar_datos.py
   Eso deja datos/polizas.csv y datos/siniestros.csv.

   Cambiá la ruta C:\ruta\al\proyecto por la carpeta donde tengas el
   proyecto en tu compu.

   (En SQLite no hace falta: el notebook carga los CSV directamente.)
   ===================================================================== */

BULK INSERT polizas
FROM 'C:\ruta\al\proyecto\datos\polizas.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001');

BULK INSERT siniestros
FROM 'C:\ruta\al\proyecto\datos\siniestros.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001');

-- Control de carga: deberían dar 677.991 pólizas y 26.444 siniestros
SELECT 'polizas' AS tabla, COUNT(*) AS filas FROM polizas
UNION ALL
SELECT 'siniestros', COUNT(*) FROM siniestros;
