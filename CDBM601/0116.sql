CREATE TABLE players(
	id INT AUTO_INCREMENT,
    handle VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    age TINYINT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT CHK_age CHECK (age >= 14 )
);

CREATE TABLE course(
	id INT AUTO_INCREMENT,
	course_subject VARCHAR(50) NOT NULL,
    program_id INT NOT NULL,
    PRIMARY KEY (id),
	FOREIGN KEY (program_id) REFERENCES program(id)
);

CREATE TABLE program(
	id INT AUTO_INCREMENT,
    program_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE student(
	student_id INT AUTO_INCREMENT,
    student_name VARCHAR(50) NOT NULL,
    email VARCHAR(25) NOT NULL,
    class_id INT NOT NULL,
    PRIMARY KEY (student_id),
    FOREIGN KEY (class_id) REFERENCES class (class_id)
);

CREATE TABLE class(
	class_id INT AUTO_INCREMENT,
	class_subject VARCHAR(20) NOT NULL,
    prerequisite INT,
    PRIMARY KEY (class_id),
    FOREIGN KEY (prerequisite) REFERENCES class(class_id)
);

CREATE TABLE practice_insert(
	id INT AUTO_INCREMENT,
    user_name VARCHAR(50) NOT NULL,
    country VARCHAR(3),
    PRIMARY KEY (id)
);
SELECT * From practice_insert;
INSERT INTO practice_insert (user_name, country)
	VALUES("one", "CAD");
INSERT INTO practice_insert (user_name, country)
	VALUES("two", "CHN"),
			("three", "USA"),
            ("four", "US"),
            ("five", "US");

CREATE TABLE practice2_insert(
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(30) NOT NULL,
    address VARCHAR(30) NOT NULL,
    city VARCHAR(10) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    country VARCHAR(10) NOT NULL
);
INSERT INTO practice2_insert (customer_name, address, city, postal_code,country)
	VALUES("Al Futter", "57 Obere St.", "Berlin", "12209", "Germany"),
			("Ana Trujillo", "2222 Avda Ave", "Tijuana", "0521", "Mexico"),
            ("Antonio Moreno", "2312 Matadros", "La Paz", "0523", "Mexico"),
            ("Thomas Hardy", "120 Hanover Sq.", "London", "WA1 1DP", "UK");

SELECT * FROM practice2_insert;

UPDATE practice_insert 
	SET country = "CAD"
	WHERE id = 7;

UPDATE practice_insert 
	SET country = "USA"
	WHERE country = "US";
    
UPDATE practice2_insert
	SET customer_name = "Alfred Schmidt", 
		city = "Frankfurt"
    WHERE customer_id = 1;
UPDATE practice2_insert
	SET postal_code = "000000"
    WHERE country = "Mexico";
    
UPDATE practice2_insert
	SET country = "United Kingdom"
    WHERE customer_id = 4;