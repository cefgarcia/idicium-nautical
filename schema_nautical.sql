WITH clientes AS (

    SELECT
        o.customer_id,

        SUM(o.total) AS faturamento_total,

        COUNT(o.id) AS frequencia,

        SUM(o.total) / COUNT(o.id) AS ticket_medio

    FROM orders o

    GROUP BY o.customer_id

),

diversidade AS (

    SELECT
        o.customer_id,

        COUNT(DISTINCT p.category_id) AS diversidade_categorias

    FROM orders o

    JOIN order_items oi
        ON o.id = oi.order_id

    JOIN product_variants pv
        ON oi.product_variant_id = pv.id

    JOIN products p
        ON pv.product_id = p.id

    GROUP BY o.customer_id

),

clientes_elite AS (

    SELECT
        c.customer_id,
        c.faturamento_total,
        c.frequencia,
        c.ticket_medio,
        d.diversidade_categorias

    FROM clientes c

    JOIN diversidade d
        ON c.customer_id = d.customer_id

    WHERE d.diversidade_categorias >= 13

)

SELECT
    customer_id,
    faturamento_total,
    frequencia,
    ticket_medio,
    diversidade_categorias

FROM clientes_elite

ORDER BY
    ticket_medio DESC,
    customer_id ASC

LIMIT 10; 