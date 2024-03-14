SELECT * FROM city_population;

# find the biggest city in states
SELECT * FROM city_population AS c1
	JOIN
	(SELECT state, 
		   max(population_estimate_2012) AS max
	FROM city_population 
	GROUP BY state) AS c2
    ON c1.state = c2.state
WHERE c1.population_estimate_2012 = c2.max; -- need to review

SELECT * FROM city_population AS c1
WHERE population_estimate_2012 IN (
	SELECT max(population_estimate_2012) FROM city_population c2
    WHERE c1.state = c2.state
);


SELECT TrackId,
		Name,
        AlbumId
FROM Track
WHERE NOT EXISTS ( # not in
	SELECT * FROM InvoiceLine
    WHERE InvoiceLine.TrackId = Track.TrackId
);

SELECT * FROM Track;
SELECT * FROM InvoiceLine;

SELECT 
	a.Title,
    COUNT(*) AS num_not_sold
FROM Track AS t JOIN Album AS a ON t.albumId = a.AlbumId
WHERE NOT EXISTS 
	(
		SELECT * FROM InvoiceLine
        WHERE InvoiceLine.TrackId = t.TrackId
    )
GROUP BY a.AlbumId
ORDER BY num_not_sold DESC;

#Are there any customer's in the database that have not placed an order?
select CustomerId from Customer
WHERE not exists (
select CustomerId from Invoice
where Customer.CustomerId = Invoice.CustomerId
);


# Are there any sales reps that have not made a sale?

	select EmployeeId from Employee e
    where not EXISTS (
    select c.SupportRepId from Customer c
    WHERE c.SupportRepId = e.EmployeeId
    );


SELECT * FROM Customer
WHERE Country = 'Canada'

UNION

SELECT * FROM Customer
WHERE Country = 'USA';

SELECT * FROM Customer
WHERE Country = "Canada"

INTERSECT -- share data in both query

SELECT * FROM Customer
WHERE FirstName LIKE "%a%";


select * from crime_scene_reports
WHERE street = 'Chamberlin Street'
and year = 2020
and month = 7
and day = 28;

select * from courthouse_security_logs c
join people as p on p.license_plate = c.license_plate
where year = 2020
and month = 7
and day = 28
and hour = 10
and minute between 15 and 25;

select * from interviews
where year = 2020
and month = 7
and day = 28
and transcript like '%court%';

select * from atm_transactions
join bank_accounts on bank_accounts.account_number = atm_transactions.account_number
join people on people.id = atm_transactions.id
where year = 2020
and month = 7
and day = 28
and atm_location = 'Fifer Street'
and transaction_type = 'withdraw';

select f.id from flights f
join airports a on f.destination_airport_id = a.id
where year = 2020
and month = 7
and day = 29
order by hour asc limit 1;

select people.passport_number,people.name from passengers 
join people on people.passport_number = passengers.passport_number
where flight_id = 36;

select * from phone_calls
where year = 2020
and day = 28
and month = 7
and duration < 60;

