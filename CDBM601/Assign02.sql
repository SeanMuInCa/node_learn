-- 1. Question 1
SELECT 
	customer_name
FROM customer
WHERE city LIKE 'Montr_al';

-- 2. Question 2:
SELECT 
	product_name,
    price
FROM product
WHERE price > 20;

-- 3. Question 3:
SELECT
	COUNT(*) AS totalOrder,
	YEAR(order_date) AS Yearly
FROM customer_order
GROUP BY Yearly;

-- 4. Question 4:
SELECT 
	ca.category_name,
    p.product_name
FROM category AS ca 
	JOIN product AS p ON ca.category_id = p.category_id
ORDER BY ca.category_name, p.product_name ASC;

-- 5. Question 5:
-- Option 1 is used for marking
SELECT 
	p.product_name
FROM 
	product AS p
WHERE 
	p.product_id IN
		(SELECT 
			od.product_id
		FROM
			order_detail AS od
			JOIN customer_order AS co ON od.order_id = co.order_id
		GROUP BY product_id
		HAVING (COUNT( DISTINCT co.customer_id) > 10));

-- Option 2: used for your comments to learn which one is better! Thank you.       
SELECT 
    od.product_id,
    p.product_name,
    COUNT(DISTINCT co.customer_id) AS customer_count
FROM 
    order_detail AS od
	JOIN 
		product AS p ON od.product_id = p.product_id
	JOIN
		customer_order AS co ON od.order_id = co.order_id
GROUP BY 
    od.product_id
HAVING customer_count > 10;

-- 6. Question 6:
SELECT 
	od.order_id,
    co.order_date,
    SUM(od.quantity * p.price) AS subtotal
FROM
	order_detail AS od
	JOIN
		customer_order AS co ON od.order_id = co.order_id
	JOIN
		product AS p ON od.product_id = p.product_id
GROUP BY od.order_id
ORDER BY subtotal DESC
LIMIT 20;

-- 7. Question 7:  
-- option 1: used to mark  
SELECT 
	e.first_name,
	e.last_name,
    SUM(s.subtotal) as totalSale
FROM employee AS e
	JOIN customer_order AS o ON o.employee_id = e.employee_id
    JOIN
		(SELECT od.order_id,
				o.order_date,
				SUM(p.price*od.quantity) AS subtotal
			FROM order_detail as od
				JOIN product as p ON p.product_id = od.product_id
				JOIN customer_order as o ON od.order_id = o.order_id
			GROUP BY order_id) AS s ON s.order_id = o.order_id
GROUP BY last_name,first_name
ORDER BY totalSale DESC
;
-- Option 2: used to learn from your comments. Thank you!
SELECT 
	e.employee_id,
	e.first_name,
    e.last_name,
    SUM(od.quantity * p.price) AS totalsales
FROM
	employee AS e
JOIN
	customer_order AS co ON e.employee_id = co.employee_id
JOIN
	order_detail AS od ON co.order_id = od.order_id
JOIN product AS p ON od.product_id = p.product_id
GROUP BY e.employee_id
ORDER BY totalsales DESC;
    
-- 8.Question 8:
-- Option 1: Used to mark
SELECT 
    product_name
FROM 
    product
WHERE 
    product_id IN (
        SELECT 
            DISTINCT product_id
        FROM 
            order_detail
    );
-- Option 2: Used to learn from your comments. Thank you!
SELECT 
	p.product_name
FROM product AS p 
	RIGHT JOIN order_detail AS od ON od.product_id = p.product_id
GROUP BY p.product_id
HAVING COUNT(order_id) > 0
;

-- 9. Question9:
SELECT 
	c.customer_id,
	c.customer_name,
	c.contact_name,
	c.address,
	c.city,
	c.country,
	c.postal_code,
    CASE
		WHEN COUNT(co.order_id) >= 10 THEN "gold"
        WHEN COUNT(co.order_id) BETWEEN 5 AND 9 THEN "silver"
        WHEN COUNT(co.order_id) >= 1 THEN "bronze"
        ELSE NULL
	END AS loyalty_program
FROM customer AS c
	LEFT JOIN customer_order AS co ON c.customer_id = co.customer_id
GROUP BY c.customer_id;

-- 10. Question 10:
SELECT 
	c.customer_name
FROM customer AS c
WHERE EXISTS (
			SELECT 1 
            FROM customer_order AS co 
				JOIN order_detail AS od ON od.order_id = co.order_id
			WHERE product_id = 42 AND co.customer_id = c.customer_id
            );
    