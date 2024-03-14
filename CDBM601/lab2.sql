#1. Create a procedure that shows the overall grade of a student that is #passed through to the procedure as a parameter. The graded items are #weighed, meaning that some items are worth more of the final grade than #others. You will need to multiple the grade of an item by the weight
#of the item and then sum all the items to get the student’s final grade.

DELIMITER $
CREATE PROCEDURE get_score(IN student_name VARCHAR(255))
BEGIN
	SELECT student, ROUND(SUM(mark * weight),2) AS "final score"
	FROM student_mark 
	WHERE student = student_name
	GROUP BY student;
END $
DELIMITER ;

CALL get_score('Yarona');

#2. Create a view that shows all the students’ overall grades.

CREATE VIEW overall_scores AS
SELECT student,
			 ROUND(SUM(mark * weight),2) AS "final score"
FROM student_mark 
GROUP BY student

SELECT * FROM overall_scores;

#3. Join the view created above to the student_mark table so the resulting 
#query shows the students name, the assignment, their mark on the #assignment, and their final grade.

SELECT  s.student,s.assignment,s.mark, o.`final score`
FROM overall_scores AS o
JOIN student_mark AS s
ON o.student = s.student



#this was i thought the answer should look like, so i keep it for fun, took me three hours to do it.

SELECT 
    s1.student,
    ROUND(s1.mark * s1.weight,2) AS assignment1_mark,
    ROUND(s2.mark * s2.weight,2) AS assignment2_mark,
    ROUND(s3.mark * s3.weight,2) AS midterm_mark,
    ROUND(s4.mark * s4.weight,2) AS final_mark,
    ROUND(s5.mark * s5.weight ,2) AS lab_mark,
		o.`final score`
FROM student_mark AS s1
JOIN student_mark AS s2 ON s1.student = s2.student AND s2.assignment = 'Assignment 2'
JOIN student_mark AS s3 ON s1.student = s3.student AND s3.assignment = 'Midterm'
JOIN student_mark AS s4 ON s1.student = s4.student AND s4.assignment = 'Final'
JOIN student_mark AS s5 ON s1.student = s5.student AND s5.assignment = 'Lab'
JOIN overall_scores AS o ON s1.student = o.student
WHERE s1.assignment = 'Assignment 1';


#4. The current table is not normalized and the structure limits what we 
#can do. For example, it would be difficult to create a report with all 
#the student information on one line. Begin the process of normalizing 
#this table by creating a student table that assigns ids to the students.
#Then create a procedure that adds the students in the student_mark table 
#to the student table.

#create a table for students
CREATE TABLE students(
		student_id INT AUTO_INCREMENT,
    student_name VARCHAR(255) NOT NULL,
    PRIMARY KEY(student_id)
);

#add the student_id to table student_mark, and link to new table
ALTER TABLE student_mark ADD student_id INT;
ALTER TABLE student_mark ADD FOREIGN KEY(student_id) REFERENCES students(student_id);

#fill the students table with name
DROP PROCEDURE IF EXISTS add_student;
DELIMITER $
CREATE PROCEDURE add_student()
BEGIN
 -- variable to hold student
 DECLARE student_name VARCHAR(255); 

 -- variable to track loop is done
 DECLARE done INT DEFAULT FALSE;
 
 -- create cursor
 DECLARE student_cursor CURSOR FOR 
	SELECT DISTINCT student FROM student_mark;
 
 -- handler for cursor. tracks if records finished
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 
 -- open the cursor
 OPEN student_cursor;
 
 -- create loop
 our_loop: LOOP
 
	 -- add the cursor info into A VARIABLE
	 FETCH student_cursor INTO student_name;
     
     -- true condition, records done
     IF done THEN 
		LEAVE our_loop;
	ELSE 
		-- add info to table
		INSERT INTO students(student_name) VALUES (student_name); 
        END IF;
	-- end loop
	END LOOP;
    
    -- close the cursor
    CLOSE student_cursor;
END $
DELIMITER ;

CALL add_student();


#fill the student_id in the student_mark table
DELIMITER $
CREATE PROCEDURE add_student_id()
BEGIN
		-- variable to hold our current student name
    DECLARE current_student_name VARCHAR(255);
    -- variable to hold the new id
    DECLARE s_id INT;
    -- variable to hold the student name so we can update the new id
    DECLARE s_name VARCHAR(255);
    
    -- check if the cursor is done
    DECLARE done INT DEFAULT FALSE;
    -- CURSOR
    DECLARE student_cursor CURSOR FOR SELECT student FROM student_mark;
    -- handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    
    -- open cursor
    OPEN student_cursor;
		-- while loop
		WHILE NOT done DO
			-- get a result from cursor
            FETCH student_cursor INTO current_student_name;
            -- get the id from type
            SELECT student_id INTO s_id FROM students WHERE student_name = current_student_name;
            -- update the table
            UPDATE student_mark SET student_id = s_id WHERE current_student_name = student;
        END WHILE;
    -- CLOSE CURSOR
    CLOSE student_cursor;
END $
DELIMITER ;

CALL add_student_id()

