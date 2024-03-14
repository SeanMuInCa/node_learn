SELECT * from `Happiness Report 2016` limit 10;
SELECT * FROM country_info ;

#inner join
SELECT income_group,happiness_score,c.country 
FROM `Happiness Report 2016` h JOIN country_info c
ON c.country = h.country;

SELECT income_group,happiness_score,c.country 
FROM `Happiness Report 2016` AS h JOIN country_info AS c
ON c.country = h.country
ORDER BY happiness_score DESC;

SELECT region , avg(h.happiness_score) #the first score randomly so need avg
FROM `Happiness Report 2016` AS h JOIN country_info AS c
ON c.country = h.country
GROUP BY region
ORDER BY avg(h.happiness_score) DESC;


#What is the average happiness score and happiness rank of countries based on income level?
SELECT avg(happiness_rank) avg_happy_rank , avg(h.happiness_score) avg_happy_score ,income_group,max(happiness_score), min(happiness_score),COUNT(*)
FROM `Happiness Report 2016` AS h JOIN country_info AS c
ON c.country = h.country
GROUP BY income_group;

SELECT * FROM Album;

# which aritist write rock music?

SELECT distinct # distinct has to be on the top
       g.Name,
	   ar.Name
FROM Track as t 
	JOIN Genre g on t.GenreId = g.GenreId
	JOIN Album al on al.AlbumId = t.AlbumId
	JOIN Artist ar ON ar.ArtistId = al.ArtistId
WHERE g.Name = 'Rock';

# How many songs are their in each genre?

SELECT g.Name, COUNT(tr.TrackId) AS number_of_songs
	FROM Track AS tr
    JOIN Genre AS g ON tr.GenreId = g.GenreId
    GROUP BY g.GenreId;
    
# Create a query that shows the invoice lines with the names of each track and album instead of the ids.

SELECT il.*,  t.Name, al.Title from InvoiceLine il 
	join Track t on il.TrackId = t.TrackId
    join Album al on al.AlbumId = t.AlbumId;
    
# which is the highest selling album?

select al.Title, il.TrackId, SUM(il.Quantity * il.UnitPrice) "total", al.AlbumId
from InvoiceLine il
	join Track t on t.TrackId = il.TrackId
    join Album al on t.AlbumId = al.AlbumId
GROUP BY al.AlbumId
ORDER BY total desc
LIMIT 0, 1;

SELECT t.Name
FROM Album AS al JOIN Track t on al.AlbumId = t.AlbumId
WHERE al.title = 'Battlestar Galactica (Classic),Seanson 1';

SELECT Name, AlbumId
from Track
WHERE AlbumId IN (
				SELECT AlbumId FROM Album WHERE Title = 'Battlestar Galactica (Classic), Season 1'
				);


SELECT * FROM city_population;

# which city has a population above the avg population

SELECT city from city_population
WHERE population_estimate_2012 > (
	SELECT avg(population_estimate_2012) from city_population
);

select * from
(SELECT t.name as song_name,
a.Title as album_name,
ar.Name as artist
from Track as t
join Album as a on a.AlbumId = t.AlbumId
join Artist as ar on a.ArtistId = ar.ArtistId) as track_info
WHERE Artist = "Nirvana";

#which customer has spent the most ? just name
SELECT FirstName, LastName from Customer
WHERE CustomerId = (
	SELECT CustomerId
from Invoice
GROUP BY CustomerId
ORDER BY sum(Total) desc
limit 0,1
);

#which tracks are rock?
SELECT AlbumId
FROM Track
WHERE GenreId = (
				SELECT GenreId FROM Genre 
                WHERE Name="Rock");

#which album are rock?

SELECT AlbumId from Album
WHERE AlbumId IN (
	SELECT distinct AlbumId
	FROM Track
	WHERE GenreId = (
				SELECT GenreId FROM Genre 
                WHERE Name="Rock")
);


#which artist are rock?
SELECT Name from Artist
WHERE ArtistId IN (
	SELECT ArtistId from Album
	WHERE AlbumId IN (
		SELECT distinct AlbumId
		FROM Track
		WHERE GenreId = (
					SELECT GenreId FROM Genre 
					WHERE Name="Rock")));
                    

