SELECT 
    pharmacy_name,
    report_date,
    order_id,
    price * count AS sale_amount,
    SUM(price * count) OVER (
        PARTITION BY pharmacy_name 
        ORDER BY report_date, order_id
        ROWS UNBOUNDED PRECEDING
    ) AS cumulative_sales
FROM 
    pharma_orders
ORDER BY 
    pharmacy_name, 
    report_date, 
    order_id;