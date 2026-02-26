SELECT 
    c.customer_id,
    CONCAT(
        c.first_name, ' ', 
        c.last_name,
        CASE 
            WHEN c.second_name IS NOT NULL AND c.second_name <> '' 
            THEN ' ' || c.second_name 
            ELSE '' 
        END
    ) AS full_name,
    p.report_date,
    p.order_id,
    p.price * p.count AS order_amount,
    SUM(p.price * p.count) OVER (
        PARTITION BY c.customer_id 
        ORDER BY p.report_date, p.order_id
        ROWS UNBOUNDED PRECEDING
    ) AS cumulative_spent
FROM 
    pharma_orders p
JOIN 
    customers c ON p.customer_id = c.customer_id
ORDER BY 
    c.customer_id, 
    p.report_date, 
    p.order_id;
 