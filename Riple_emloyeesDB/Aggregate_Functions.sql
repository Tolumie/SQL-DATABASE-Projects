select l_name FROM employees where l_name like 'A%';
# values from 300 to 400
SELECT  JOB_ID FROM employees where JOB_ID >= 300 and JOB_ID <= 500;

# use range 'between and'
SELECT  JOB_ID FROM employees where JOB_ID between 300 and 500;

# use ' WHERE IN' instead of 'WHERE AND'
SELECT  F_NAME, JOB_ID FROM employees where  F_NAME ='alice'or F_NAME = ('mary');

SeleCT  F_NAME, JOB_ID FROM employees where  F_NAME in ('alice','john','mary');

# SORTING :
# order by : descending , ascending is default

SELECT  F_NAME, JOB_ID,address,sex FROM employees order by 4;
#or
SELECT  F_NAME, JOB_ID,address,sex, MANAGER_ID FROM employees order by MANAGER_ID desc;

# group by a column(sex) and its count(sum)
select sex, count(sex) as total_Sex from employees group by sex;

# retrieve the number of employees in the department
SELECT DEP_ID, COUNT(*)
FROM EMPLOYEES
GROUP BY DEP_ID;
# retrieve the number of employees in the department and the average employee salary in the department. 
SELECT DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", AVG(SALARY) AS "AVG_SALARY"
FROM EMPLOYEES
GROUP BY DEP_ID;

# retrieve a list of employees ordered by department ID.
SELECT F_NAME, L_NAME, DEP_ID 
FROM EMPLOYEES
ORDER BY DEP_ID;


/*combine the usage of GROUP BY and ORDER BY statements to sort the output
 of each group in accordance with a specific parameter. 
 It is important to note that in such a case, 
 ORDER BY clause muct be used after the GROUP BY clause*/
 
 SELECT DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", AVG(SALARY) AS "AVG_SALARY"
FROM EMPLOYEES
GROUP BY DEP_ID
ORDER BY AVG_SALARY;

# Filtering a grouped response using the HAVING CLAUSE
# To  limit the result  of the previous query to departments with fewer than 4 employees
SELECT DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", AVG(SALARY) AS "AVG_SALARY"
FROM EMPLOYEES
GROUP BY DEP_ID
HAVING count(*) < 4
ORDER BY AVG_SALARY;

# practice questions
/*1. Retrieve the list of all employees, first and last names,
 whose first names start with ‘S’.*/
 SELECT F_NAME, L_NAME
FROM EMPLOYEES
WHERE F_NAME LIKE 'S%';

/* 2. Arrange all the records of the EMPLOYEES table in ascending order of the date of birth.
*/
SELECT *
FROM EMPLOYEES
ORDER BY B_DATE;
/* 3.Group the records in terms of the department 
IDs and filter them of ones that have average salary 
more than or equal to 60000. Display 
the department ID and the average salary.*/
 SELECT DEP_ID, round(AVG(SALARY),2) as AVG_SALARY
FROM EMPLOYEES
GROUP BY DEP_ID
HAVING AVG(SALARY) >= 60000;
 
/* 4. For the problem above, sort the results for each group
 in descending order of average salary.*/
 
 SELECT DEP_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY DEP_ID
HAVING AVG(SALARY) >= 60000
ORDER BY AVG(SALARY) DESC;

# ELIMINATING DUPLICATES USING DISTINCT
SELECT country FROM customers ORDER BY 1;

SELECT  DISTINCT (country) FROM customers ORDER BY 1 DESC;

# DROUP BY : SUM OF COUNTRIES
SELECT  country, count(country) as count FROM customers group BY country;

# question Exercise on SORTING
/* 5. Retrieve a list of employees ordered in descending order by 
department ID and within each department ordered alphabetically
 in descending order by last name.*/
SELECT F_NAME, L_NAME, DEP_ID 
FROM EMPLOYEES
ORDER BY DEP_ID DESC, L_NAME DESC;

/* 6. Retrieve a list of employees ordered in descending order by 
department ID and within each department ordered alphabetically
 in descending order by last name.
 /*In the SQL Query above, D and E are aliases for the table names.
 Once you define an alias like D in your query, 
 you can simply write D.COLUMN_NAME rather than 
 the full form DEPARTMENTS.COLUMN_NAME.
 */
 SELECT D.DEP_NAME , E.F_NAME, E.L_NAME
FROM EMPLOYEES as E, DEPARTMENTS as D
WHERE E.DEP_ID = D.DEPT_ID_DEP
ORDER BY D.DEP_NAME, E.L_NAME DESC;

# Grouping EXERCISE
/* 1. For each department ID retrieve the number
 of employees in the department.
*/
SELECT DEP_ID, COUNT(*)
FROM EMPLOYEES
GROUP BY DEP_ID;

/* 2.For each department retrieve the number of employees in the department,
 and the average employee salary in the department..
 */
SELECT DEP_ID, COUNT(*), AVG(SALARY)
FROM EMPLOYEES
GROUP BY DEP_ID;

/* 3. Label the computed columns in the result set of 
SQL problem 2 (Exercise 3 Problem 2) as 
NUM_EMPLOYEES and AVG_SALARY.
*/
SELECT DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", ROUND(AVG(SALARY),2) AS "AVG_SALARY"
FROM EMPLOYEES
GROUP BY DEP_ID;

/* 4. In SQL problem 3 (Exercise 3 Problem 3), 
order the result set by Average Salary..
*/
SELECT DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", AVG(SALARY) AS "AVG_SALARY"
FROM EMPLOYEES
GROUP BY DEP_ID
ORDER BY AVG_SALARY;

/* 5. In SQL problem 4 (Exercise 3 Problem 4),
 limit the result to departments with fewer than 4 employees.
*/
SELECT DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", ROUND(AVG(SALARY),2) AS "AVG_SALARY"
FROM EMPLOYEES
GROUP BY DEP_ID
HAVING count(*) < 4
ORDER BY AVG_SALARY ;

 
# HAVING CLAUSE
# restricting the result set - having clause, -- check if more than 10 customers from same country 
# set a condition to the group by clause using HAVING
-- having clause only works with the group by clause
select country, count(country) as count from customers  group by 1 having count > 10;

### String Patterns
### Say you need to retrieve the first names F_NAME and last names L_NAME of all employees who live in Elgin, IL.
# You can use the LIKE operator to retrieve strings that contain the said text.

SELECT F_NAME, L_NAME
FROM EMPLOYEES
WHERE ADDRESS LIKE '%Elgin,IL%';

select lastname, firstname from employees where reportsTo like '%1002%';

# The employees who were born during the 70s
SELECT F_NAME, L_NAME, B_DATE
FROM EMPLOYEES
WHERE B_DATE LIKE '197%';

# retrieve all employee records in department 5 where salary is between 60000 and 70000
SELECT *
FROM EMPLOYEES
WHERE (SALARY BETWEEN 60000 AND 70000) AND DEP_ID = 5;

# AGGGREGATE FUNCTIONS

/*
Query A1: Enter a function that calculates the total cost of all animal 
rescues in the PETRESCUE table.
*/
select SUM(COST) from PETRESCUE;

/*Query A2: Enter a function that displays the total cost of 
all animal rescues in the PETRESCUE table in a column called SUM_OF_COST.
*/
select SUM(COST) AS SUM_OF_COST from PETRESCUE;

/* Query A3: Enter a function that displays the maximum quantity of animals rescued.
*/
select MAX(QUANTITY) from PETRESCUE;

/*Query A4: Enter a function that displays the average cost of animals rescued.
*/
select AVG(COST) from PETRESCUE;

/*Query A5: Enter a function that displays the average cost of rescuing a dog.
*/
select  ROUND(AVG(COST/QUANTITY),2) 
AS AVG_COST_OF_RESCUE_DOG from PETRESCUE where ANIMAL = 'DOG';


# EXERCISE 3: Scalar and String Functions

/* Query B1: Enter a function that displays the rounded cost of each rescue.
*/
select Animal, round(sum(cost),2) as Cost_rescue from petrescue group by Animal;
/* Query B2: Enter a function that displays the length of each animal name.
*/
select LENGTH(ANIMAL) LEN_ANIMAL from PETRESCUE;

/* Query B3: Enter a function that displays the animal name in each rescue in uppercase.
*/
select UCASE(ANIMAL) from PETRESCUE;

/*Query B4: Enter a function that displays the animal name in each rescue in uppercase without duplications.
*/
select DISTINCT(UCASE(ANIMAL)) as Animal_upper from PETRESCUE;

/* Query B5: Enter a query that displays all the columns from the PETRESCUE table, where the animal(s) rescued are cats. Use cat in lower case in the query.
*/
select * from PETRESCUE where LCASE(ANIMAL) = 'cat';

# Exercise 4: Date and Time Functions
/*Query C1: Enter a function that displays the day of the month when cats have been rescued.
 */
 select DAY(RESCUEDATE) from PETRESCUE where ANIMAL = 'Cat';

/*Query C2: Enter a function that displays the number of rescues on the 5th month.
 */
 select SUM(QUANTITY) as No_of_Resc_month_5th from PETRESCUE where MONTH(RESCUEDATE)='05';
 
/*Query C3: Enter a function that displays the number of rescues on the 14th day of the month.
 */
 select SUM(QUANTITY) from PETRESCUE where DAY(RESCUEDATE)='14';

/* Query C4: Animals rescued should see the vet within three days of arrivals.
Enter a function that displays the third day from each rescue.
*/
select ANIMAL, RESCUEDATE, date_add(RESCUEDATE, interval 3 DAY)
 AS 3_DAYS_AFTER_RESCUE,
day(date_add(RESCUEDATE, interval 3 DAY)) AS DAY_OF_THE_MONTH_FOR_VET
 from PETRESCUE order by animal;
# select extract(day from date_Add(RESCUEDATE, interval 3 DAY)) from PETRESCUE;


/*Query C5: Enter a function that displays the length of time
 the animals have been rescued;
 the difference between todays date and the rescue date.
 */

# 
 select date_format(from_Days(datediff(now(),RESCUEDATE)),
'%')  as Age from PETRESCUE;

SELECT year(FROM_DAYS(DATEDIFF(CURRENT_DATE,RESCUEDATE))) 
    FROM PETRESCUE; 
    
SELECT EMPL_ID, YEAR(FROM_DAYS(DATEDIFF(CURRENT_DATE, RESCUEDATE	)))
   

# Sub-queries and Nested Selects

/* Say you are asked to retrieve all employee records whose
 salary is lower than the average salary.
 You might use the following query to do this. 
*/

SELECT * 
FROM EMPLOYEES 
WHERE salary < AVG(salary);

/* However, this query will generate an error stating, 
"Illegal use of group function." Here, the group function
 is AVG and cannot be used directly in the condition since
 it has not been retrieved from the data. Therefore, the condition
 will use a sub-query to retrieve the average salary information 
 to compare the existing salary. The modified query would become: */

SELECT *
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES);

# sub queries as part of the from clause is called 'derived tables or table expressions'

/*Now, consider executing a query that retrieves all employee records
 with EMP_ID, SALARY, and maximum salary as MAX_SALARY in every row.
 For this, the maximum salary must be queried and used as one of the columns.
 This can be done using the query below.
*/
SELECT EMP_ID, SALARY, (SELECT MAX(SALARY) FROM EMPLOYEES) AS MAX_SALARY 
FROM EMPLOYEES;

/*Now, consider that you wish to extract the first and last names
 of the oldest employee. Since the oldest employee will be the one
 with the smallest date of birth, the query can be written as:
*/
SELECT F_NAME, L_NAME
FROM EMPLOYEES
WHERE B_DATE = (SELECT MIN(B_DATE) FROM EMPLOYEES);

# create new column  AGE from B_DATE and add the  result as values
select date_format(from_Days(datediff(now(),B_DATE)),
'%Y') + 0 as Age from employees;
alter table employees add AGE INT;
update employees set AGE = 
date_format(from_Days(datediff(now(),B_DATE)),'%Y') + 0;
#ALTER TABLE EMPLOYEES DROP COLUMN AGE;

/*
You may also use sub-queries to create derived tables.
The average salary of the top 5 earners in the company.*/

SELECT AVG(SALARY) 
FROM (SELECT SALARY 
      FROM EMPLOYEES 
      ORDER BY SALARY DESC 
      LIMIT 5) AS SALARY_TABLE;
    
    # EMPLOYEES WITH SALARY ABOVE AVERAGE SALARY
      select * from employees where salary>(select avg(salary)
      from employees order by salary);
      
/*Write a query to find the average salary of the five least-earning employees.
*/
SELECT AVG(SALARY) 
FROM (SELECT SALARY 
      FROM EMPLOYEES 
      ORDER BY SALARY 
      LIMIT 5) AS SALARY_TABLE;
      
/* EMPLOYEES WITH SALARY BELOW AVERAGE SALARY
*/
 select * from employees where salary<(select avg(salary)
      from employees order by salary);
/*Write a query to find the records of employees older than
 the average age of all employees.
*/
SELECT * 
FROM EMPLOYEES 
WHERE YEAR(FROM_DAYS(DATEDIFF(CURRENT_DATE,B_DATE))) > 
    (SELECT AVG(YEAR(FROM_DAYS(DATEDIFF(CURRENT_DATE,B_DATE)))) 
    FROM Employees);
/*
From the Job_History table, display the list of Employee IDs,
 years of service, and average years of service for all entries.
*/
SELECT EMPL_ID, YEAR(FROM_DAYS(DATEDIFF(CURRENT_DATE, START_DATE))) as YR_OF_SERVICE, 
    (SELECT AVG(YEAR(FROM_DAYS(DATEDIFF(CURRENT_DATE, START_DATE)))) 
    FROM JOB_HISTORY) AS AVG_YR_OF_SERVICE
FROM JOB_HISTORY;

/* WAY TO ACCESSING MULTIPLE TABLES
1. SUB_QUERIES
2. IMPLICIT JOIN
3. JOIN OPERATORS (INNER, OUTER, FULL(CARTESIAN), LEFT,RIGHT,UNITY ETC
 
1. SUB_QUERIES
*/# SELECT TWO TABLES
SELECT * FROM employees, departments;

/*2. Retrieve only the EMPLOYEES records corresponding to jobs in the JOBS table.
*/SELECT * FROM EMPLOYEES WHERE JOB_ID IN (SELECT JOB_IDENT FROM JOBS);

/*3. Retrieve JOB information for employees earning over $70,000.
*/ SELECT JOB_TITLE, MIN_SALARY, MAX_SALARY, JOB_IDENT
FROM JOBS
WHERE JOB_IDENT IN (select JOB_ID from EMPLOYEES where SALARY > 70000 );

/* #Accessing multiple tables with Implicit Joins
# Retrieve only the EMPLOYEES records corresponding to jobs in the JOBS table.
*/
SELECT *
FROM EMPLOYEES, JOBS
WHERE EMPLOYEES.JOB_ID = JOBS.JOB_IDENT;

/*Redo the previous query using shorter aliases for table names.
*/
SELECT *
FROM EMPLOYEES E, JOBS J
WHERE E.JOB_ID = J.JOB_IDENT;

/*In the previous query, retrieve only the Employee ID, Name, and Job Title.
*/
SELECT EMP_ID,F_NAME,L_NAME, JOB_TITLE
FROM EMPLOYEES E, JOBS J
WHERE E.JOB_ID = J.JOB_IDENT;

/*.The column names can also be prefixed with table aliases 
to keep track of where each column is coming from.
The above query will be modified as shown below.

Redo the previous query, but specify the fully qualified column names 
with aliases in the SELECT clause*/
SELECT E.EMP_ID, E.F_NAME, E.L_NAME, J.JOB_TITLE
FROM EMPLOYEES E, JOBS J
WHERE E.JOB_ID = J.JOB_IDENT;

/*Retrieve only the list of employees whose JOB_TITLE is Jr. Designer.
a. Using sub-queries
*/ 
SELECT *
FROM EMPLOYEES
WHERE JOB_ID IN (SELECT JOB_IDENT
                 FROM JOBS
                 WHERE JOB_TITLE= 'Jr. Designer');

/* b. Using Implicit Joins
*/ 
SELECT *
FROM EMPLOYEES E, JOBS J
WHERE E.JOB_ID = J.JOB_IDENT AND J.JOB_TITLE= 'Jr. Designer';

/* Retrieve JOB information and a list of employees whose birth year is after 1976.
*/ # a. Using sub-queries
SELECT JOB_TITLE, MIN_SALARY, MAX_SALARY, JOB_IDENT
FROM JOBS
WHERE JOB_IDENT IN (SELECT JOB_ID
FROM EMPLOYEES WHERE YEAR(B_DATE)>1976 );

/*b. Using implicit join
*/
SELECT J.JOB_TITLE, J.MIN_SALARY, J.MAX_SALARY, J.JOB_IDENT, E.B_DATE, E.AGE
FROM JOBS J, EMPLOYEES E
WHERE E.JOB_ID = J.JOB_IDENT AND YEAR(E.B_DATE)>1976;
/*
# ASSIGNMENT */
SELECT E.F_NAME, D.DEP_NAME FROM EMPLOYEES E, DEPARTMENTS D WHERE
 E.DEP_ID = D.DEPT_ID_DEP;



SELECT date_format(FROM_DAYS(DATEDIFF(CURRENT_DATE, B_DATE)),'%YYY,MM,DD') +0 FROM Employees;
select date_format(from_Days(datediff(now(),B_DATE)),
'%Y') + 0 as Age from employees;

