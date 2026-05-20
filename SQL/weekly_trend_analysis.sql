## Weekly funnel analysis

WITH weekly_funnel AS (

SELECT
    DATE(date, '-' || ((strftime('%w', date) + 6) % 7) || ' days')
    AS week_start,

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

GROUP BY week_start
)

SELECT *
FROM weekly_funnel
ORDER BY week_start;
