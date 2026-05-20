## Revenue Analysis

SELECT 
    i.category,
    SUM(i.price_in_usd) AS revenue
FROM events e
LEFT JOIN items i
ON e.item_id = i.id
WHERE e.type = 'purchase'
GROUP BY i.category
ORDER BY revenue DESC;


##Revenue Funnel

With revenue_funnel AS (
Select i.category,
SUM(
    CASE
        WHEN e.type = 'purchase'
        THEN i.price_in_usd
    END
) AS revenue,
Count(
    Distinct CASE
        When e.type = 'add_to_cart'
        Then e.user_id
    End
) as cart_users,
Count (
Distinct Case
    When e.type = 'begin_checkout'
    Then e.user_id
End) as checkout_users,
Count (
Distinct Case
    When e.type = 'purchase'
    Then e.user_id
End) as purchase_users
From events e
Left Join items i
On e.item_id = i.id
Group by i.category
)

Select category,
revenue,
cart_users,
purchase_users,
Round( checkout_users * 100.0 / cart_users, 2) as checkout_conversion
From revenue_funnel
WHERE category NOT IN (
    'Black Lives Matter',
    'Fun',
    'Uncategorized Items',
    'Gift Cards'
)
AND cart_users >= 100
Order by revenue desc;
