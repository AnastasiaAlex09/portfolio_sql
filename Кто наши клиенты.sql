WITH customer_groups AS (
    SELECT 
        p.order_id,
        p.price * p.count AS sale_amount,
        -- Приводим gender к единому виду
        CASE 
            WHEN LOWER(TRIM(c.gender)) = 'муж' THEN 'М'
            WHEN LOWER(TRIM(c.gender)) = 'жен' THEN 'Ж'
            ELSE 'Другое'
        END AS gender_clean,
        -- Вычисляем возраст
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.date_of_birth::date))::INTEGER AS age,
        -- Определяем группу
        CASE 
            WHEN LOWER(TRIM(c.gender)) = 'муж' AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.date_of_birth::date)) < 30 THEN 'Мужчины младше 30'
            WHEN LOWER(TRIM(c.gender)) = 'муж' AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.date_of_birth::date)) BETWEEN 30 AND 45 THEN 'Мужчины 30–45'
            WHEN LOWER(TRIM(c.gender)) = 'муж' AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.date_of_birth::date)) > 45 THEN 'Мужчины старше 45'
            WHEN LOWER(TRIM(c.gender)) = 'жен' AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.date_of_birth::date)) < 30 THEN 'Женщины младше 30'
            WHEN LOWER(TRIM(c.gender)) = 'жен' AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.date_of_birth::date)) BETWEEN 30 AND 45 THEN 'Женщины 30–45'
            WHEN LOWER(TRIM(c.gender)) = 'жен' AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.date_of_birth::date)) > 45 THEN 'Женщины старше 45'
            ELSE 'Другое'
        END AS customer_group
    FROM 
        pharma_orders p
    JOIN 
        customers c ON p.customer_id = c.customer_id
    WHERE 
        c.date_of_birth IS NOT NULL 
        AND c.gender IS NOT NULL
),
group_sales AS (
    SELECT 
        customer_group,
        SUM(sale_amount) AS group_sales
    FROM 
        customer_groups
    GROUP BY 
        customer_group
),
total_sales AS (
    SELECT SUM(group_sales) AS total FROM group_sales
)
SELECT 
    g.customer_group,
    g.group_sales,
    ROUND((g.group_sales::NUMERIC / t.total) * 100, 2) AS share_percent
FROM 
    group_sales g
CROSS JOIN 
    total_sales t
ORDER BY 
    g.group_sales DESC;