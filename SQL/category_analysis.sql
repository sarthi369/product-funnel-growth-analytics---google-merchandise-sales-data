## Category-wise funnel analysis

WITH category_funnel AS (
    SELECT 
        i.category,
        COUNT(
            DISTINCT CASE
                WHEN e.type = 'add_to_cart'
                THEN e.user_id
            END
        ) AS cart_users,

        COUNT(
            DISTINCT CASE
                WHEN e.type = 'begin_checkout'
                THEN e.user_id
            END
        ) AS checkout_users,

        COUNT(
            DISTINCT CASE
                WHEN e.type = 'purchase'
                THEN e.user_id
            END
        ) AS purchase_users
    FROM events e
    LEFT JOIN items i
    ON e.item_id = i.id
    GROUP BY i.category
),

conversion_table AS (
    SELECT *,
    ROUND(
        checkout_users * 100.0 / cart_users,
        2
    ) AS checkout_conversion,

    ROUND(
        purchase_users * 100.0 / checkout_users,
        2
    ) AS purchase_conversion
    FROM category_funnel
)

SELECT *
FROM conversion_table
WHERE category NOT IN (
    'Black Lives Matter',
    'Fun',
    'Uncategorized Items'
)
AND cart_users >= 100
ORDER BY checkout_conversion DESC;
