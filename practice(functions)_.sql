select COUNT(emp_id) 
from employee;--to find no. of employees
select COUNT(emp_id) 
from employee
where sex='F' and birth_day>'1971-01-01'; --no. of female emp born after 1970
select AVG(salary)
from employee
where sex='m';  --avg of all men employee salary
select SUM(salary)
from employee; --sum of all salary
 select count(sex)
 from employee; -- this is only counting of entries or how many employees have entry in sex column
  select count(sex),sex
  from employee
  group by sex; --how many female and male employee
  --this called aggregation , meaning of aggregate is "a whole formed by combining several separate elements."
select sum(total_sales),emp_id
from works_with
group by emp_id; --how much each employee has sold the product
select sum(total_sales),client_id
from works_with
group by client_id; --how much each client  has taken the product
--EXTRA
--FIND ANT CLIENT WHO ARE AN LLC
SELECT * 
FROM CLIENT
WHERE CLIENT_NAME LIKE '%LLC';          -- %LLC here % defines any number of character and then name should end with LLC
  --FIND ANT branch_suppliers WHO ARE in labeL BUSSINESS 
SELECT * 
FROM branch_supplier
WHERE supplier_name LIKE '% LABEL%';    -- %LLC here % defines any number of character and then name should end with LLC
--FIND ANY EMPLOYEE BORN IN OCTOBER 
SELECT *
FROM EMPLOYEE
WHERE BIRTH_DAY LIKE '____-10%'; --HERE '_' REPRESENTS ANY RANDOM CHARACTER
--FIND THE CLIENT WHICH ARE SCHOOLS
SELECT *
FROM CLIENT
WHERE CLIENT_NAME LIKE '%SCHOOL%';
--union 
select first_name
from employee
union
select branch_name
from branch;  --to use union we have select same no. of attribute at both side 
--list of all clients and branch suppliers name
select client_name,client.branch_id
from client
union
select supplier_name,branch_supplier.branch_id
from branch_supplier;
--find money earned and spent by company
select salary 
from employee
union 
select total_sales
from works_with;
--thus union in short combines attributes and same no. of attributes 
--joins
--joins are used to combine rows from different 2 or more  attributes

-- Add the extra branch
INSERT INTO branch VALUES(4, "Buffalo", NULL, NULL);

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch              -- SIMPLE JOIN
ON employee.emp_id = branch.mgr_id; --theseline shows if empid=mgrid then only both table's row are gonna be joined ,at which specific column, into a single table
--when we use simple join its called inner join
--when we used inner join we just got diplayed the rows which had empid=mgrid 
--when we use left join all the employees got included  THUS in left join we include all the table"s row fromleft table but only the matched items are going to display of branch table which is right table 
--hence here table which is having from statement is left table 
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch    -- LEFT JOIN
ON employee.emp_id = branch.mgr_id; --it will include all the rows of  branch table 
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch    -- RIGHT JOIN
ON employee.emp_id = branch.mgr_id;
--thus in left join we get all rows from left join 
--in right join we get all the rows from right table
--a FULL OUTER JOIN is equal to left join plus right join no matter if they meet the conditions (here for instance condition is empid=mgrid )
--example of SIMPLE QUERIES
SELECT works_with.emp_id
FROM works_with
WHERE works_with.total_sales > 50000; --THESE QUERY WILL GIVE EMPID WHO SOLD ITEM WORTH MORE THAN 50,000
--example of NESTED QUERIES
-- Find names of all employees who have sold over or more than  50,000 
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (SELECT works_with.emp_id
FROM works_with
WHERE works_with.total_sales > 50000);  --NOT ONLY THESE QUERY WILL GIVE EMPID  OF PERSON WHO HAS SOLD ITEM MORE THAN 50,000...
---BUT IT WILL TELL ITS FIRST NAME AND LAST NAME OF THAN EMPID
--HENCE 'IN' KEYWORD IS USED FOR NESTED QUERY

-- Find all clients who are handles by the branch that Michael Scott manages
-- Assume you know Michael's ID
SELECT client.client_id, client.client_name
FROM client
WHERE client.branch_id = (SELECT branch.branch_id
                          FROM branch--THIS QUERY WILL GIVE BRANCHID , IT WILL BE EXECUTED FIRST 
                          WHERE branch.mgr_id = 102
                          LIMIT 1 --IT WILL MAKE SURE THAT ONLY ONE VALVE CAN BE GIVEN TO FINAL QUERY
                          );  
--FROM BRANCH ID FINALLY THEY WILL SELECT CLIENT NAME 

 -- Find all clients who are handles by the branch that Michael Scott manages
 -- Assume you DONT'T know Michael's ID
 SELECT client.client_id, client.client_name
 FROM client
 WHERE client.branch_id = (SELECT branch.branch_id
                           FROM branch
                           WHERE branch.mgr_id = (SELECT employee.emp_id
                                                  FROM employee
                                                  WHERE employee.first_name = 'Michael' AND employee.last_name ='Scott'
                                                  LIMIT 1 ));
-- Find the names of employees who work with clients handled by the scranton branch
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
                         SELECT works_with.emp_id
                         FROM works_with
                         )
AND employee.branch_id = 2;
-- Find the names of all clients who have spent more than 100,000 dollars
SELECT client.client_name
FROM client
WHERE client.client_id IN (
                          SELECT client_id
                          FROM (
                                SELECT SUM(works_with.total_sales) AS totals, client_id
                                FROM works_with
                                GROUP BY client_id) AS total_client_sales
                          WHERE totals > 100000
);
--DIFFERENT TABLES ARE CONNECTED THROUGH CONSTRAINTS WITH HELP OF FORIEGN KEYS ETS ; SO TO DELETE THE MAIN ENTITY ALONG WITH ITS EXISTENCE IN THE 'REFERENCED' TABLE ON DELETE CASCADE AND ON DELETE SET NULL
--ON DELETE SET NULL IS USED WHEN AN ENTITY IS DELETED ON MAIN TABLE ITS REFERENCES WHERE SET NULL ON ITS REFERENCED TABLE
-- EXAMPLE OF  ON DELETE SET NULL
CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL 
   );    
   --HERE IF EMPID IN EMPLOYEE TABLE GETS DELETED THAN SET MDRID IN BRANCH TABLE AS NULL
   DELETE FROM EMPLOYEE
   WHERE EMP_ID=102;
   SELECT * FROM BRANCH;
      SELECT * FROM client;
 SELECT * FROM EMPLOYEE;
--ON DELETE CASCADE 
CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);--HERE IF 
DELETE FROM BRANCH 
WHERE BRANCH_ID=2;
--HERE IF WE WILL DELETE BRANCHID 2ND , AS IT IS PRIMARY KEY IN BRANCH-SUPPLIER THROUGH REFERNCE ,
-- ON DELETION FROM MAIN TABLE ITS REFERENCED ROWS ON REFERENCE TAB;E (HERE BRANCH SUPPLIER )WILL GET DELETED
--IT IS DONE BCOZ A PRIMARY CANT BE NULL , IT GIVES IMPORTANCE OF DELETE CASCADE AS ON DELETE SET NULL FAILS HERE   
SELECT * FROM BRANCH_SUPPLIER;
