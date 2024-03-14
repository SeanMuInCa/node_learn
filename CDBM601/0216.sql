CREATE TABLE produce (
	produce_id INT AUTO_INCREMENT,
    -- would really be a foreign key
    veg_type VARCHAR(50) NOT NULL,
    variety VARCHAR(50) NOT NULL,
    sow_date DATE NOT NULL,
    grow_days INT NOT NULL,
    lot_number VARCHAR(50) NOT NULL,
    -- could calculate harvest date
    PRIMARY KEY(produce_id)
);

INSERT INTO produce (veg_type, variety, sow_date, grow_days, lot_number)
	VALUES ('Beans', 'Fandango', '2023-05-28', 55, 'lotc1992');
INSERT INTO produce (veg_type, variety, sow_date, grow_days, lot_number)
	VALUES ('Carrot', 'Autum King', '2023-05-28', 70, 'lotc1993');
INSERT INTO produce (veg_type, variety, sow_date, grow_days, lot_number)
	VALUES ('Onion', 'Nebula', '2023-05-28', 175, 'lotc1994');
INSERT INTO produce (veg_type, variety, sow_date, grow_days, lot_number)
	VALUES ('Kale', 'Squire', '2023-05-28', 60, 'lotc1995');
INSERT INTO produce (veg_type, variety, sow_date, grow_days, lot_number)
	VALUES ('Potato', 'Yukon Gem', '2023-05-28', 112, 'lotc1996');

select * from produce;
ALTER TABLE produce ADD COLUMN (harvest_date DATE, harvest_time VARCHAR(20));

DELIMITER $
CREATE TRIGGER my_trigger
	-- before for update
    BEFORE UPDATE ON produce FOR EACH ROW
    SET NEW.harvest_time = "test" $
DELIMITER ;

UPDATE produce SET harvest_date = "2024-02-16" WHERE produce_id = 1;

/*DELIMITER $
CREATE TRIGGER my_trigger
	-- let's do after, there is a error
    AFTER UPDATE ON produce FOR EACH ROW
    SET NEW.harvest_time = "test"$ 
DELIMITER ;
*/

DELIMITER $
CREATE TRIGGER my_trigger2
    BEFORE UPDATE ON produce FOR EACH ROW
BEGIN
	DECLARE harvest_timing VARCHAR(20);
    
    IF NEW.harvest_date > DATE_ADD(OLD.sow_date, INTERVAL OLD.grow_days DAY)
		THEN SET harvest_timing = "LATE";
	ELSEIF NEW.harvest_date < DATE_ADD(OLD.sow_date, INTERVAL OLD.grow_days DAY)
		THEN SET harvest_timing = "EARLY";
	ELSE 
		SET harvest_timing = "ON TIME";
	END IF;
    
    SET NEW.harvest_time = harvest_timing;
END $
DELIMITER ;


select * from produce;
UPDATE produce SET harvest_date = "2023-7-22" WHERE produce_id = 1;

CREATE TABLE produce_count (
	produce_id INT AUTO_INCREMENT,
	produce_name VARCHAR(20) NOT NULL,
    count INT,
    PRIMARY KEY (produce_id)
);

DELIMITER $
CREATE PROCEDURE add_produce_name()
BEGIN
	#variable to hold information from row in the table
    DECLARE name_of_produce VARCHAR(20);
    DECLARE p_count INT;
    #create a varible to track our loop
    DECLARE done INT DEFAULT FALSE;
    
    #create cursor
    DECLARE produce_cursor CURSOR FOR SELECT DISTINCT veg_type,COUNT(*) FROM produce GROUP BY veg_type;
    #handler for cursor, tracks if we finish our records
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    #open the cursor
    OPEN produce_cursor;
    # create a loop
    our_loop: LOOP 
		#add the cursor information into a variable
		FETCH produce_cursor INTO name_of_produce,p_count;
        #true condition, records done
        IF done THEN
			LEAVE our_loop;
		ELSE
			#add information to the table
			INSERT INTO produce_count(produce_name,count) VALUES(name_of_produce,p_count);
		END IF;
	END LOOP;
    
    #close cursor
    CLOSE produce_cursor;
END $
DELIMITER ;

CALL add_produce_name();

select * from produce_count;

DROP TRIGGER IF EXISTS update_count
DELIMITER $
CREATE TRIGGER update_count
	-- after this time for insert
    BEFORE INSERT ON produce FOR EACH ROW
BEGIN
	DECLARE p_count INT;
    SELECT COUNT(*) INTO p_count FROM produce GROUP BY veg_type HAVING veg_type = NEW.veg_type;
    
    IF p_count > 1 THEN
		UPDATE produce_count SET count = p_count WHERE produce_name = NEW.veg_type;
    ELSE
		INSERT INTO produce_count(produce_name, count) VALUES (NEW.veg_type, 1);
	END IF;
END $
DELIMITER ;

INSERT INTO produce (veg_type, variety, sow_date, grow_days, lot_number)
	VALUES ('Beans', 'Fandango', '2023-05-28', 55, 'lotc1992');
    
