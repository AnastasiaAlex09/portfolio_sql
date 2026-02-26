WITH 
    moscow_sales AS (
        SELECT 
            DATE_TRUNC('month', report_date::date)::DATE AS month,
            SUM(price * count) AS sales
        FROM 
            pharma_orders
        WHERE 
            city = 'Москва'
        GROUP BY 
            DATE_TRUNC('month', report_date::date)
    ),
        spb_sales AS (
        SELECT 
            DATE_TRUNC('month', report_date::date)::DATE AS month,
            SUM(price * count) AS sales
        FROM 
            pharma_orders
        WHERE 
            city = 'Санкт-Петербург'
        GROUP BY 
            DATE_TRUNC('month', report_date::date)
    )
SELECT 
    COALESCE(m.month, s.month) AS month,
    m.sales AS moscow_sales,
    s.sales AS spb_sales,
    CASE 
        WHEN m.sales IS NULL THEN -100.0
        WHEN s.sales IS NULL THEN 100.0
        WHEN s.sales = 0 THEN NULL
        ELSE ROUND(
            (m.sales::NUMERIC - s.sales::NUMERIC) / s.sales * 100, 
            2
        )
    END AS pct_diff_moscow_vs_spb
FROM 
    moscow_sales m
FULL OUTER JOIN 
    spb_sales s ON m.month = s.month
ORDER BY 
    month;