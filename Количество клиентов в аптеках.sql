SELECT 
    p.pharmacy_name,
    COUNT(DISTINCT c.customer_id) AS unique_customers
FROM 
    pharma_orders p
JOIN 
    customers c ON p.customer_id = c.customer_id
GROUP BY 
    p.pharmacy_name
ORDER BY 
    unique_customers DESC;