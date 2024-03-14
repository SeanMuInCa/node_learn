select * from produce;

CREATE TABLE veg_type(
	veg_type_id INT AUTO_INCREMENT,
    veg_type_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (veg_type_id)
    );
    
ALTER TABLE produce ADD veg_type_id INT;

ALTER TABLE produce ADD FOREIGN KEY (veg_type_id) REFERENCES veg_type(veg_type_id);

DELIMITER $
CREATE PROCEDURE add_veg_type()
BEGIN
	#variable to hold information from row in the table
    DECLARE type_of_veg VARCHAR(50);
    #create a varible to track our loop
    DECLARE done INT DEFAULT FALSE;
    
    #create cursor
    DECLARE produce_cursor CURSOR FOR SELECT DISTINCT veg_type FROM produce;
    #handler for cursor, tracks if we finish our records
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    #open the cursor
    OPEN produce_cursor;
    # create a loop
    our_loop: LOOP 
		#add the cursor information into a variable
		FETCH produce_cursor INTO type_of_veg;
        #true condition, records done
        IF done THEN
			LEAVE our_loop;
		ELSE
			#add information to the table
			INSERT INTO veg_type(veg_type_name) VALUES(type_of_veg);
		END IF;
	END LOOP;
    
    #close cursor
    CLOSE produce_cursor;
END $
DELIMITER ;

CALL add_veg_type();

select * from veg_type;

select * from produce;

DELIMITER $
CREATE PROCEDURE add_veg_id()
BEGIN
	-- variable to hold our current veg type
    DECLARE current_veg_type VARCHAR(50);
    -- variable to hold the new id
    DECLARE vt_id INT;
    -- variable to hold the produce id so we can update the new id
    DECLARE p_id INT;
    
    -- check if the cursor is done
    DECLARE done INT DEFAULT FALSE;
    -- CURSOR
    DECLARE produce_cursor CURSOR FOR SELECT produce_id,veg_type FROM produce;
    -- handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    
    -- open cursor
    OPEN produce_cursor;
		-- while loop
		WHILE NOT done DO
			-- get a result from cursor
            FETCH produce_cursor INTO p_id, current_veg_type;
            -- get the id from type
            SELECT veg_type_id INTO vt_id FROM veg_type WHERE veg_type_name = current_veg_type;
            -- update the table
            UPDATE produce SET veg_type_id = vt_id WHERE produce_id = p_id;
        END WHILE;
    -- CLOSE CURSOR
    CLOSE produce_cursor;
END $
DELIMITER ;

CALL add_veg_id();

SELECT * FROM produce;