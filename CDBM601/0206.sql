#we create this based on a uml, where produce is a super class, frozen is sub class
#and there is an attribute in produce class called harvestDate is an attribute you caculate in the constrcutor
CREATE TABLE produce(
	produce_id INT AUTO_INCREMENT,
    veg_type VARCHAR(50) NOT NULL,
    variety VARCHAR(50) NOT NULL,
    sow_date DATE NOT NULL,
    grow_day INT NOT NULL,
    lot_number VARCHAR(50) NOT NULL,
    PRIMARY KEY (produce_id)
);

CREATE TABLE frozen_produce(
	frozen_produce_id INT AUTO_INCREMENT,
    freeze_date DATE NOT NULL,
    best_before DATE NOT NULL,
    produce_id INT NOT NULL,
    PRIMARY KEY (frozen_produce_id),
    FOREIGN KEY (produce_id) REFERENCES produce(produce_id)
);

INSERT INTO produce (veg_type, variety, sow_date, grow_day, lot_number)
	VALUES ('Beans', 'Fandango', '2023-05-28', 55, 'lotc1992');
INSERT INTO produce (veg_type, variety, sow_date, grow_day, lot_number)
	VALUES ('Carrot', 'Autum King', '2023-05-28', 70, 'lotc1993');
INSERT INTO produce (veg_type, variety, sow_date, grow_day, lot_number)
	VALUES ('Onion', 'Nebula', '2023-05-28', 175, 'lotc1994');
INSERT INTO produce (veg_type, variety, sow_date, grow_day, lot_number)
	VALUES ('Kale', 'Squire', '2023-05-28', 60, 'lotc1995');
INSERT INTO produce (veg_type, variety, sow_date, grow_day, lot_number)
	VALUES ('Potato', 'Yukon Gem', '2023-05-28', 112, 'lotc1996');
	
SELECT *,
	DATE_ADD(sow_date,INTERVAL grow_day DAY) AS harvest_date #new
 FROM produce;

INSERT INTO produce (veg_type, variety, sow_date, grow_day, lot_number)
	VALUES ('Basil', 'Genovese', '2023-05-28', 10, 'lotc1997');

SELECT * FROM produce;
INSERT INTO frozen_produce (produce_id, freeze_date, best_before)
	VALUES (1, '2023-08-31', '2023-12-29');
SELECT * FROM frozen_produce;

CREATE VIEW v_produce AS
SELECT *,
	DATE_ADD(sow_date,INTERVAL grow_day DAY) AS harvest_date
 FROM produce;
 
SELECT * FROM v_produce;

CREATE OR REPLACE VIEW answers AS
SELECT name FROM artist
WHERE ArtistId IN(
		SELECT ArtistId FROM album
		WHERE AlbumId IN(
			SELECT AlbumId FROM track 
			WHERE GenreId = 1
		)
);
CREATE OR REPLACE VIEW answers AS
SELECT a.name, al.Title, t.name AS "trackName"
FROM artist a JOIN album al ON a.ArtistId = al.ArtistId
JOIN track t ON t.AlbumId = al.AlbumId
JOIN genre g ON g.GenreId = t.GenreId
WHERE g.name = 'Rock'
GROUP BY a.name;

SELECT * FROM answers;


CREATE VIEW v_customer_reports AS
SELECT
	FirstName,
    LastName,
    SUM(i.Total) AS total_purchases,
    country,
    i.InvoiceId,
    i.InvoiceDate
FROM Customer AS c
	JOIN Invoice AS i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY total_purchases DESC;

SELECT * FROM v_customer_reports;

SELECT a.name, al.Title, t.name AS "trackName"
FROM artist a JOIN album al ON a.ArtistId = al.ArtistId
JOIN track t ON t.AlbumId = al.AlbumId
JOIN genre g ON g.GenreId = t.GenreId;



CREATE VIEW v_employee_report AS
SELECT
	e.FirstName,
    e.LastName,
    e.Title,
    e.HireDate,
    CONCAT(e2.FirstName, " ", e2.LastName) AS reportsTo,
    c.company,
    COUNT(DISTINCT(c.CustomerId)) AS num_of_customers,
    COUNT(DISTINCT(InvoiceId)) AS num_of_invoices,
    SUM(total)
FROM Customer AS c
	JOIN Invoice AS i ON c.CustomerId = i.CustomerId
    JOIN Employee AS e ON c.SupportRepId = e.EmployeeId
    JOIN Employee AS e2 ON e.ReportsTo = e2.EmployeeId
GROUP BY e.EmployeeId, c.company;

SELECT * FROM v_employee_report;

CREATE VIEW v_track_information AS
SELECT 
	t.TrackId,
    t.Name AS track_name,
    al.Title AS album_title,
    g.Name AS genre,
    t.Composer,
    t.UnitPrice,
    ar.Name AS artist
FROM Track AS t
	JOIN Album AS al ON al.AlbumId = t.AlbumId
    JOIN Artist AS ar ON ar.ArtistId = al.ArtistId
    JOIN Genre AS g ON g.GenreId = t.GenreId;

SELECT * FROM v_track_information;

CREATE VIEW v_track_sales AS
SELECT 
	t.TrackId,
    t.Name AS track_name,
    al.Title AS album_title,
    g.Name AS genre,
    t.Composer,
    t.UnitPrice,
    ar.Name AS artist,
    SUM(i.Quantity) AS num_sales,
    SUM(i.Quantity * t.UnitPrice) AS total_sales
FROM Track AS t
	JOIN Album AS al ON al.AlbumId = t.AlbumId
    JOIN Artist AS ar ON ar.ArtistId = al.ArtistId
    JOIN Genre AS g ON g.GenreId = t.GenreId
    JOIN InvoiceLine AS i ON i.TrackId = t.TrackId
GROUP BY t.TrackId;

SELECT * FROM v_track_sales;