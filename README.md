# Análisis de Accesibilidad de Vehículos Familiares en España

## Objetivo del proyecto

Este proyecto analiza si los vehículos familiares disponibles en el mercado resultan económicamente accesibles para un hogar promedio en España. El análisis busca identificar qué motorizaciones y marcas ofrecen un mejor equilibrio entre precio, costes de uso y valor para una familia.

---

## Contexto del negocio

Este proyecto se sitúa en el contexto del mercado automotriz y de la toma de decisión de compra por parte de familias. Elegir un vehículo familiar no depende solo del precio de compra, sino también de factores como capacidad, seguridad, coste operativo y sostenibilidad.

Desde una perspectiva de negocio, el desafío consiste en entender:

- Qué proporción del mercado es realmente accesible para una familia media.
- Cómo impacta la motorización del vehículo en el coste total.
- Qué marcas ofrecen mejores alternativas en términos de accesibilidad.

---

## Dataset

### Fuente

El análisis se desarrolló a partir de un dataset de vehículos europeos en formato Excel/CSV, complementado con datos del Instituto Nacional de Estadística (INE) para incorporar el ingreso medio por hogar en España.

### Tipo de datos

Se trabajó con una combinación de:

- Datos de mercado de vehículos
- Variables derivadas creadas en Python
- Métricas calculadas en SQL

### Variables principales

Entre las variables más relevantes del dataset se encuentran:

- `model_name` → nombre del modelo  
- `brand` → marca  
- `body_type` → tipo de carrocería  
- `segment` → segmento del vehículo  
- `price_eur` → precio del vehículo  
- `maintenance_cost_year` → costo anual de mantenimiento  
- `seating_capacity` → número de plazas  
- `boot_capacity_l` → capacidad de maletero  
- `safety_rating` → puntuación de seguridad  
- `powertrain_type` → tipo de motorización  
- `fuel_type` → tipo de combustible  

### Variables derivadas creadas

Durante el análisis se construyeron nuevas variables clave:

- `sustainable` → indicador de vehículo sostenible  
- `coche_familiar` → indicador de vehículo familiar  
- `costo_energia_anual` → costo energético anual estimado  
- `costo_total_anual` → costo anual total estimado  
- `cto_5y` → costo total de propiedad a 5 años  
- `prop_cto_ingreso` → ratio entre precio del vehículo e ingreso medio del hogar  
- `categoria` → clasificación económica del vehículo (`Accesible`, `Esfuerzo alto`, `Difícil`)  

---

## Notas sobre calidad del dato

El dataset no presentaba valores nulos, lo que facilitó el proceso de limpieza. Sin embargo, durante el análisis se detectaron algunas limitaciones importantes:

- Presencia de modelos con nombres poco realistas o artificiales.
- Precios repetidos en exceso en determinados valores.
- Posibles inconsistencias entre nombre comercial y características del vehículo.

Por esta razón, el proyecto se planteó como un análisis orientado a tendencias de mercado, más que como una recomendación exacta de modelos individuales.

---

## Preguntas clave

El proyecto se construyó alrededor de las siguientes preguntas:

1. ¿Qué parte del mercado de vehículos familiares es realmente accesible para un hogar promedio en España?
2. ¿Qué tecnologías ofrecen el mejor equilibrio entre precio de compra y costes de uso?
3. ¿Cómo cambia el costo total de propiedad según el tipo de motorización?
4. ¿Existen diferencias significativas entre marcas en términos de accesibilidad?
5. ¿Es posible clasificar vehículos según su nivel de accesibilidad económica mediante un modelo de Machine Learning?

---

## Proceso de análisis

El proyecto se desarrolló en varias etapas:

### 1. Limpieza y preparación de datos

- Revisión de estructura y tipos de variables.
- Renombrado de columnas.
- Eliminación de columnas irrelevantes.
- Validación de nulos y consistencia general.

### 2. Feature Engineering

Se construyeron variables orientadas al problema de negocio:

- Identificación de vehículos familiares.
- Clasificación de sostenibilidad.
- Estimación del costo anual.
- Cálculo del costo total a 5 años (costo de mantenimiento + precio del coche).
- Construcción de ratios de accesibilidad económica.

### 3. Análisis exploratorio y KPIs

Se calcularon indicadores clave como:

- Proporción de vehículos sostenibles.
- Proporción de sostenibles dentro del segmento familiar.
- Costo anual por tipo de motorización.
- Precio medio por tecnología.
- Distribución de accesibilidad económica.
- Costo total de propiedad a 5 años.
- Ranking de marcas accesibles.

### 4. Análisis en SQL

El dataset final se cargó en MySQL, donde se construyeron queries analíticas para calcular KPIs y métricas de negocio.

### 5. Visualización

Se diseñó un dashboard en Tableau para visualizar:

- Accesibilidad del mercado
- Proporción según motorización
- Costo anual
- Marcas con mejor accesibilidad

### 6. Aplicación interactiva

Se desarrolló una app en Streamlit que permite al usuario:

- Filtrar vehículos según ingreso, espacio y seguridad
- Explorar resultados
- Consultar una predicción de accesibilidad mediante Machine Learning

### 7. Machine Learning

Se construyó un modelo de clasificación supervisada para clasificar vehículos familiares en tres categorías:

- `Accesible`
- `Esfuerzo alto`
- `Difícil`

El modelo alcanzó aproximadamente 91% de accuracy, mostrando una buena capacidad para clasificar la accesibilidad económica de los vehículos.

---

## Resultados / Insights

Los hallazgos más relevantes del análisis fueron:

- Solo una pequeña parte del mercado de vehículos familiares puede considerarse realmente accesible para un hogar promedio en España.
- La mayor parte del mercado se concentra en las categorías “Esfuerzo alto” y “Difícil”.
- Los vehículos híbridos ofrecen, en promedio, el mejor equilibrio entre precio de compra y costos de mantenimiento.
- Los vehículos eléctricos presentan menores costos de uso, pero tienen un precio mayor lo que hace que su costo a 5 años sea elevado.
- Existen diferencias claras entre marcas en términos de accesibilidad.
- El factor que más condiciona la accesibilidad es principalmente el precio de compra del vehículo.

---

## Recomendaciones de negocio

A partir del análisis, las principales recomendaciones serían:

- Priorizar la oferta y comunicación de vehículos híbridos en el segmento familiar.
- Diseñar herramientas de recomendación o configuradores de compra centrados en el ingreso del hogar.
- Comunicar el costo total promedio, no solo el precio inicial.
- Identificar marcas y segmentos con mayor accesibilidad para orientar campañas comerciales.
- Explorar incentivos o financiación que reduzcan la barrera de entrada de vehículos eléctricos.

---

## Limitaciones

Este proyecto presenta algunas limitaciones importantes:

- El dataset muestra señales de generación sintética o semi-sintética en algunos modelos.
- El análisis utiliza un único valor de ingreso medio nacional.
- No se incluyen variables como financiación, seguros o ayudas públicas.
- La clasificación de accesibilidad se basa en umbrales definidos analíticamente.

---

## Próximos pasos

- Incorporar datos reales de mercado actualizados.
- Añadir información sobre ayudas públicas y financiación.
- Segmentar el análisis por región o nivel de ingreso.
- Mejorar la app de Streamlit con recomendaciones personalizadas.
- Ampliar el modelo de Machine Learning con más variables.

---

## Cómo Replicar el Proyecto

1. Clonar el repositorio.
2. Instalar las librerías necesarias (ver librerias.txt).
3. Ejecutar el notebook a través de github.

---

## Aplicación interactiva

Puedes probar la aplicación desplegada aquí:

🔗 **Streamlit App**  
https://proyecto6final-lcsejaa8psvyqom8wpi5p4.streamlit.app/

### Qué permite hacer la aplicación

La aplicación permite:

- Filtrar vehículos familiares según ingreso del hogar
- Comparar precio y coste total de propiedad
- Analizar tecnologías (EV, Hybrid, Diesel, Petrol)
- Obtener una predicción de accesibilidad económica mediante Machine Learning

---

## Fuentes de datos

https://www.ine.es/dyngs/INEbase/operacion.htm?c=Estadistica_C&cid=1254736176807&menu=ultiDatos&idp=1254735976608