# Global Superstore — Análisis de Ventas con SQL

## Descripción
Análisis exploratorio de un dataset de ventas globales con más de 50.000 
órdenes. Se respondieron 10 preguntas de negocio usando SQL puro, 
identificando insights clave sobre rentabilidad, productos, regiones 
y logística.

## Herramientas
- SQL (DB Browser for SQLite)
- Dataset: Global Superstore (Kaggle)

## Preguntas de negocio respondidas
1. Top 10 productos por ingresos totales
2. Ventas y profit por categoría
3. Ventas y rentabilidad por región
4. Países con ventas superiores al promedio global
5. Clasificación de órdenes por rentabilidad
6. Profit por segmento de clientes
7. Top 5 países por ventas dentro de cada región
8. Crecimiento de ventas año a año
9. Productos con pérdida en categorías rentables
10. Impacto del modo de envío en el profit

## Principales hallazgos
- **Technology** es la categoría líder en ventas y profit
- **Consumer** genera el 51% del profit total
- Las ventas crecen consistentemente año a año
- **Same Day** tiene el costo de envío más alto pero el profit más bajo
- 678 productos generan pérdidas dentro de categorías rentables

## Dashboard Power BI
Dashboard interactivo con 9 visualizaciones incluyendo:
- KPIs ejecutivos (Total Sales, Total Profit, Profit Margin, Total Orders)
- Análisis de ventas por categoría y región
- Tendencia de ventas 2011-2014
- Mapa geográfico de ventas por país
- Filtros interactivos por Segment, Region y Year

📊 Ver dashboard completo: Global superstore dashboard.pdf

## Herramientas utilizadas
- SQL (DB Browser for SQLite)
- Power Query (ETL y limpieza de datos)
- Power BI Desktop (visualización y DAX)
- Dataset: Global Superstore (Kaggle)

## Técnicas SQL utilizadas
- SELECT, WHERE, GROUP BY, HAVING, ORDER BY
- JOINs (INNER JOIN, LEFT JOIN)
- Subconsultas anidadas
- CASE WHEN
- CTEs (Common Table Expressions)
- Window Functions (RANK, LAG, PARTITION BY)

## Autor
Daniel Esquivel — Ingeniero Industrial en transición a Data Analytics  
Bogotá, Colombia — 2026
