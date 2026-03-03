# Proyecto_6_final
Proyecto final bootcamp "Data Analytics"

KPIS

1) Definiciones que vamos a fijar (para que el proyecto sea consistente)
A) Qué es “Sostenible”

Sostenible = Electric OR Petrol+Electric OR Diesel+Electric
(No dependemos aún de DGT; lo documentamos como proxy por Fuel Type.)

B) Qué es “Apto familia numerosa” (Family Suitable)

Como no tenemos width, usamos un criterio defendible con tus columnas:

Seating Capacity >= 5

Body Type IN ('SUV','Crossover','Wagon')

Boot Capacity (L) >= 450 (umbral inicial; si ves que deja muy pocos, lo ajustamos a 400)

Esto te permite explicar que el criterio busca “3 sillas + logística familiar” usando proxies de espacio.

2) KPI 1 — % del mercado apto para familia numerosa

Definición:
(# vehículos Family Suitable) / (# total vehículos)

Y lo cortamos por:

Fuel Type

Body Type

Segment

3) KPI 2 — % de coches familiares que son sostenibles

Definición:
(# Family Suitable AND Sostenible) / (# Family Suitable)

Esto es una slide muy potente: “de los coches que sirven para familia, ¿cuántos cumplen el criterio eco?”

4) KPI 3 — Precio medio por combustible (y dentro de Family Suitable)

Dos vistas:

Mercado total: AVG(Price)

Solo Family Suitable: AVG(Price)

Así se ve claramente el “premium” (si lo hay) por ser sostenible.

5) KPI 4 — Ratio de esfuerzo económico (con INE)

Aquí definimos 2 ratios:

Esfuerzo de compra: Price / Income_Annual

Esfuerzo operativo anual: Annual_Cost / Income_Annual

Donde:

Annual_Cost = Maintenance_Cost + Energy_Cost*(km_anuales/100)

asumimos km_anuales = 15000 (muy estándar; lo declaras en README)

Y lo mostramos por:

Fuel Type

Body Type

Segment

6) KPI 5 — Top 10 opciones equilibradas (score compuesto)

Creamos un Balanced Score (0–100) con pesos simples y explicables:

Seguridad (Euro NCAP)

Boot Capacity

– Price (o ratio esfuerzo)

– Annual_Cost

Range (si es EV) / (opcional)