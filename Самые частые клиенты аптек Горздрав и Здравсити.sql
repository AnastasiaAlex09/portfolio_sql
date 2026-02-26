WITH 
    gorzdrav_top AS (
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
            COUNT(p.order_id) AS order_count,
            'Горздрав' AS pharmacy
        FROM 
            pharma_orders p
        JOIN 
            customers c ON p.customer_id = c.customer_id
        WHERE 
            p.pharmacy_name = 'Горздрав'
        GROUP BY 
            c.customer_id, c.first_name, c.last_name, c.second_name
        ORDER BY 
            order_count DESC
        LIMIT 10
    ),
    
    zdravcity_top AS (
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
            COUNT(p.order_id) AS order_count,
            'Здравсити' AS pharmacy
        FROM 
            pharma_orders p
        JOIN 
            customers c ON p.customer_id = c.customer_id
        WHERE 
            p.pharmacy_name = 'Здравсити'
        GROUP BY 
            c.customer_id, c.first_name, c.last_name, c.second_name
        ORDER BY 
            order_count DESC
        LIMIT 10
    )

SELECT * FROM gorzdrav_top
UNION ALL
SELECT * FROM zdravcity_top
ORDER BY pharmacy, order_count DESC;