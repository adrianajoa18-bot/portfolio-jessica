/* =====================================================================
   PROYECTO: Tarificación de seguros de auto
   PASO 1 – Crear las tablas

   Dos tablas, igual que en una aseguradora real:
     - polizas    : una fila por póliza (características del conductor
                    y del vehículo, tiempo de exposición y cantidad de
                    siniestros).
     - siniestros : una fila por siniestro pagado (monto en euros).

   Se relacionan por IDpol (relación 1 a muchos: una póliza puede
   tener varios siniestros).

   Escrito para SQL Server. También corre en SQLite (los tipos se
   adaptan solos).
   ===================================================================== */

DROP TABLE IF EXISTS siniestros;
DROP TABLE IF EXISTS polizas;

CREATE TABLE polizas (
    IDpol       INT            NOT NULL PRIMARY KEY,
    ClaimNb     INT            NOT NULL,  -- cantidad de siniestros en el período
    Exposure    DECIMAL(6,4)   NOT NULL,  -- años de cobertura (0.5 = 6 meses)
    VehPower    INT            NOT NULL,  -- potencia del vehículo (categoría 4 a 15)
    VehAge      INT            NOT NULL,  -- antigüedad del vehículo (años)
    DrivAge     INT            NOT NULL,  -- edad del conductor
    BonusMalus  INT            NOT NULL,  -- 50 = mejor historial; >100 = malus
    VehBrand    VARCHAR(5)     NOT NULL,  -- marca (anonimizada)
    VehGas      VARCHAR(10)    NOT NULL,  -- Regular (nafta) / Diesel
    Area        CHAR(1)        NOT NULL,  -- A (rural) ... F (urbano denso)
    Density     INT            NOT NULL,  -- habitantes por km2 de la ciudad
    Region      VARCHAR(40)    NOT NULL   -- región de Francia
);

CREATE TABLE siniestros (
    IDpol       INT            NOT NULL,
    ClaimAmount DECIMAL(14,2)  NOT NULL,  -- monto pagado (EUR)
    FOREIGN KEY (IDpol) REFERENCES polizas(IDpol)
);

CREATE INDEX ix_siniestros_idpol ON siniestros (IDpol);
