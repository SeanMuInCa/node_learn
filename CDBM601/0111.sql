CREATE TABLE IF NOT EXISTS customer(
	customer_id INT NOT NULL AUTO_INCREMENT,
    customer_name VARCHAR(50) NOT NULL,
    customer_address VARCHAR(100),
    customer_city VARCHAR(50) NOT NULL,
    customer_country VARCHAR(50) NOT NULL,
    PRIMARY KEY (customer_id)
);

CREATE TABLE customer_order(
	order_id INT NOT NULL AUTO_INCREMENT,
    # formate for dates YYYY-MM--DD
    order_date DATE NOT NULL,
    customer_id INT NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
);

CREATE TABLE product(
	product_id INT NOT NULL AUTO_INCREMENT,
    product_description VARCHAR(255),
    price FLOAT(2) DEFAULT 0.00,
    PRIMARY KEY (product_id)
);

CREATE TABLE sale (
	order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES customer_order (order_id),
    FOREIGN KEY (order_id) REFERENCES product (product_id)
);

CREATE TABLE sale2 (
	order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

SELECT * FROM information_schema.table_constraints
WHERE constraint_schema = 'cdbm601';


