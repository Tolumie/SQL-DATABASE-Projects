
/*Retrieve the names and job start dates of all employees who work for department number 5
Inner join */
SELECT E.F_NAME,E.L_NAME, JH.START_DATE 
FROM EMPLOYEES as E 
INNER JOIN JOB_HISTORY as JH 
ON E.EMP_ID=JH.EMPL_ID 
WHERE E.DEP_ID ='5';
# Alter table chicago_public_schools rename column NAME_OF_SCHOOL to school_name;

/*Retrieve employee ID, last name, department ID, and department name for all employees.
Left join */
SELECT E.EMP_ID, E.L_NAME, E.DEP_ID, D.DEP_NAME
FROM EMPLOYEES AS E 
LEFT OUTER JOIN DEPARTMENTS AS D 
ON E.DEP_ID=D.DEPT_ID_DEP;

/*Retrieve the First name, Last name, and Department name of all employees
Full/Union join
*/
SELECT E.F_NAME, E.L_NAME, D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
ON E.DEP_ID = D.DEPT_ID_DEP
UNION
SELECT E.F_NAME, E.L_NAME, D.DEP_NAME
FROM EMPLOYEES AS E
RIGHT OUTER JOIN DEPARTMENTS AS D
ON E.DEP_ID=D.DEPT_ID_DEP;

/*Retrieve the names, job start dates, and job titles of all employees,
 who work for department number 5.
*/
select E.F_NAME,E.L_NAME, JH.START_DATE, J.JOB_TITLE 
from EMPLOYEES as E 
INNER JOIN JOB_HISTORY as JH on E.EMP_ID=JH.EMPL_ID 
INNER JOIN JOBS as J on E.JOB_ID=J.JOB_IDENT
where E.DEP_ID ='5';

/*Retrieve the first name and last name of all employees but
 department ID and department names only for male employees
*/
SELECT E.F_NAME, E.L_NAME, D.DEPT_ID_DEP, D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
ON E.DEP_ID=D.DEPT_ID_DEP AND E.SEX = 'M'

UNION

SELECT E.F_NAME, E.L_NAME, D.DEPT_ID_DEP, D.DEP_NAME
from EMPLOYEES AS E
RIGHT OUTER JOIN DEPARTMENTS AS D
ON E.DEP_ID=D.DEPT_ID_DEP AND E.SEX = 'M';

/*Final Project_Advanced SQL Techniques
*/
/*Question 1
Write and execute a SQL query to list the school names, community names
 and average attendance for communities with a hardship index of 98.
 */
-- Find the column
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%hard%'
ORDER BY TABLE_NAME;

-- write cold
SELECT * FROM chicago.chicago_public_schools;
SELECT * FROM chicago.chicago_socioeconomic_data;









/*Final Project_Advanced SQL Techniques
*/
/*Question 1
Write and execute a SQL query to list the school names, community names
 and average attendance for communities with a hardship index of 98.
 */
select SC.NAME_OF_SCHOOL , COM.COMMUNITY_AREA_NAME, SC.AVERAGE_STUDENT_ATTENDANCE
from chicago_socioeconomic_data  com
left join chicago_public_schools  SC
on com.COMMUNITY_AREA_Number = sc.COMMUNITY_AREA_Number
where com.HARDSHIP_INDEX = 98;


