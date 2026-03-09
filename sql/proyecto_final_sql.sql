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

-- DE ACUERDO A LA ENCUESTA DE CONDICIONES DE VIDA REALIZADA POR EL INSTITUTO NACIONAL DE ESTADISTICAS, EL INGRESO MEDIO DE UN HOGAR ENTRE 2021 Y 2025 FUE DE 34.716,00.
-- TENIENDO EL VALOR, LO ESTABLECEMOS COMO UNA VARIABLE PARA EVITAR ERRORES DE TIPEO Y GENERARNOS ALGUN ERROR DE CODIGO.

WITH valor AS (
  SELECT 34716 AS income_ref
)
SELECT income_ref FROM valor;

-- VAMOS A OBTENER CUAL ES EL PROMEDIO DE AÑOS QUE NECESITA UNA FAMILIA PARA COMPRAR UN COCHE FAMILIAR

WITH valor AS (SELECT 34716 AS income_ref)
SELECT
  CASE 
  WHEN coche_familiar = 1 THEN 'Familiares' ELSE 'No familiares' END AS grupo,
  ROUND(AVG(price_eur / income_ref), 2) AS avg_price_income_ratio
FROM cars
CROSS JOIN valor
GROUP BY grupo;
-- UN HOGAR NECESITA 1.5 AÑOS PARA COMPRAR UN COCHE FAMILIAR (1.56 PARA UN NO FAMILIAR)

-- CLASIFICAREMOS LA ACCESIBILIDAD DE COCHES FAMILIARES SEGUN LOS INGRESOS: (MENORES A 0.8 SERAN ACCESIBLES, ENTRE 0.8 Y 1.2 ESFUERZO ALTO Y MAS DE 1.2 DIFICIL) 

WITH valor AS (SELECT 34716 AS income_ref)
SELECT
  CASE
    WHEN price_eur / income_ref < 0.8 THEN 'Accesible'
    WHEN price_eur / income_ref < 1.2 THEN 'Esfuerzo alto'
    ELSE 'Dificil'
  END AS categoria,
  COUNT(*) AS cantidad,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM cars
CROSS JOIN valor
WHERE coche_familiar = 1
GROUP BY categoria
ORDER BY cantidad DESC;

-- DEL TOTAL DE FAMILIARES, ACCESIBLES SON 5.88%, ESFUERZO ALTO 33.29% Y DIFICIL 60.83%.

-- TENIENDO EN CUENTA QUE PARA INGRESAR A GRANDES CIUDADES HAY QUE TENER COCHES CON ETIQUETA "ECO" o "0", VAMOS A VER LA ACCESIBILIDAD DE UNA FAMILIA A ESTE TIPO DE COCHES. 

WITH valor AS (SELECT 34716 AS income_ref)
SELECT
  sustainable,
  CASE
    WHEN price_eur / income_ref < 0.8 THEN 'Accesible'
    WHEN price_eur / income_ref < 1.2 THEN 'Esfuerzo alto'
    ELSE 'Dificil'
  END AS categoria,
  COUNT(*) AS cantidad,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM cars WHERE coche_familiar = 1), 2) AS pct_sobre_familiares
FROM cars
CROSS JOIN valor
WHERE coche_familiar = 1
GROUP BY sustainable, categoria
ORDER BY sustainable DESC, cantidad DESC;
-- Hay una menor oferta de coches sostenibles vs los "no sostenibles" en cuanto a opciones accesibles. (52 sostenibles vs 82 no sostenibles)


-- CANTIDAD DE COCHES ACCESIBLES Y FAMILIARES DE ACUERDO A SU MOTORIZACION
WITH valor AS (SELECT 34716 AS income_ref)
SELECT
    powertrain_type,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),2) AS pct
FROM cars
CROSS JOIN valor
WHERE coche_familiar = 1
AND price_eur / income_ref < 0.8
GROUP BY powertrain_type
ORDER BY total DESC;
-- Aunque los EV son los más caros en promedio, dentro del segmento accesible represetan un 27% y su vez los hibridos casi el 12%.

-- POR ULTIMO HAREMOS UN RANKING DE LAS MARCAS ACCESIBLES POR LO QUE ARMAREMOS UN SCORE QUE SE COMPONE DE CUATRO VARIABLES: 
-- PRICE (45%) COSTO TOTAL (20%), SAFETY RATING (25%) Y SUSTAINABLE (10%)

WITH valor AS (SELECT 34716 AS income_ref),
brand_stats AS (
SELECT
    brand,
    COUNT(*) AS cantidad,
    AVG(price_eur) AS avg_price,
    AVG(costo_total_anual) AS avg_cost,
    AVG(safety_rating) AS avg_safety,
    AVG(sustainable) AS pct_sustainable
FROM cars
CROSS JOIN valor
WHERE coche_familiar = 1
AND price_eur NOT IN (22000,160000)
AND price_eur / income_ref < 0.8
GROUP BY brand
HAVING COUNT(*) >= 2
),
norms AS (
SELECT
    MIN(avg_price) AS min_price,
    MAX(avg_price) AS max_price,
    MIN(avg_cost) AS min_cost,
    MAX(avg_cost) AS max_cost,
    MIN(avg_safety) AS min_safety,
    MAX(avg_safety) AS max_safety
FROM brand_stats
)
SELECT
    b.brand,
    b.cantidad,
    ROUND(b.avg_price,0) AS avg_price,
    ROUND(b.avg_cost,0) AS avg_cost,
    ROUND(b.avg_safety,2) AS avg_safety,
    ROUND(b.pct_sustainable*100,1) AS pct_sustainable,
    ROUND(
        0.45 * (1 - (b.avg_price - n.min_price)/(n.max_price - n.min_price)) +
        0.20 * (1 - (b.avg_cost - n.min_cost)/(n.max_cost - n.min_cost)) +
        0.25 * ((b.avg_safety - n.min_safety)/(n.max_safety - n.min_safety)) +
        0.10 * b.pct_sustainable
    ,3) AS brand_score
FROM brand_stats as b
CROSS JOIN norms as n
ORDER BY brand_score DESC
LIMIT 15;

-- Costo total (coche + mantenimiento) de 5 años promedio por tecnología (solo familiares)

WITH params AS (SELECT 34716 AS income_ref)
SELECT
  powertrain_type,
  COUNT(*) AS cantidad,
  ROUND(AVG(price_eur),0) AS avg_price,
  ROUND(AVG(costo_total_anual),0) AS avg_annual_cost,
  ROUND(AVG(price_eur + 5*costo_total_anual),0) AS avg_ct_5y,
  ROUND(AVG((price_eur + 5*costo_total_anual) / income_ref), 2) AS avg_ct_prop
FROM cars
CROSS JOIN params
WHERE coche_familiar = 1
  AND price_eur NOT IN (22000,160000)
GROUP BY powertrain_type
ORDER BY avg_ct_5y;