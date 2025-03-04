-- Create the PetDB database and use it
CREATE DATABASE PetDB;
USE PetDB;

-- Drop the PETSALE table if it exists
DROP TABLE IF EXISTS PETSALE;

-- Create the PETSALE table without QUANTITY
CREATE TABLE PETSALE (
    ID INTEGER NOT NULL,
    ANIMAL VARCHAR(20),
    SALEPRICE DECIMAL(6,2),
    SALEDATE DATE,
    PRIMARY KEY (ID)
);

-- Create the PET table
CREATE TABLE PET (
    ID INT NOT NULL,
    ANIMAL VARCHAR(20),
    QUANTITY INT
);

-- Insert sample data into the PETSALE table
INSERT INTO PETSALE VALUES
    (1, 'Cat', 450.09, '2018-05-29'),
    (2, 'Dog', 666.66, '2018-06-01'),
    (3, 'Parrot', 50.00, '2018-06-04'),
    (4, 'Hamster', 60.60, '2018-06-11'),
    (5, 'Goldfish', 48.48, '2018-06-14');

-- Insert sample data into the PET table
INSERT INTO PET VALUES
    (1, 'Cat', 3),
    (2, 'Dog', 4),
    (3, 'Hamster', 2);

-- Drop the PETRESCUE table if it exists
DROP TABLE IF EXISTS PETRESCUE;

-- Create the PETRESCUE table 
CREATE TABLE PETRESCUE (
    ID INTEGER NOT NULL,
    ANIMAL VARCHAR(20),
    QUANTITY INTEGER,
    COST DECIMAL(6,2),
    RESCUEDATE DATE,
    PRIMARY KEY (ID)
);

-- Insert sample data into the PETRESCUE table
INSERT INTO PETRESCUE VALUES 
    (1, 'Cat', 9, 450.09, '2018-05-29'),
    (2, 'Dog', 3, 666.66, '2018-06-01'),
    (3, 'Dog', 1, 100.00, '2018-06-04'),
    (4, 'Parrot', 2, 50.00, '2018-06-04'),
    (5, 'Dog', 1, 75.75, '2018-06-10'),
    (6, 'Hamster', 6, 60.60, '2018-06-11'),
    (7, 'Cat', 1, 44.44, '2018-06-11'),
    (8, 'Goldfish', 24, 48.48, '2018-06-14'),
    (9, 'Dog', 2, 222.22, '2018-06-15');

-- Create stored procedure RETRIEVE_ALL
/* 
You will create a stored procedure routine named RETRIEVE_ALL.
*/
DELIMITER //

CREATE PROCEDURE RETRIEVE_ALL()
BEGIN
    SELECT * FROM PETSALE;
END //

DELIMITER ;

-- Call the RETRIEVE_ALL procedure
CALL RETRIEVE_ALL;

-- Drop the procedure if needed
DROP PROCEDURE IF EXISTS RETRIEVE_ALL;

-- Create stored procedure UPDATE_SALEPRICE
/*
You will create a stored procedure routine named 
UPDATE_SALEPRICE with parameters Animal_ID and Animal_Health.
This procedure will update the sale price of animals 
in the PETSALE table depending on their health conditions, 
BAD or WORSE.
- For BAD health condition, the sale price will be reduced by 25%.
- For WORSE health condition, the sale price will be reduced by 50%.
- For other conditions, the sale price will remain unchanged.
*/
DELIMITER @
CREATE PROCEDURE UPDATE_SALEPRICE (IN Animal_ID INTEGER, IN Animal_Health VARCHAR(5))
BEGIN
    IF Animal_Health = 'BAD' THEN
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE - (SALEPRICE * 0.25)
        WHERE ID = Animal_ID;
    ELSEIF Animal_Health = 'WORSE' THEN
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE - (SALEPRICE * 0.5)
        WHERE ID = Animal_ID;
    ELSE
        UPDATE PETSALE
        SET SALEPRICE = SALEPRICE
        WHERE ID = Animal_ID;
    END IF;
END @

DELIMITER ;

-- Call the UPDATE_SALEPRICE procedure
CALL RETRIEVE_ALL;
CALL UPDATE_SALEPRICE(1, 'BAD');
CALL RETRIEVE_ALL;
CALL UPDATE_SALEPRICE(3, 'WORSE');
CALL RETRIEVE_ALL;

-- Queries to modify and query the table
SELECT * FROM PETSALE;

-- Add a new column QUANTITY to PETSALE table
# Add column command
ALTER TABLE PETSALE ADD COLUMN QUANTITY INTEGER;

-- Update values for the QUANTITY column
UPDATE PETSALE SET QUANTITY = 9 WHERE ANIMAL = 'Cat';
UPDATE PETSALE SET QUANTITY = 3 WHERE ANIMAL = 'Dog';
UPDATE PETSALE SET QUANTITY = 2 WHERE ANIMAL = 'Parrot';
UPDATE PETSALE SET QUANTITY = 6 WHERE ANIMAL = 'Hamster';
UPDATE PETSALE SET QUANTITY = 24 WHERE ANIMAL = 'Goldfish';

-- Drop the PROFIT column if it exists (PROFIT column was not previously created, so this might be redundant)
# Drop column command: drop the profit column
ALTER TABLE PETSALE DROP COLUMN PROFIT;

-- Modify the data type of the ANIMAL column
ALTER TABLE PETSALE MODIFY ANIMAL VARCHAR(20);

-- Rename the ANIMAL column to PET
ALTER TABLE PETSALE RENAME COLUMN ANIMAL TO PET;

-- Drop the PET table if it exists
DROP TABLE IF EXISTS PET;
