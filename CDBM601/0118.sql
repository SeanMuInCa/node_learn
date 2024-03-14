CREATE TABLE players (
	id INT AUTO_INCREMENT,
	handle VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    PRIMARY KEY (id),
	-- naming convention
    CONSTRAINT CHK_age CHECK (age >= 14)
);

insert into players(handle, email, age)
	values("player2","email2@email2.com",18);
    
select * from players;

ALTER TABLE players
ADD birthday DATE NOT NULL;

ALTER TABLE players
ADD newsletter VARCHAR(3) DEFAULT "no";

INSERT INTO players(handle, email, age, birthday, newsletter)
	VALUES("player3", "email3@email3.com", 15,"1981-04-27","y");
    
ALTER TABLE players MODIFY newsletter VARCHAR(1) DEFAULT "n";

UPDATE players SET newsletter = "y" WHERE newsletter = "yes";
UPDATE players SET newsletter = "n" WHERE newsletter = "no";

desc players;

ALTER TABLE players ADD test_number FLOAT DEFAULT 2.2;

ALTER TABLE players MODIFY test_number FLOAT DEFAULT 2.6;

ALTER TABLE players DROP COLUMN test_number;

CREATE TABLE customer (
	id INT NOT NULL AUTO_INCREMENT,
    cust_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    country VARCHAR(3) NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE customer_order (
	id INT NOT NULL AUTO_INCREMENT,
    -- format: YYYY-MM-DD
    order_date DATE NOT NULL,
    customer_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);
CREATE TABLE product (
	id INT NOT NULL AUTO_INCREMENT,
    product_description VARCHAR(255),
    price FLOAT(2) DEFAULT 0.00,
    PRIMARY KEY (id)
);
CREATE TABLE sale (
	order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    -- creating a new reference for the primary ley that is multiple fileds
	-- naming convention
    CONSTRAINT PK_Sale PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES customer_order (id),
    FOREIGN KEY (product_id) REFERENCES product (id)
);

ALTER TABLE players CHANGE COLUMN handle user_name VARCHAR(50);

ALTER TABLE players ADD CONSTRAINT CHK_too_old CHECK(age <= 150);
select * from players;
DESC players;

INSERT INTO players (user_name, email, age, birthday)
	VALUES("zs", "zs@z.com", 160, "1900-01-01");
    
ALTER TABLE players DROP CONSTRAINT CHK_too_old;

SELECT * FROM information_schema.table_constraints WHERE table_name = "players";

#DELETE FROM players WHERE id = 3;

#DROP TABLE sale ; 

SELECT * FROM information_schema.table_constraints;

#ALTER TABLE customer_order DROP FOREIGN KEY customer_order_ibfk_1;

#ALTER TABLE sale DROP FOREIGN KEY sale_ibfk_2;

DROP TABLE product;

SELECT * FROM city_population;

SELECT population_estimate_2012, city FROM city_population;

SELECT * FROM city_population
LIMIT 0, 10;

SELECT * FROM city_population
ORDER BY state, city;

SELECT city FROM city_population
ORDER BY population_estimate_2012 DESC
LIMIT 0, 10;

SELECT DISTINCT state FROM city_population;

SELECT * FROM city_population
WHERE state = 'CA'
ORDER BY population_estimate_2012 DESC
LIMIT 0, 3;

SELECT city FROM city_population
WHERE state = 'AZ'
ORDER BY population_estimate_2012 DESC
LIMIT 0, 1;

SELECT city FROM city_population
WHERE state = 'TX'
ORDER BY population_estimate_2012
LIMIT 0, 3;

SELECT * FROM city_population
WHERE city LIKE 'San Jo_';

SELECT * FROM city_population
WHERE city LIKE 'L_s %';

