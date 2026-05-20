## Overall funnel analysis

WITH funnel_summary AS (

    SELECT
    COUNT(
        DISTINCT CASE
            WHEN type = 'add_to_cart'
            THEN user_id
        END
    ) AS cart_users,

    COUNT(
        DISTINCT CASE
            WHEN type = 'begin_checkout'
            THEN user_id
        END
    ) AS checkout_users,

    COUNT(
        DISTINCT CASE
            WHEN type = 'purchase'
            THEN user_id
        END
    ) AS purchase_users
    FROM events
)

SELECT *,
ROUND(
    checkout_users * 100.0 / cart_users,
    2
) AS checkout_conversion,

ROUND(
    purchase_users * 100.0 / checkout_users,
    2
) AS purchase_conversion
FROM funnel_summary;
