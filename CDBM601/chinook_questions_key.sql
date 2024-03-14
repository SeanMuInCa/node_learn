/**  Joins and Relationships:  **/
-- Display the names of all tracks along with their corresponding album titles.
SELECT
	t.track_name,
    al.title
FROM track AS t
	JOIN album AS al ON t.album_id = al.album_id;

-- List all artists along with their albums, showing all artists even if they don't have any albums.
SELECT 
	ar.artist_name,
    al.title
FROM album AS al
	RIGHT JOIN artist AS ar ON al.artist_id = ar.artist_id;

-- Show the names of all tracks along with the name of the artist who performed them.
SELECT t.track_name, ar.artist_name
FROM track AS t
	JOIN album AS al ON al.album_id = t.album_id
    JOIN artist AS ar ON ar.artist_id = al.album_id;

-- Display all invoices along with the customer's name and email address, including invoices without associated customers.
SELECT 
	i.invoice_id,
    c.first_name,
    c.last_name,
    c.email
FROM invoice AS i
	LEFT JOIN customer AS c ON c.customer_id = i.customer_id;

-- Display all playlists along with the tracks they contain, even if there are playlists with no tracks.
SELECT 
	p.playlist_name,
    t.track_name
FROM playlist_track AS pt
	JOIN track AS t ON t.track_id = pt.track_id
    RIGHT JOIN playlist AS p ON p.playlist_id = pt.playlist_id;

-- List the names of all playlists along with the tracks they contain.
SELECT 
	p.playlist_name,
    t.track_name
FROM playlist_track AS pt
	JOIN playlist AS p ON p.playlist_id = pt.playlist_id
    JOIN track AS t ON t.track_id = pt.track_id;

-- Show the names of all tracks along with their genre names.
SELECT 
	t.track_name,
    g.genre_name
FROM track AS t
	JOIN genre AS g ON t.genre_id = g.genre_id;


/**  Aggregation and Grouping:  **/
-- Calculate the total number of tracks in each album.
SELECT 
	al.title,
    COUNT(*) AS num_of_track
FROM track AS t
	JOIN album AS al ON t.album_id = al.album_id
GROUP BY al.album_id;

-- Find the total number of invoices for each customer.
SELECT 
	c.first_name,
    c.last_name,
    COUNT(*) AS num_of_invoices
FROM invoice AS i
	JOIN customer AS c ON c.customer_id = i.customer_id
GROUP BY c.customer_id;

-- Calculate the total amount spent by each customer.
SELECT 
	c.first_name,
    c.last_name,
    SUM(l.quantity * l.unit_price) AS total
FROM invoice_line AS l
	JOIN invoice AS i ON i.invoice_id = l.invoice_id
    JOIN customer AS c ON i.customer_id = c.customer_id
GROUP BY c.customer_id;

-- Find the average track length for each genre.
SELECT 
	g.genre_name,
    ROUND(AVG(t.milliseconds), 2) AS avg_length
FROM track AS t
	JOIN genre AS g ON g.genre_id = t.genre_id
GROUP BY g.genre_id;

-- Determine the total number of tracks in each playlist.
SELECT 
	p.playlist_name,
    COUNT(*) AS num_of_track
FROM track AS t
	JOIN playlist_track AS pt ON t.track_id = pt.track_id
    JOIN playlist AS p ON p.playlist_id = pt.playlist_id
GROUP BY p.playlist_id;

/**  Subqueries and Advanced Queries:  **/
-- Find the names of customers who have made purchases in the USA.
SELECT 
	first_name, 
    last_name
FROM customer
WHERE country = "USA"
	AND customer_id IN(
		SELECT DISTINCT customer_id
        FROM invoice
    );

-- Display the tracks with a duration over the average duration. Display the tracks duration in minutes.
SELECT 
	track_name,
    ROUND(milliseconds/60000, 1) AS minutes
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) 
	FROM track );

-- List the names of all playlists containing tracks longer than 5 minutes.
SELECT playlist_name
FROM playlist
WHERE playlist_id IN (
	SELECT DISTINCT playlist_id
    FROM playlist_track AS pt
		JOIN track AS t ON t.track_id = pt.track_id
	WHERE t.milliseconds > 60000 * 5
);

-- Show the tracks with the highest unit price.
SELECT *
FROM track
WHERE unit_price = (SELECT MAX(unit_price) FROM track);


/**  Data Modification and Transactions:  **/
-- Insert a new customer into the `Customers` table.
SELECT MAX(customer_id) + 1 FROM customer;
INSERT INTO customer (customer_id, first_name, last_name, email, support_rep_id)
	VALUES (60, "First", "Last", "name@provider.com", 1);
    
-- Update the email address of a customer in the `Customers` table.
UPDATE customer SET email = "new_name@provider.com" WHERE customer_id = 60;

-- Insert a new invoice into the `Invoices` table.
SELECT MAX(invoice_id) + 1 FROM invoice;
INSERT INTO invoice (invoice_id, customer_id, invoiceDate, total)
	VALUES (413, 1, "2024-02-27", 20.21);

/**  Correlated Queries:  **/
-- Find the tracks that have been included in playlists.
SELECT * 
FROM track AS t
WHERE EXISTS (
	SELECT *
    FROM playlist_track AS pt
    WHERE pt.track_id = t.track_id
);

-- Find the total number of tracks in each genre with an average track length longer than that genre.
SELECT 
	genre_name, 
    COUNT(*)
FROM track AS t
	JOIN genre AS g ON t.genre_id = g.genre_id
WHERE t.track_id IN (
	SELECT t2.track_id
    FROM track AS t2
    WHERE t.milliseconds > (
		SELECT AVG(t3.milliseconds) 
        FROM track AS t3
		GROUP BY t3.genre_id
        HAVING t3.genre_id = t.genre_id
    )
)
GROUP BY t.genre_id;

/**  Views:  **/
-- Create a view named v_album_sales that shows the total sales revenue for each album.
CREATE VIEW v_album_sales AS
SELECT 
	a.title AS album,
	SUM(l.unit_price * l.quantity) AS sales
FROM invoice_line AS l
	JOIN track AS t ON t.track_id = l.track_id
    JOIN album AS a ON a.album_id = t.album_id
GROUP BY t.album_id;

-- Create a view named v_high_spending_customers that displays customers who have spent more than $40 on purchases.
CREATE VIEW v_high_spending_customers AS
SELECT c.*,
	SUM(i.total) AS customer_sales
FROM invoice AS i
	JOIN customer AS c ON c.customer_id = i.customer_id
GROUP BY i.customer_id
HAVING customer_sales > 40;

-- Create a view named v_track_sales that shows the total sales revenue for each track.
CREATE VIEW v_track_sales AS
SELECT
	t.track_id,
    t.track_name,
    CASE
		WHEN l.invoice_lineId IS NULL THEN 0
        ELSE SUM(l.unit_price * l.quantity)
    END AS sales
FROM track AS t
	LEFT JOIN invoice_line AS l ON l.track_id = t.track_id
GROUP BY t.track_id;

/**  Procedures:  **/
-- Develop a procedure named update_playlist to add tracks to a playlist. The procedure will require the track id and the playlist name. If the playlist name does not exist, create a new playlist with that name.
DROP PROCEDURE IF EXISTS update_playlist;
DELIMITER $$
CREATE PROCEDURE update_playlist(
	IN t_id INT,
    IN pl_name VARCHAR(120)
)
BEGIN
	DECLARE pl_id INT;
    DECLARE next_pl_id INT;
    
    SELECT playlist_id INTO pl_id FROM playlist WHERE playlist_name = pl_name;
    IF pl_id IS NULL THEN 
		SELECT MAX(playlist_id) + 1 INTO next_pl_id FROM playlist;
        INSERT INTO playlist (playlist_id, playlist_name) VALUES (next_pl_id, pl_name);
        SELECT playlist_id INTO pl_id FROM playlist WHERE playlist_name = pl_name;
    END IF;
    
    INSERT INTO playlist_track (playlist_id, track_id) VALUES (pl_id, t_id);
END $$
DELIMITER ;

-- test proceedure
SELECT * FROM playlist;
CALL update_playlist(1, "Grunge");
SELECT * 
FROM playlist_track AS pt
	JOIN playlist AS p ON p.playlist_id = pt.playlist_id
WHERE track_id = 1;
CALL update_playlist(1, "NEWGrunge");
SELECT * 
FROM playlist_track AS pt
	JOIN playlist AS p ON p.playlist_id = pt.playlist_id
WHERE track_id = 1;