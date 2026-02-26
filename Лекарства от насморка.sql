WITH aqua_drugs AS (
    SELECT 
        LOWER(drug) AS drug_name,
        SUM(price * count) AS sales
    FROM 
        pharma_orders
    WHERE 
        LOWER(drug) LIKE 'аква%'
    GROUP BY 
        LOWER(drug)
),
total_sales AS (
    SELECT SUM(sales) AS total FROM aqua_drugs
)
SELECT 
    d.drug_name,
    d.sales,
    ROW_NUMBER() OVER (ORDER BY d.sales DESC) AS rn,
    ROUND(
        (d.sales::NUMERIC / t.total) * 100, 
        2
    ) AS share_percent
FROM 
    aqua_drugs d
CROSS JOIN 
    total_sales t
ORDER BY 
    d.sales DESC;