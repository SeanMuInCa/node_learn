CREATE TABLE employee (
	employee_id INT AUTO_INCREMENT ,
	first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    PRIMARY KEY (employee_id)
);

INSERT INTO employee(first_name, last_name, position)
	VALUES("Robert", "Minee", "sales rep");
INSERT INTO employee(first_name, last_name, position)
	VALUES("Rene", "Short", "manager");
    
    
CREATE TABLE sales (
	sale_id INT AUTO_INCREMENT ,
	employee_id INT NOT NULL,
    total DOUBLE NOT NULL,
    PRIMARY KEY (sale_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    CONSTRAINT CHK_total CHECK (total >= 0)
);

INSERT INTO sales(employee_id, total)
	VALUES(1, 23.50);
INSERT INTO sales(employee_id, total)
	VALUES(2, 13.05);
INSERT INTO sales(employee_id, total)
	VALUES(1, 12.25);
    
