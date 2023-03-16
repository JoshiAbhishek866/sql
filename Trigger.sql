-   TRIGGER 
-- A TRIGGER IS BLOCK OF SQL CODE WHICH WILL TAKE CERTAIN ACTIONS THAT SHOULD HAPPEN WHEN A CERTAIN OPERATIONS GET PERFORMED IN DATABASE
-- CREATE
--     TRIGGER `event_name` BEFORE/AFTER INSERT/UPDATE/DELETE
--     ON `database`.`table`
--     FOR EACH ROW BEGIN
-- 		-- trigger body
-- 		-- this code is applied to every
-- 		-- inserted/updated/deleted row
--     END;
CREATE TABLE trigger_test (
     message VARCHAR(100)
);


--USE MYSQL COMMANDLINE CLIENT
DELIMITER $$
    CREATE  TRIGGER  my_trigger  BEFORE  INSERT  ON  employee FOR EACH ROW BEGIN INSERT INTO trigger_test VALUES('added new employee');  END$$
DELIMITER ;
INSERT INTO employee
VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);
--before anything insert into employee, the sql command  or table valve "added new employee" is added into trigger_test table
select * from trigger_test ;
DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES(NEW.first_name);
    END$$
DELIMITER ;
--above query tells that before something gets inserted into employee 
--here new is going to refer to the row it is getting inserted and we can specific columns from that row 
INSERT INTO employee
VALUES(110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);

DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT -- we can also use AFTER DELETE 
    ON employee
    FOR EACH ROW BEGIN
         IF NEW.sex = 'M' THEN
               INSERT INTO trigger_test VALUES('added male employee');
         ELSEIF NEW.sex = 'F' THEN
               INSERT INTO trigger_test VALUES('added female');
         ELSE
               INSERT INTO trigger_test VALUES('added other employee');
         END IF;
    END$$
DELIMITER ;
INSERT INTO employee
VALUES(111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);

DROP TRIGGER my_trigger;
