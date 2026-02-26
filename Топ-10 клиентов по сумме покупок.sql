SELECT 
    customer_id,
    full_name,
    total_spent
FROM (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name, 
               CASE WHEN c.second_name IS NOT NULL AND c.second_name <> '' 
                    THEN ' ' || c.second_name 
                    ELSE '' 
               END) AS full_name,
        SUM(p.price * p.count) AS total_spent,
        ROW_NUMBER() OVER (ORDER BY SUM(p.price * p.count) DESC) AS rn
    FROM 
        pharma_orders p
    JOIN 
        customers c ON p.customer_id = c.customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, c.second_name
) AS ranked_customers
WHERE rn <= 10;
 