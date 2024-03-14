select * from produce;

#create procedure
DELIMITER $
CREATE PROCEDURE test1()
BEGIN
	SELECT * FROM produce;
END$
DELIMITER ;

CALL test1();

DELIMITER $
CREATE PROCEDURE test2()
BEGIN
	DECLARE myVar INT;
    SET myVar = 1;
	SELECT * FROM produce WHERE produce_id = myVar;
END$
DELIMITER ;

CALL test2();

DELIMITER $
CREATE PROCEDURE test3(IN myVar INT)
BEGIN
	SELECT * FROM produce WHERE produce_id = myVar;
END$
DELIMITER ;

CALL test3(3);

DELIMITER $
CREATE PROCEDURE test4(IN type_produce INT)
BEGIN
	SELECT * FROM produce WHERE produce_id = type_produce;
END$
DELIMITER ;

CALL test4(2);

DELIMITER $
CREATE PROCEDURE test5(IN type_produce VARCHAR(25))
BEGIN
	DECLARE my_id INT;
	SELECT produce_id INTO my_id FROM produce WHERE veg_type = type_produce;
	SELECT * FROM produce WHERE produce_id = my_id;
END$
DELIMITER ;

CALL test5("Onion");

DELIMITER $
CREATE PROCEDURE test6(IN type_produce VARCHAR(20), OUT return_produce_id INT)
BEGIN
	SELECT produce_id INTO return_produce_id FROM produce
    WHERE veg_type = type_produce;
END$
DELIMITER ;

CALL test6("Onion", @return_id);

SELECT @return_id;

SELECT * FROM produce WHERE produce_id = @return_id;

DELIMITER $
CREATE PROCEDURE add_frozen(IN type_produce VARCHAR(20), IN f_date DATE, IN bb_date DATE)
BEGIN
	DECLARE my_id INT;
	SELECT produce_id INTO my_id FROM produce
    WHERE veg_type = type_produce;
    INSERT INTO frozen_produce(freeze_date,best_before,produce_id)
		VALUES(f_date, bb_date, my_id);
END $
DELIMITER ;

CALL add_frozen("Potato", now(),"2024-09-11");

SELECT * FROM frozen_produce;
SELECT * FROM produce;

#Create and test a procedure that takes the name of an artist and runs a query to out put all their albums in the database.
DELIMITER $
CREATE PROCEDURE get_album_name(IN artist_name VARCHAR(20))
BEGIN
	SELECT Title FROM Album JOIN Artist ON Album.ArtistId = Artist.ArtistId
    WHERE Artist.Name = artist_name;
END $
DELIMITER ;
select * from Genre;
CALL test("Nirvana");

#Create and test a procedure that takes an invoice number and returns how many tracks were bought.
DELIMITER $
CREATE PROCEDURE get_sales_amount(IN invoice_number INT)
BEGIN
	SELECT SUM(Quantity) "count" FROM InvoiceLine
    WHERE InvoiceId = invoice_number;
END $
DELIMITER ;

CALL get_sales_amount(5);

#Create and test a procedure that takes a type of genre and returns all the artists of that genre.
DELIMITER $
CREATE PROCEDURE get_artists_by_genre(IN genre_type VARCHAR(120))
BEGIN
	SELECT DISTINCT ar.Name FROM Artist ar 
    JOIN Album al ON ar.ArtistId = al.ArtistId
    JOIN Track t ON t.AlbumId = al.AlbumId
    JOIN Genre g ON g.GenreId = t.GenreId
    WHERE g.Name = genre_type;
END $
DELIMITER ;

CALL get_artists_by_genre("Rock");

DELIMITER $
CREATE PROCEDURE get_state_by_purchases()
BEGIN
	SELECT c.State FROM Customer c JOIN Invoice i ON c.CustomerId = i.CustomerId
    JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
    ORDER BY (il.UnitPrice * Quantity)  DESC;
END $
DELIMITER ;
select * from Employee;
CALL get_state_by_purchases();

#create a procedure that takes a state and returns the amount of purchases for that state
DELIMITER $
CREATE PROCEDURE get_purchases_by_state(IN state_name VARCHAR(40))
BEGIN
	SELECT SUM(il.UnitPrice * Quantity) "total" FROM InvoiceLine il JOIN Invoice i ON i.InvoiceId = il.InvoiceId
    WHERE i.BillingState = state_name;
END $
DELIMITER ;

CALL get_purchases_by_state("CA");

#create a procedure that takes employee name and list all its associated customer with each customer sales
DELIMITER $
CREATE PROCEDURE get_customer_by_sale(IN last_name VARCHAR(20))
BEGIN
	SELECT c.FirstName,c.LastName FROM Customer c JOIN Employee e ON c.SupportRepId = e.EmployeeId
    WHERE e.LastName = last_name;
END $
DELIMITER ;
select * from Employee;
CALL get_customer_by_sale("Peacock");

DELIMITER $
CREATE PROCEDURE get_customer_by_email(IN email VARCHAR(60))
BEGIN
	SELECT c.FirstName,c.LastName FROM Customer c JOIN Employee e ON c.SupportRepId = e.EmployeeId
    WHERE e.Email = email;
END $
DELIMITER ;

CALL get_customer_by_email("jane@chinookcorp.com");