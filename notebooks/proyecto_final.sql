-- INICIAMOS EL ANALISIS CON QUERRIES PARA CORROBORAR QUE ESTE TODO OK

USE final_project;
SHOW TABLES;

SELECT *
FROM cars;

SELECT COUNT(*)
FROM cars;

-- HABIENDO CONFIRMADO QUE LA TABLA SE CARGO CORRECTAMENTE, EMPEZAMOS A REALIZAR LAS QUERIES PARA OBTENER LOS KPIS QUE NECESITAMOS PARA ESTE PROYECTO. 

-- PORCENTAJE DE COCHES FAMILIARES
SELECT 
    COUNT(*) AS total_vehiculos,
    SUM(coche_familiar) AS total_familiares,
    ROUND(SUM(coche_familiar) * 100.0 / COUNT(*), 2) AS pct_familiares
FROM cars;

-- PORCENTAJE DE COCHES "SUSTENTABLES" DENTRO DEL SEGMENTO FAMILIAR
SELECT 
    COUNT(*) AS total_familiares,
    SUM(sustainable) AS familiares_sostenibles,
    ROUND(SUM(sustainable) * 100.0 / COUNT(*), 2) AS pct_sostenibles_familiares
FROM cars
WHERE coche_familiar = 1;

-- COSTO DE MANTENIMIENTO ANUAL DE ACUERDO AL TIPO DE MOTORIZACION
SELECT 
    powertrain_type,
    COUNT(*) AS total_modelos,
    ROUND(AVG(costo_total_anual), 2) AS costo_medio_anual
FROM cars
GROUP BY powertrain_type
ORDER BY costo_medio_anual;

-- PRECIO MEDIO DE ACUERDO AL TIPO DE MOTORIZACION
SELECT 
    powertrain_type,
    ROUND(AVG(price_eur), 2) AS precio_medio
FROM cars
GROUP BY powertrain_type
ORDER BY precio_medio;

-- MEDIA DE COSTO ANUAL DE MANTENIMIENTO UNICAMENTE DE LOS COCHES FAMILIRIARES
SELECT 
    powertrain_type,
    COUNT(*) AS total_familiares,
    ROUND(AVG(costo_total_anual), 2) AS costo_medio_familiares
FROM cars
WHERE coche_familiar = 1
GROUP BY powertrain_type
ORDER BY costo_medio_familiares;

-- DENTRO DE LOS COCHES FAMILIARES, PROPORCION SEGUN SU TIPO DE MOTORIZACION
SELECT 
    powertrain_type,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100 / 
        (SELECT COUNT(*) 
        FROM cars 
        WHERE coche_familiar = 1), 2) AS pct_dentro_segmento
FROM cars
WHERE coche_familiar = 1
GROUP BY powertrain_type;