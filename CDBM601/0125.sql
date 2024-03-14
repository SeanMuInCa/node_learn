SELECT city FROM city_population
WHERE city LIKE "San Jos_";

SELECT city FROM city_population
WHERE city LIKE "O%";

SELECT city FROM city_population
WHERE city LIKE "m%" 
	AND population_estimate_2012 > 500000;

SELECT * FROM city_population
WHERE state IN ("CA","WA","OR") AND population_estimate_2012 >= 1000000;

SELECT * FROM city_population;

SELECT city FROM city_population
WHERE state IN ("TX","FL","WA") 
ORDER BY population_estimate_2012 DESC
LIMIT 0, 1;

SELECT city FROM city_population
WHERE population_estimate_2012 > 500000 AND population_estimate_2012 < 1000000;

SELECT city, MAX(population_estimate_2012) FROM city_population
WHERE state IN ("TX","FL","WA");

SELECT * FROM city_population
WHERE population_estimate_2012 BETWEEN 500000 AND 1000000;

SELECT * FROM city_population
WHERE state LIKE "w%" AND NOT state = "wa";

#caculate
SELECT *,
	round(population_estimate_2012 / 1000000, 2) AS "popu_by_mill" FROM city_population;
    
SELECT *, round(population_estimate_2012 * 1.07) AS "population_estimate_next_year" FROM city_population;

SELECT *, round(population_estimate_2012 * 1.07) AS "population_estimate_next_year" FROM city_population
HAVING population_estimate_next_year > 1000000;# having is running the last

SELECT *, round(population_estimate_2012 * 1.07) AS "population_estimate_next_year" FROM city_population
ORDER BY population_estimate_next_year DESC;

SELECT *, CASE 
			WHEN population_estimate_2012 >= 1000000 THEN TRUE
            WHEN population_estimate_2012 < 1000000 THEN FALSE
		END AS "over_million"
FROM city_population;

SELECT *, 
		CASE
			WHEN state IN ("WA","OR","CA") THEN TRUE
            WHEN state NOT IN ("WA","OR","CA") THEN FALSE
        END AS "west_coast"
FROM city_population;

SELECT state, AVG(population_estimate_2012) AS avgerage
FROM city_population
GROUP BY state;

SELECT COUNT(*) AS num_of_city,
		COUNT(DISTINCT state) AS num_of_states,
        SUM(population_estimate_2012) AS total_popu,
		AVG(population_estimate_2012) AS ave,
        MIN(population_estimate_2012) AS min,
        MAX(population_estimate_2012) AS max
FROM city_population;

SELECT state,
		COUNT(*) AS num_of_city,
		COUNT(DISTINCT state) AS num_of_states,
        SUM(population_estimate_2012) AS total_popu,
		AVG(population_estimate_2012) AS ave,
        MIN(population_estimate_2012) AS min,
        MAX(population_estimate_2012) AS max
FROM city_population
GROUP BY state;

SELECT state,
		COUNT(*) AS num_of_city,
		COUNT(DISTINCT state) AS num_of_states,
        SUM(population_estimate_2012) AS total_popu,
		AVG(population_estimate_2012) AS ave,
        MIN(population_estimate_2012) AS min,
        MAX(population_estimate_2012) AS max,
        SUM(
        CASE
			WHEN population_estimate_2012 >= 1000000 THEN 1
            WHEN population_estimate_2012 < 1000000 THEN 0
		END ) "big_city"
FROM city_population
GROUP BY state;

SELECT * FROM most_expensive_films;

SELECT COUNT(*) FROM most_expensive_films;

SELECT COUNT(*) AS num,
		MIN(Year) AS min_year,
        MAX(Year) AS max_year,
        AVG(`Cost (millions  Adjusted)`) AS avg_cost,
        Year
FROM most_expensive_films
GROUP BY Year;

SELECT 
		MIN(Year) AS min_year,
        MAX(Year) AS max_year,
        AVG(`Cost (millions  Adjusted)`) AS avg_cost
FROM most_expensive_films
GROUP BY `Cost (millions  Adjusted)`
LIMIT 0, 10;

SELECT *, 
		CASE 
			WHEN year < 1990 THEN "before 90s"
            WHEN year < 2000 THEN "90s"
            WHEN Year < 2010 THEN "00s"
            WHEN Year < 2020 THEN "10s"
            WHEN Year < 2030 THEN "20s"
        END AS decades,
        round(AVG(`Cost (millions  Adjusted)`), 1) AS avg_cost,
        COUNT(1) "num_movie"
FROM most_expensive_films
GROUP BY decades;

SELECT year,
	COUNT(*) "num"
FROM most_expensive_films
GROUP BY Year
HAVING num > 3;

SELECT AVG(population_estimate_2012), MIN(population_estimate_2012),MAX(population_estimate_2012),city
FROM city_population
WHERE state IN ("wa","or","ca")
GROUP BY city;

SELECT * from `Happiness Report 2016`
WHERE country = 'China'
