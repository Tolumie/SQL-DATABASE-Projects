/*Goals:
1. Data Integrity & Relationships: Ensuring the correctness of data
 with foreign/primary key relationships, and ACID properties for CRUD operations.
2. Performance Optimization: Focus on indexing, efficient querying, and optimal
 database design for large datasets related to crime, schools, and communities.
3. Data Analysis & Reporting: Using complex queries, CTEs, window functions,
 and aggregation to analyze crime rates, school performance, and socio-economic conditions.
4. Automation & Triggers: Automating specific processes with stored procedures
 and triggers to handle events like crime updates or changes in school performance.
5. User-friendly Data Access: Creating views and handling transactions 
with proper error handling to ensure smooth interactions and access to relevant data.
*/

-- 1. Simple Queries (Basic Retrieval)
-- Retrieve all the community areas
SELECT * FROM chicago_socioeconomic_data;

-- Get schools located in a specific community area
SELECT NAME_OF_SCHOOL, STREET_ADDRESS, CITY FROM chicago_public_schools WHERE COMMUNITY_AREA_NUMBER = '01';

-- Get crimes reported in a specific year
SELECT CASE_NUMBER, PRIMARY_TYPE, DATE, LOCATION FROM chicago_crime WHERE YEAR = 2023;

--  2. CRUD Operations (Create, Read, Update, Delete)
-- Create a new school record
INSERT INTO chicago_public_schools (NAME_OF_SCHOOL, STREET_ADDRESS, CITY, STATE, ZIP_Code, COMMUNITY_AREA_NUMBER)
VALUES ('New School', '123 Main St', 'Chicago', 'IL', 60601, '01');

-- Read a specific school’s information
SELECT * FROM chicago_public_schools WHERE School_ID = 101;

-- Update crime data for a specific case
UPDATE chicago_crime
SET LOCATION_DESCRIPTION = 'Updated Location'
WHERE CASE_NUMBER = '12345678';

-- Delete a specific crime record
DELETE FROM chicago_crime WHERE CASE_NUMBER = '12345678';


-- 3. ACID Properties and Transactions (Ensure Data Integrity)
-- Using Transactions to ensure atomicity
START TRANSACTION;

-- Inserting a new school
INSERT INTO chicago_public_schools (NAME_OF_SCHOOL, STREET_ADDRESS, CITY, STATE, ZIP_Code, COMMUNITY_AREA_NUMBER)
VALUES ('New School', '456 New St', 'Chicago', 'IL', 60602, '02');

-- Inserting a new crime entry (this could fail if a foreign key constraint is violated)
INSERT INTO chicago_crime (CASE_NUMBER, PRIMARY_TYPE, DATE, BLOCK, COMMUNITY_AREA_NUMBER)
VALUES ('87654321', 'Robbery', '2023-10-01', '10 Block', '01');

-- Commit the transaction
COMMIT;

-- If anything goes wrong, rollback
ROLLBACK;

-- 4. Foreign/Primary Key Design
-- Add a new foreign key constraint to ensure data integrity between public schools and socio-economic data
ALTER TABLE chicago_public_schools
ADD CONSTRAINT FK_Community_Area
FOREIGN KEY (COMMUNITY_AREA_NUMBER) 
REFERENCES chicago_socioeconomic_data(COMMUNITY_AREA_NUMBER);

-- Show primary keys and foreign keys
SHOW CREATE TABLE chicago_public_schools;
SHOW CREATE TABLE chicago_crime;

-- 5. Common Table Expressions (CTEs) (To simplify complex queries)
-- Example of using CTE to analyze crime rates by community area
WITH CrimeData AS (
    SELECT COMMUNITY_AREA_NUMBER, COUNT(*) AS Total_Crimes
    FROM chicago_crime
    GROUP BY COMMUNITY_AREA_NUMBER
)
SELECT c.COMMUNITY_AREA_NAME, d.Total_Crimes
FROM chicago_socioeconomic_data c
JOIN CrimeData d ON c.COMMUNITY_AREA_NUMBER = d.COMMUNITY_AREA_NUMBER
ORDER BY d.Total_Crimes DESC;

-- 6. Joins (Analyzing Relationships between Tables)

-- -- Join to see community areas with school information
SELECT s.NAME_OF_SCHOOL, s.STREET_ADDRESS, c.COMMUNITY_AREA_NAME
FROM chicago_public_schools s
JOIN chicago_socioeconomic_data c ON s.COMMUNITY_AREA_NUMBER = c.COMMUNITY_AREA_NUMBER;

-- Left Join to find schools without socio-economic data
SELECT s.NAME_OF_SCHOOL, s.COMMUNITY_AREA_NUMBER
FROM chicago_public_schools s
LEFT JOIN chicago_socioeconomic_data c ON s.COMMUNITY_AREA_NUMBER = c.COMMUNITY_AREA_NUMBER
WHERE c.COMMUNITY_AREA_NUMBER IS NULL;

-- 7. Subqueries (For Advanced Filtering)

-- Subquery to get schools with the highest attendance rate
SELECT NAME_OF_SCHOOL, AVERAGE_STUDENT_ATTENDANCE
FROM chicago_public_schools
WHERE AVERAGE_STUDENT_ATTENDANCE = (SELECT MAX(AVERAGE_STUDENT_ATTENDANCE) FROM chicago_public_schools);

-- Subquery to list crimes occurring in the top 5 community areas with the most crimes
SELECT * FROM chicago_crime
WHERE COMMUNITY_AREA_NUMBER IN (
    SELECT COMMUNITY_AREA_NUMBER FROM chicago_crime
    GROUP BY COMMUNITY_AREA_NUMBER
    ORDER BY COUNT(*) DESC
    LIMIT 5
);

-- 8. Window Functions (For Advanced Analytics)
-- Rank community areas by crime rate (using window function)
SELECT COMMUNITY_AREA_NAME, COUNT(*) AS Total_Crimes,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS Crime_Rank
FROM chicago_crime
JOIN chicago_socioeconomic_data 
ON chicago_crime.COMMUNITY_AREA_NUMBER = chicago_socioeconomic_data.COMMUNITY_AREA_NUMBER
GROUP BY COMMUNITY_AREA_NAME;


-- 9. Stored Procedures (For Reusable Logic)
DELIMITER $$

CREATE PROCEDURE GetSchoolsByCommunityArea(IN community_area VARCHAR(2))
BEGIN
    SELECT NAME_OF_SCHOOL, STREET_ADDRESS
    FROM chicago_public_schools
    WHERE COMMUNITY_AREA_NUMBER = community_area;
END $$

DELIMITER ;

-- Calling the stored procedure
CALL GetSchoolsByCommunityArea('01');


-- 10. Triggers (For Automatically Handling Events)

-- Trigger to update the crime count when a new crime is inserted

DELIMITER $$

CREATE TRIGGER crime_count_update
AFTER INSERT ON chicago_crime
FOR EACH ROW
BEGIN
    UPDATE chicago_socioeconomic_data
    SET PERCENT_OF_HOUSING_CROWDED = PERCENT_OF_HOUSING_CROWDED + 0.1
    WHERE COMMUNITY_AREA_NUMBER = NEW.COMMUNITY_AREA_NUMBER;
END $$

DELIMITER ;

-- 11. Views (For Simplifying Repeated Queries)
-- Create a view to show crime data by community area
CREATE VIEW ViewCrimeByArea AS
SELECT COMMUNITY_AREA_NAME, COUNT(*) AS Crime_Count
FROM chicago_crime
JOIN chicago_socioeconomic_data 
ON chicago_crime.COMMUNITY_AREA_NUMBER = chicago_socioeconomic_data.COMMUNITY_AREA_NUMBER
GROUP BY COMMUNITY_AREA_NAME;

-- Query the view
SELECT * FROM ViewCrimeByArea;


-- 12. Indexing (For Performance)
-- Create an index on the community area number for faster lookups in crime data
CREATE INDEX idx_community_area_number ON chicago_crime(COMMUNITY_AREA_NUMBER);

-- Show all indexes in the database
SHOW INDEXES FROM chicago_crime;


-- 13. Case Statements (For Conditional Logic)
-- Case statement to categorize community areas based on crime rate
SELECT COMMUNITY_AREA_NAME,
       CASE 
           WHEN COUNT(*) > 100 THEN 'High Crime'
           WHEN COUNT(*) BETWEEN 50 AND 100 THEN 'Moderate Crime'
           ELSE 'Low Crime'
       END AS Crime_Level
FROM chicago_crime
GROUP BY COMMUNITY_AREA_NAME;

-- 1. Normalization and Denormalization
/*If WE need to organize OUR data schema better for efficiency or analysis:*/

-- Normalize the database (splitting data into smaller tables)
CREATE TABLE crime_types (
    CRIME_TYPE_ID INT PRIMARY KEY,
    TYPE_NAME VARCHAR(255) NOT NULL
);

-- Denormalize by adding a column for crime type in the crime table for quicker queries
ALTER TABLE chicago_crime ADD COLUMN CRIME_TYPE VARCHAR(255);

-- 2. Data Validation & Constraints
-- For ensuring data integrity before insertion:
-- Check if crime type exists before adding a record
INSERT INTO chicago_crime (CASE_NUMBER, PRIMARY_TYPE, DATE, COMMUNITY_AREA_NUMBER)
SELECT '98765432', 'Theft', '2023-11-01', '04'
FROM crime_types
WHERE TYPE_NAME = 'Theft';

-- Add a CHECK constraint to ensure no negative values for crime counts
ALTER TABLE chicago_socioeconomic_data
ADD CONSTRAINT CHECK_CRIME_COUNT CHECK (TOTAL_CRIMES >= 0);

-- 3. Aggregation with GROUP BY and HAVING (Advanced Data Summaries)
-- Count crimes per community area with a filter on the number of crimes
SELECT COMMUNITY_AREA_NAME, COUNT(*) AS Crime_Count
FROM chicago_crime
JOIN chicago_socioeconomic_data 
ON chicago_crime.COMMUNITY_AREA_NUMBER = chicago_socioeconomic_data.COMMUNITY_AREA_NUMBER
GROUP BY COMMUNITY_AREA_NAME
HAVING COUNT(*) > 50;  -- Only show areas with more than 50 crimes

-- 4. Recursive Queries (Using CTE for Hierarchical Data)
-- If our data needs hierarchical querying (such as nested community areas or crime categories):
-- Using Recursive CTE for hierarchical reporting of community areas and sub-areas
WITH RECURSIVE CommunityHierarchy AS (
    SELECT COMMUNITY_AREA_NUMBER, COMMUNITY_AREA_NAME, PARENT_AREA_NUMBER
    FROM chicago_socioeconomic_data
    WHERE PARENT_AREA_NUMBER IS NULL
    UNION ALL
    SELECT c.COMMUNITY_AREA_NUMBER, c.COMMUNITY_AREA_NAME, c.PARENT_AREA_NUMBER
    FROM chicago_socioeconomic_data c
    INNER JOIN CommunityHierarchy ch ON c.PARENT_AREA_NUMBER = ch.COMMUNITY_AREA_NUMBER
)
SELECT * FROM CommunityHierarchy;


-- 5. Cross Join (For Generating All Possible Combinations)

-- Create all combinations of schools and crime types to analyze patterns
SELECT s.NAME_OF_SCHOOL, c.TYPE_NAME
FROM chicago_public_schools s
CROSS JOIN crime_types c;


-- 6. Data Duplication Detection
-- Checking for duplicate records:

-- Detect duplicate records in the crime data by CASE_NUMBER
SELECT CASE_NUMBER, COUNT(*)
FROM chicago_crime
GROUP BY CASE_NUMBER
HAVING COUNT(*) > 1;

-- Delete duplicate records, leaving the latest one
DELETE FROM chicago_crime
WHERE CASE_NUMBER IN (
    SELECT CASE_NUMBER
    FROM (SELECT CASE_NUMBER, ROW_NUMBER() OVER (PARTITION BY CASE_NUMBER ORDER BY DATE DESC) AS row_num
          FROM chicago_crime) AS temp
    WHERE row_num > 1
);


-- 7. User Permissions (Security)
-- Managing user access to specific data:
-- Create a read-only user for the crime data
CREATE USER 'crime_reader'@'localhost' IDENTIFIED BY 'password';

-- Grant SELECT privilege on the chicago_crime table
GRANT SELECT ON `ChicagoDB`.`chicago_crime` TO 'crime_reader'@'localhost';

-- Revoke SELECT privilege from the user for the chicago_crime table
REVOKE SELECT ON `ChicagoDB`.`chicago_crime` FROM 'crime_reader'@'localhost';

-- 8. Backup and Restore Data
-- Backup and restore queries for database management:
-- Backup the database for SQL server
BACKUP DATABASE chicago_data TO DISK = 'C:/backups/chicago_data.bak';

-- Restore the database from a backup
RESTORE DATABASE chicago_data FROM DISK = 'C:/backups/chicago_data.bak';


-- 9. Database Migration (For Moving Data Between Tables)
-- If you are restructuring the data:
-- Migrate crime data to a new table with a different structure
CREATE TABLE new_chicago_crime AS
SELECT CASE_NUMBER, PRIMARY_TYPE, LOCATION, DATE
FROM chicago_crime;

-- Drop the old table after migration
DROP TABLE chicago_crime;

-- 10. Optimizing Query Performance with Partitioning
-- For managing large datasets more efficiently:

-- Partition the crime table by year for better query performance
ALTER TABLE chicago_crime
PARTITION BY RANGE (YEAR(DATE)) (
    PARTITION p_2020 VALUES LESS THAN (2021),
    PARTITION p_2021 VALUES LESS THAN (2022),
    PARTITION p_2022 VALUES LESS THAN (2023)
);

-- Query partitioned data
SELECT * FROM chicago_crime PARTITION (p_2021);

-- 11. User-Defined Functions (UDFs)
-- For complex operations that you need to reuse across queries:
-- Create a function to categorize crime type based on severity
DELIMITER $$

CREATE FUNCTION GetCrimeCategory(crime_type VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    IF crime_type IN ('Robbery', 'Assault') THEN
        RETURN 'High';
    ELSE
        RETURN 'Low';
    END IF;
END $$

DELIMITER ;

-- Use the function in a query
SELECT CASE_NUMBER, GetCrimeCategory(PRIMARY_TYPE) AS Crime_Category
FROM chicago_crime;

-- 12. Advanced Aggregations with GROUP_CONCAT
-- Concatenating values within a group:
-- Concatenate all crime types per community area
SELECT COMMUNITY_AREA_NAME, GROUP_CONCAT(DISTINCT PRIMARY_TYPE ORDER BY PRIMARY_TYPE) AS Crime_Types
FROM chicago_crime
JOIN chicago_socioeconomic_data
ON chicago_crime.COMMUNITY_AREA_NUMBER = chicago_socioeconomic_data.COMMUNITY_AREA_NUMBER
GROUP BY COMMUNITY_AREA_NAME;

-- 13. Handling Large Data Sets with LIMIT and OFFSET
-- Paginate data to handle large sets efficiently:
-- Get the first 50 rows of crime data
SELECT * FROM chicago_crime LIMIT 50;

-- Get the next 50 rows (pagination with OFFSET)
SELECT * FROM chicago_crime LIMIT 50 OFFSET 50;


-- THE END --


