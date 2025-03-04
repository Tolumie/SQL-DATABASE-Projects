
-- Acid Transaction using stored Procedures
-- create database

CREATE DATABASE TRANSACTIONS;
USE TRANSACTIONS;

DROP TABLE IF EXISTS BankAccounts;


CREATE TABLE BankAccounts (
    AccountNumber VARCHAR(5) NOT NULL,
    AccountName VARCHAR(25) NOT NULL,
    Balance DECIMAL(8,2) CHECK(Balance>=0) NOT NULL,
    PRIMARY KEY (AccountNumber)
    );

INSERT INTO BankAccounts VALUES
('B001','Rose',300),
('B002','James',1345),
('B003','Shoe Shop',124200),
('B004','Corner Shop',76000);

DROP TABLE IF EXISTS ShoeShop;


CREATE TABLE ShoeShop (
    Product VARCHAR(25) NOT NULL,
    Stock INTEGER NOT NULL,
    Price DECIMAL(8,2) CHECK(Price>0) NOT NULL,
    PRIMARY KEY (Product)
    );

INSERT INTO ShoeShop VALUES
('Boots',11,200),
('High heels',8,600),
('Brogues',10,150),
('Trainers',14,300);

-- ACID TRANSACTIONS

/*
Scenario 1: Rose is buying a pair of Boots from ShoeShop.
We need to update:
1. Rose's balance in the BankAccounts table.
2. ShoeShop's balance in the BankAccounts table.
3. Boots stock in the ShoeShop table.

After successfully purchasing the Boots, we will attempt to buy Rose a pair of Trainers.
If this fails, the entire transaction should be rolled back.
*/

/*
Create a stored procedure named TRANSACTION_ROSE to manage this transaction,
including the use of TCL commands like COMMIT and ROLLBACK.
*/

/*
Behavior of the Procedure:
1. Deduct $200 from Rose's balance for the Boots purchase.
2. Add $200 to ShoeShop's balance.
3. Decrease the stock of Boots in ShoeShop by 1.

If successful, attempt to deduct $300 from Rose's balance for a pair of Trainers.

- Expected Failure: After buying the Boots, Rose's balance will be $100, which is less than the price of the Trainers ($300). 
- Since her balance is insufficient, the final UPDATE for the Trainers purchase will fail.

Due to the failure, the entire transaction will fail, and all changes will be rolled back.
No changes will be permanently saved to the database because COMMIT will not be executed.
*/


DELIMITER //

CREATE PROCEDURE TRANSACTION_ROSE()
BEGIN
    -- Handle any SQL exception by rolling back the transaction
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Start the transaction
    START TRANSACTION;

    -- Deduct $200 from Rose's balance
    UPDATE BankAccounts
    SET Balance = Balance-200
    WHERE AccountName = 'Rose';

    -- Add $200 to ShoeShop's balance
    UPDATE BankAccounts
    SET Balance = Balance+200
    WHERE AccountName = 'Shoe Shop';

    -- Reduce Boots stock by 1
    UPDATE ShoeShop
    SET Stock = Stock-1
    WHERE Product = 'Boots';

    -- Attempt to deduct $300 from Rose's balance for Trainers
    UPDATE BankAccounts
    SET Balance = Balance-300
    WHERE AccountName = 'Rose';

    -- Commit the transaction if all steps succeed
    COMMIT;
END //

DELIMITER ;

-- Let's now check if the transaction can successfully be committed or not

-- Call the procedure
CALL TRANSACTION_ROSE;

SELECT * FROM BankAccounts;

SELECT * FROM ShoeShop;


/*
Observations:
- The first three UPDATE statements (for the Boots purchase) should execute successfully:
  - Rose's new balance: $300 - $200 = $100.
  - ShoeShop's new balance: $124,200 + $200 = $124,400.
  - Boots stock in ShoeShop: 11 - 1 = 10.

- The final UPDATE for the Trainers purchase will fail because:
  - Rose's current balance: $100 is less than the price of Trainers: $300.
*/

/*
Transaction Behavior:
Since the transaction fails due to the insufficient balance for the Trainers purchase,
ROLLBACK will undo all changes made by the transaction.
As a result, no updates will be saved to the BankAccounts or ShoeShop tables.

This demonstrates how COMMIT and ROLLBACK work in a stored procedure:
- COMMIT: Saves all changes permanently when the transaction is successful.
- ROLLBACK: Reverses all changes if any part of the transaction fails.
*/

/*
Conclusion:
The stored procedure TRANSACTION_ROSE ensures data integrity by rolling back all changes
if a failure occurs during any part of the transaction.
*/

 
 /* Scenerio 2:
 Create a stored procedure TRANSACTION_JAMES to execute a transaction based on
 the following scenario: First buy James 4 pairs of Trainers from ShoeShop. 
 Update his balance as well as the balance of ShoeShop. Also,
 update the stock of Trainers at ShoeShop. Then attempt to buy James a pair of Brogues
 from ShoeShop. If any of the UPDATE statements fail, the whole transaction fails.
 You will roll back the transaction. Commit the transaction only if the
 whole transaction is successful.
 */
 
 DELIMITER //

CREATE PROCEDURE TRANSACTION_JAMES()
BEGIN
    -- Handle any SQL exception by rolling back the transaction
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Start the transaction
    START TRANSACTION;

    -- Deduct $1,200 from James' balance for Trainers
    UPDATE BankAccounts
    SET Balance = Balance-1200
    WHERE AccountName = 'James';

    -- Add $1,200 to ShoeShop's balance
    UPDATE BankAccounts
    SET Balance = Balance+1200
    WHERE AccountName = 'Shoe Shop';

    -- Reduce Trainers stock by 4
    UPDATE ShoeShop
    SET Stock = Stock-4
    WHERE Product = 'Trainers';

    -- Attempt to deduct $150 from James' balance for Brogues
    UPDATE BankAccounts
    SET Balance = Balance-150
    WHERE AccountName = 'James';

    -- Commit the transaction if all steps succeed
    COMMIT;
END //

DELIMITER ;

-- Call the procedure
CALL TRANSACTION_JAMES;

-- Check results
SELECT * FROM BankAccounts;
SELECT * FROM ShoeShop;





