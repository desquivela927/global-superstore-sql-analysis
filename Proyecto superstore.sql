-- ================================================
-- PROYECTO SUPERSTORE — Análisis de ventas globales
-- Daniel Esquivel — 2026
-- Herramienta: DB Browser for SQLite
-- Dataset: Global Superstore (Kaggle)
-- ================================================

-- PREGUNTA 1: Top 10 productos por ingresos totales
SELECT [Product.Name],
       SUM(Sales) AS total_ingresos,
       SUM(Quantity) AS total_unidades
FROM Superstore
GROUP BY [Product.Name]
ORDER BY total_ingresos DESC
LIMIT 10;

-- PREGUNTA 2: Total de ventas, profit y profit promedio por categoría
SELECT Category, 
       SUM(Sales) AS Total_ventas, 
       SUM(Profit) AS Total_profit, 
       ROUND(AVG(Profit)) AS Profit_promedio
FROM superstore
GROUP BY Category
ORDER BY Total_ventas DESC
-- Conclusión: Technology lidera tanto en ventas como en profit.

-- PREGUNTA 3: Ventas, profit y órdenes por región
SELECT Region, 
       SUM(Sales) AS Total_ventas, 
	   SUM(Profit) AS Total_profit, 
	   ROUND(AVG(Profit)) AS Profit_promedio,
	   COUNT([Order.Id]) AS Cantidad_ordenes
FROM superstore
GROUP BY Region
ORDER BY Total_ventas DESC
-- Conclusión: Central lidera en ventas pero North Asia es la región más rentable — mayor profit promedio.
-- Insight: alto volumen de ventas no garantiza mayor rentabilidad.

-- PREGUNTA 4: Países con ventas superiores al promedio global
SELECT Country, SUM(Sales) AS Ventas_totales
FROM superstore
GROUP BY Country
HAVING SUM(Sales) > (SELECT AVG(Ventas_por_pais)
                     FROM (SELECT SUM(Sales) AS Ventas_por_pais
					       FROM superstore
					       GROUP BY Country))
ORDER BY Ventas_totales
-- Técnica: subconsulta anidada en HAVING
-- Resultado: 28 países superan el promedio
-- Conclusión: Ucrania lidera — resultado inesperado que merece análisis adicional.

-- PREGUNTA 5: Clasificación de órdenes por rentabilidad
SELECT CASE WHEN Profit > 100 THEN 'Alta'
            WHEN Profit BETWEEN 0 AND 100 THEN 'Media' ELSE 'Perdida'
	    END AS Clasificacion,
       COUNT([Order.Id]) AS Total_ordenes
FROM superstore
GROUP BY Clasificacion
ORDER BY Total_ordenes DESC	
-- Técnica: CASE WHEN + GROUP BY
-- Resultado: Alta: 5.775 | Media: 32.971 | Pérdida: 12.544
-- Conclusión: El 64% de órdenes tiene rentabilidad media lo que amortigua el impacto del 24% de órdenes con pérdida.
-- Recomendación: convertir órdenes con pérdida en rentabilidad media.

-- PREGUNTA 6: Profit por segmento de clientes
SELECT Segment, SUM(Profit) AS Profit_total, ROUND(SUM(Profit) *100 / (SELECT SUM(Profit) FROM superstore),2) AS Porcentaje
FROM superstore
GROUP BY Segment
ORDER BY Profit_total DESC
-- Técnica: subconsulta para calcular porcentaje del total
-- Resultado: Consumer 51.06% | Corporate 30.07% | Home Office 18.88%
-- Conclusión: Consumer genera más de la mitad del profit total.
-- Recomendación: priorizar retención del segmento Consumer, ya que su pérdida tendría impacto crítico en la rentabilidad.

-- PREGUNTA 7: Top 5 países por ventas dentro de cada región

-- Técnica: CTE + RANK() + PARTITION BY Región
WITH Ranking_paises AS (
                        SELECT Region, Country, SUM(Sales) AS Total_ventas,
						       RANK() OVER(PARTITION BY Region
					                       ORDER BY SUM(Sales) DESC) AS Ranking
						FROM superstore
	                    GROUP BY Region, Country)
SELECT Region, Country, Total_ventas, Ranking
FROM Ranking_paises
WHERE Ranking <= 5
ORDER BY Region, Ranking ASC
-- Resultado: USA aparece como #1 en múltiples regiones
-- Observación: revisar definición de "región" en el dataset, porque al parecer no son regiones geográficas
-- Validación pendiente: confirmar criterio de segmentación regional

-- PREGUNTA 8: Diferencia de ventas año a año
WITH Ventas_anuales AS (
                        SELECT Year, SUM(Sales) AS Ventas_totales,
			            LAG(SUM(Sales)) OVER(ORDER BY Year ASC) AS Ventas_año_anterior
			            FROM superstore
			            GROUP BY Year)
			
SELECT Year, Ventas_totales, Ventas_año_anterior, ROUND(Ventas_totales - Ventas_año_anterior) AS Diferencia
FROM Ventas_anuales
ORDER BY Year ASC
-- Técnica: CTE + LAG() Window Function LAG() permite comparar cada año contra el anterior automáticamente
-- Resultado: ventas crecen consistentemente año a año.
-- Conclusión: tendencia positiva sostenida — negocio en expansión.


-- PREGUNTA 9: Productos con pérdida en categorías rentables
WITH Categoria_profit AS (
                        SELECT Category, SUM(Profit) AS Profit_total
			            FROM superstore
			            GROUP BY Category
						HAVING SUM(Profit) > 0)

SELECT s.Category, s.[Product.Name], ROUND(SUM(s.Profit)) AS Profit_producto,
                                     ROUND(cp.Profit_total) AS Profit_categoria
FROM superstore s JOIN Categoria_profit cp ON s.Category = cp.Category
GROUP BY s.category, s.[Product.Name], cp.Profit_total
HAVING SUM(s.Profit) < 0
ORDER BY Profit_producto
-- Técnica: CTE + JOIN + HAVING
-- Resultado: 678 productos con profit negativo.
-- Producto con mayor pérdida: Cubify CubeX 3D Printer Double Head.
-- Conclusión: revisar estrategia de precios y descuentos en estos productos para mejorar rentabilidad.

-- PREGUNTA 10: Impacto del modo de envío en el profit
SELECT [Ship.Mode],
       AVG([Shipping.Cost]) AS Promedio_costo_envio,
	   AVG(Profit) AS Profit_promedio,
	   COUNT([Order.Id]) AS Total_ordenes,
	   ROUND (SUM(Profit)) AS Profit_total,
	   ROUND (SUM(Profit)*100 / (SELECT SUM(Profit) FROM superstore), 2) AS Porcentaje_profit
FROM superstore
GROUP BY [Ship.Mode]
ORDER BY Profit_total DESC
-- Técnica: AVG + COUNT + SUM + subconsulta para porcentaje
-- Resultado: Standard Class lidera en profit total
-- Same Day: costo más alto, profit más bajo
-- First Class: costo similar a Same Day pero 3x más profit
-- Conclusión: revisar estrategia de Same Day — desalineación entre costo logístico y margen de productos.
-- Recomendación: analizar qué productos y segmentos usan First Class para replicar ese modelo en Same Day.



