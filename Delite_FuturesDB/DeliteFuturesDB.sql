
-- 1. Create Database and Use It
CREATE DATABASE DeliteFuturesDB;
USE DeliteFuturesDB;

-- 2. Create Tables in Order of Dependencies
/*The tables should be created starting from the most independent (no foreign keys) 
to the most dependent (with multiple foreign keys).
(a) Independent Tables
Admin: No foreign keys.
Staff: No foreign keys.
Membership_Tiers: No foreign keys.
*/
-- Admin Table
CREATE TABLE Admin (
    AdminID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ContactInfo VARCHAR(255) NOT NULL,
    Role ENUM('SuperAdmin', 'Manager', 'Support') NOT NULL,
    HireDate DATE DEFAULT (CURRENT_DATE)
);

-- Staff Table
CREATE TABLE Staff (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(100) NOT NULL,
    ContactDetails VARCHAR(255) NOT NULL,
    HireDate DATE DEFAULT (CURRENT_DATE)
);


-- Membership_Tiers Table
CREATE TABLE Membership_Tiers (
    TierID INT AUTO_INCREMENT PRIMARY KEY,
    TierName ENUM('Basic', 'Silver', 'Gold') NOT NULL,
    FreeProjectsAllowed INT NOT NULL,
    ExtraProjectFee DECIMAL(10, 2) NOT NULL
);

/*(b) Tables Dependent on Independent Tables
Members: Indirectly references Membership_Tiers through MembershipLevel.
Projects: References Staff via LeaderID.
*/
-- Members Table
CREATE TABLE Members (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ContactInfo VARCHAR(255) NOT NULL,
    MembershipLevel ENUM('Basic', 'Silver', 'Gold') NOT NULL,
    Interests TEXT,
    RegistrationDate DATE DEFAULT (CURRENT_DATE)
);


-- Projects Table
CREATE TABLE Projects (
    ProjectCode INT AUTO_INCREMENT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    Description TEXT NOT NULL,
    Schedule DATE,
    MaxParticipants INT NOT NULL,
    LeaderID INT,
    CurrentParticipants INT DEFAULT 0,
    FOREIGN KEY (LeaderID) REFERENCES Staff(StaffID) ON DELETE SET NULL
);
/*
(c) Tables Dependent on Multiple Tables
Bookings: Depends on Members and Projects.
Payments: Depends on Members and Projects.
Participation: Depends on Members and Projects.*/

-- Bookings Table
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    ProjectCode INT,
    BookingDate DATE DEFAULT (CURRENT_DATE) ,
    PaymentStatus ENUM('Paid', 'Unpaid') DEFAULT 'Unpaid',
    FOREIGN KEY (MemberID) REFERENCES Members(ID) ON DELETE CASCADE,
    FOREIGN KEY (ProjectCode) REFERENCES Projects(ProjectCode) ON DELETE CASCADE
);


-- Payments Table
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    ProjectCode INT,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentDate DATE DEFAULT (CURRENT_DATE),
    PaymentMethod ENUM('CreditCard', 'PayPal', 'BankTransfer') NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(ID),
    FOREIGN KEY (ProjectCode) REFERENCES Projects(ProjectCode)
);

-- Participation Table
CREATE TABLE Participation (
    ParticipationID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    ProjectCode INT,
    Feedback TEXT,
    ParticipationDate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (MemberID) REFERENCES Members(ID),
    FOREIGN KEY (ProjectCode) REFERENCES Projects(ProjectCode)
);


/*(d) Logging and Notifications
LoginAttempts: Depends on Members.
Notifications: Depends on Members.*/


-- LoginAttempts Table
CREATE TABLE LoginAttempts (
    AttemptID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    AttemptTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    AttemptResult ENUM('Success', 'Failed') NOT NULL,
    FailureReason TEXT,
    FOREIGN KEY (MemberID) REFERENCES Members(ID)
);

-- Notifications Table
CREATE TABLE Notifications (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    Message TEXT NOT NULL,
    SentTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (MemberID) REFERENCES Members(ID)
);

-- Data Insertion

-- Admin Data
INSERT INTO Admin (Name, ContactInfo, Role, HireDate)
VALUES
('Alex Johnson', 'alex.johnson@email.com', 'SuperAdmin', '2023-05-10'),
('Jessica Brown', 'jessica.brown@email.com', 'Manager', '2024-01-15'),
('Chris Wilson', 'chris.wilson@email.com', 'Support', '2024-06-01'),
('Emily Adams', 'emily.adams@email.com', 'Manager', '2023-09-12'),
('Daniel Lee', 'daniel.lee@email.com', 'Support', '2025-01-05');

-- Staff Data
INSERT INTO Staff (Name, Role, ContactDetails) 
VALUES 
('John Doe', 'Manager', 'johndoe@example.com'),
('Jane Smith', 'Coordinator', 'janesmith@example.com'),
('Alice Brown', 'Supervisor', 'alicebrown@example.com'),
('Bob Green', 'Advisor', 'bobgreen@example.com'),
('Charlie White', 'Analyst', 'charliewhite@example.com'),
('David Black', 'Consultant', 'davidblack@example.com'),
('Emma Blue', 'Director', 'emmablue@example.com'),
('Fiona Yellow', 'Specialist', 'fionayellow@example.com'),
('George Red', 'Leader', 'georgered@example.com'),
('Hannah Purple', 'Assistant', 'hannahpurple@example.com'),
('Isaac Orange', 'Technician', 'isaacorange@example.com'),
('Jack Pink', 'Intern', 'jackpink@example.com');

-- Membership_Tiers Data
INSERT INTO Membership_Tiers (TierName, FreeProjectsAllowed, ExtraProjectFee)
VALUES
('Basic', 1, 50.00),
('Silver', 3, 30.00),
('Gold', 5, 0.00);

-- Members Data
INSERT INTO Members (Name, ContactInfo, MembershipLevel, Interests)
VALUES
('John Doe', 'john.doe@email.com', 'Gold', 'Wildlife Conservation'),
('Jane Smith', 'jane.smith@email.com', 'Silver', 'Beach Cleanup'),
('Lucas Martinez', 'lucas.martinez@email.com', 'Gold', 'Water Conservation'),
('Mia Green', 'mia.green@email.com', 'Basic', 'Urban Gardening'),
('Samuel Lee', 'samuel.lee@email.com', 'Silver', 'Energy Efficiency'),
('Emily Johnson', 'emily.johnson@email.com', 'Gold', 'Renewable Energy'),
('David Brown', 'david.brown@email.com', 'Gold', 'Waste Management'),
('Sophia Wilson', 'sophia.wilson@email.com', 'Silver', 'Forest Protection'),
('Oliver Taylor', 'oliver.taylor@email.com', 'Basic', 'Recycling Programs'),
('Ava Harris', 'ava.harris@email.com', 'Silver', 'Sustainable Agriculture'),
('Chloe Adams', 'chloe.adams@email.com', 'Gold', 'Wildlife Photography'),
('Liam Thompson', 'liam.thompson@email.com', 'Basic', 'Energy Auditing');

-- Projects Data
INSERT INTO Projects (ProjectCode, ProjectName, Description, Schedule, MaxParticipants, LeaderID)
VALUES
(1, 'Wildlife Protection Program', 'Protecting endangered species.', '2025-02-10', 20, 1),
(2, 'Clean Energy Campaign', 'Raising awareness about renewables.', '2025-11-20', 25, 2),
(3, 'Beach Cleanup Initiative', 'Coastal cleanup efforts.', '2025-06-15', 15, 3),
(4, 'Urban Greening Project', 'Bringing greenery to urban areas.', '2025-08-01', 30, 4),
(5, 'Recycling Awareness Program', 'Promoting recycling in communities.', '2025-07-12', 10, 5),
(6, 'Sustainable Agriculture Promotion', 'Educating about sustainable farming.', '2025-09-30', 20, 6),
(7, 'Water Conservation Initiative', 'Conserving water in arid regions.', '2025-05-20', 25, 7),
(8, 'Energy Efficiency Awareness', 'Reducing energy consumption in homes.', '2025-10-10', 18, 8),
(9, 'Forest Protection Program', 'Preserving forest ecosystems.', '2025-06-30', 22, 9),
(10, 'Waste Management Campaign', 'Proper waste disposal techniques.', '2025-12-01', 10, 10),
(11, 'Climate Change Workshops', 'Workshops for raising climate awareness.', '2025-03-15', 50, 11),
(12, 'Youth Leadership for Sustainability', 'Engaging youth leaders.', '2025-04-20', 40, 12);

-- Bookings Data
INSERT INTO Bookings (MemberID, ProjectCode, PaymentStatus)
VALUES
(1, 1, 'Paid'),
(2, 3, 'Paid'),
(3, 7, 'Unpaid'),
(4, 4, 'Unpaid'),
(5, 6, 'Paid'),
(6, 2, 'Paid'),
(7, 5, 'Paid'),
(8, 8, 'Unpaid'),
(9, 9, 'Paid'),
(10, 10, 'Unpaid'),
(11, 11, 'Paid'),
(12, 12, 'Paid');

-- Payments Data
INSERT INTO Payments (MemberID, ProjectCode, Amount, PaymentMethod)
VALUES
(1, 1, 100.00, 'CreditCard'),
(2, 3, 60.00, 'PayPal'),
(3, 7, 80.00, 'BankTransfer'),
(4, 4, 40.00, 'PayPal'),
(5, 6, 90.00, 'CreditCard'),
(6, 2, 100.00, 'BankTransfer'),
(7, 5, 50.00, 'CreditCard'),
(8, 8, 70.00, 'PayPal'),
(9, 9, 80.00, 'CreditCard'),
(10, 10, 60.00, 'BankTransfer'),
(11, 11, 100.00, 'CreditCard'),
(12, 12, 90.00, 'PayPal');


-- 3. Create Triggers for Automatic Updates or Actions

-- Trigger for updating the payment status of a booking when a payment is made
DELIMITER $$
CREATE TRIGGER UpdatePaymentStatus
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    UPDATE Bookings
    SET PaymentStatus = 'Paid'
    WHERE MemberID = NEW.MemberID AND ProjectCode = NEW.ProjectCode;
END$$
DELIMITER ;

-- Trigger for updating the number of participants when a new booking is made
DELIMITER $$
CREATE TRIGGER UpdateParticipantsCount
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    DECLARE current_count INT;
    -- Count the number of bookings for the project
    SELECT COUNT(*) INTO current_count FROM Bookings WHERE ProjectCode = NEW.ProjectCode;
    -- Update the 'CurrentParticipants' in Projects table
    UPDATE Projects
    SET CurrentParticipants = current_count
    WHERE ProjectCode = NEW.ProjectCode;
END$$
DELIMITER ;

-- 4. Create Stored Procedures for Reusable Queries

-- Stored procedure to add a new project
DELIMITER $$
CREATE PROCEDURE AddNewProject(IN project_name VARCHAR(100), IN description TEXT, IN schedule DATE, IN max_participants INT, IN leader_id INT)
BEGIN
    INSERT INTO Projects (ProjectName, Description, Schedule, MaxParticipants, LeaderID)
    VALUES (project_name, description, schedule, max_participants, leader_id);
END$$
DELIMITER ;

-- Stored procedure to get all members' payment statuses for a specific project
DELIMITER $$
CREATE PROCEDURE GetProjectPayments(IN project_id INT)
BEGIN
    SELECT Members.Name, Payments.Amount, Payments.PaymentDate, Payments.PaymentMethod, Bookings.PaymentStatus
    FROM Payments
    JOIN Members ON Payments.MemberID = Members.ID
    JOIN Bookings ON Bookings.MemberID = Members.ID
    WHERE Payments.ProjectCode = project_id;
END$$
DELIMITER ;

-- Stored procedure to calculate the total earnings for a project based on payments
DELIMITER $$
CREATE PROCEDURE CalculateTotalEarnings(IN project_id INT)
BEGIN
    SELECT SUM(Amount) AS TotalEarnings
    FROM Payments
    WHERE ProjectCode = project_id;
END$$
DELIMITER ;

-- 5. Sample Queries

-- Retrieve all members with their membership level
SELECT Name, MembershipLevel FROM Members;

-- Retrieve all projects with their leader's name
SELECT ProjectName, Description, Schedule, MaxParticipants, Staff.Name AS Leader
FROM Projects
JOIN Staff ON Projects.LeaderID = Staff.StaffID;

-- Retrieve members who booked for a particular project
SELECT Members.Name, Bookings.BookingDate, Bookings.PaymentStatus
FROM Bookings
JOIN Members ON Bookings.MemberID = Members.ID
WHERE Bookings.ProjectCode = 1;

-- Retrieve payment details for a specific project
SELECT Members.Name, Payments.Amount, Payments.PaymentDate, Payments.PaymentMethod
FROM Payments
JOIN Members ON Payments.MemberID = Members.ID
WHERE Payments.ProjectCode = 2;

-- Get all members' participation feedback for a specific project
SELECT Members.Name, Participation.Feedback
FROM Participation
JOIN Members ON Participation.MemberID = Members.ID
WHERE Participation.ProjectCode = 3;

-- Retrieve the membership tier details for each member
SELECT Members.Name, Membership_Tiers.TierName, Membership_Tiers.FreeProjectsAllowed, Membership_Tiers.ExtraProjectFee
FROM Members
JOIN Membership_Tiers ON Members.MembershipLevel = Membership_Tiers.TierName;

-- Find the total number of bookings made for a project
SELECT Projects.ProjectName, COUNT(Bookings.BookingID) AS TotalBookings
FROM Bookings
JOIN Projects ON Bookings.ProjectCode = Projects.ProjectCode
GROUP BY Projects.ProjectName;

-- Get members who have unpaid bookings
SELECT Members.Name, Bookings.PaymentStatus
FROM Bookings
JOIN Members ON Bookings.MemberID = Members.ID
WHERE Bookings.PaymentStatus = 'Unpaid';





/*
Trigger for updating the payment status:

The Payments table references MemberID and ProjectCode. Ensure Bookings uses the same combination to identify bookings.
-- Trigger to handle cases where multiple bookings exist for the same member and project.
*/

DELIMITER $$
CREATE TRIGGER UpdatePaymentStatus
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    UPDATE Bookings
    SET PaymentStatus = 'Paid'
    WHERE MemberID = NEW.MemberID AND ProjectCode = NEW.ProjectCode AND PaymentStatus = 'Unpaid';
END$$
DELIMITER ;
Trigger for updating participants count:

Update CurrentParticipants in the Projects table by incrementing the value instead of recalculating, for better efficiency.
Modified Trigger:


DELIMITER $$
CREATE TRIGGER UpdateParticipantsCount
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Projects
    SET CurrentParticipants = CurrentParticipants + 1
    WHERE ProjectCode = NEW.ProjectCode;
END$$
DELIMITER ;
Modifications for Stored Procedures
Adding a New Project:

Ensure LeaderID references an existing StaffID in the Staff table.
Modified Procedure:


DELIMITER $$
CREATE PROCEDURE AddNewProject(
    IN project_name VARCHAR(100), 
    IN description TEXT, 
    IN schedule DATE, 
    IN max_participants INT, 
    IN leader_id INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM Staff WHERE StaffID = leader_id) THEN
        INSERT INTO Projects (ProjectName, Description, Schedule, MaxParticipants, LeaderID)
        VALUES (project_name, description, schedule, max_participants, leader_id);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LeaderID does not exist';
    END IF;
END$$
DELIMITER ;



/* 
   SQL Triggers, Stored Procedures, Sample Queries, and Indexing
*/

/* 
   3. Create Triggers for Automatic Updates or Actions 
*/

/* Trigger for updating the payment status of a booking when a payment is made */
DELIMITER $$
CREATE TRIGGER UpdatePaymentStatus
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    UPDATE Bookings
    SET PaymentStatus = 'Paid'
    WHERE MemberID = NEW.MemberID AND ProjectCode = NEW.ProjectCode AND PaymentStatus = 'Unpaid';
END$$
DELIMITER ;

/* Trigger for updating the number of participants when a new booking is made */
DELIMITER $$
CREATE TRIGGER UpdateParticipantsCount
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Projects
    SET CurrentParticipants = CurrentParticipants + 1
    WHERE ProjectCode = NEW.ProjectCode;
END$$
DELIMITER ;

/* 
   4. Create Stored Procedures for Reusable Queries 
*/

/* Stored procedure to add a new project */
DELIMITER $$
CREATE PROCEDURE AddNewProject(
    IN project_name VARCHAR(100), 
    IN description TEXT, 
    IN schedule DATE, 
    IN max_participants INT, 
    IN leader_id INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM Staff WHERE StaffID = leader_id) THEN
        INSERT INTO Projects (ProjectName, Description, Schedule, MaxParticipants, LeaderID)
        VALUES (project_name, description, schedule, max_participants, leader_id);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LeaderID does not exist';
    END IF;
END$$
DELIMITER ;

/* Stored procedure to get all members' payment statuses for a specific project */
DELIMITER $$
CREATE PROCEDURE GetProjectPayments(IN project_id INT)
BEGIN
    SELECT 
        Members.Name, 
        Payments.Amount, 
        Payments.PaymentDate, 
        Payments.PaymentMethod, 
        Bookings.PaymentStatus
    FROM Payments
    JOIN Members ON Payments.MemberID = Members.ID
    JOIN Bookings ON Bookings.MemberID = Members.ID AND Bookings.ProjectCode = Payments.ProjectCode
    WHERE Payments.ProjectCode = project_id;
END$$
DELIMITER ;

/* Stored procedure to calculate the total earnings for a project */
DELIMITER $$
CREATE PROCEDURE CalculateTotalEarnings(IN project_id INT)
BEGIN
    IF EXISTS (SELECT 1 FROM Projects WHERE ProjectCode = project_id) THEN
        SELECT SUM(Amount) AS TotalEarnings
        FROM Payments
        WHERE ProjectCode = project_id;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ProjectCode does not exist';
    END IF;
END$$
DELIMITER ;

/* 
   5. Sample Queries 
*/

/* Retrieve all members with their membership level */
SELECT Name, MembershipLevel FROM Members;

/* Retrieve all projects with their leader's name */
SELECT ProjectName, Description, Schedule, MaxParticipants, Staff.Name AS Leader
FROM Projects
JOIN Staff ON Projects.LeaderID = Staff.StaffID;

/* Retrieve members who booked for a particular project */
SELECT Members.Name, Bookings.BookingDate, Bookings.PaymentStatus
FROM Bookings
JOIN Members ON Bookings.MemberID = Members.ID
WHERE Bookings.ProjectCode = 1;

/* Retrieve payment details for a specific project */
SELECT Members.Name, Payments.Amount, Payments.PaymentDate, Payments.PaymentMethod
FROM Payments
JOIN Members ON Payments.MemberID = Members.ID
WHERE Payments.ProjectCode = 2;

/* Get all members' participation feedback for a specific project */
SELECT Members.Name, Participation.Feedback
FROM Participation
JOIN Members ON Participation.MemberID = Members.ID
WHERE Participation.ProjectCode = 3;

/* Retrieve the membership tier details for each member */
SELECT Members.Name, Membership_Tiers.TierName, Membership_Tiers.FreeProjectsAllowed, Membership_Tiers.ExtraProjectFee
FROM Members
JOIN Membership_Tiers ON Members.MembershipLevel = Membership_Tiers.TierName;

/* Find the total number of bookings made for a project */
SELECT Projects.ProjectName, COUNT(Bookings.BookingID) AS TotalBookings
FROM Bookings
JOIN Projects ON Bookings.ProjectCode = Projects.ProjectCode
GROUP BY Projects.ProjectName;

/* Get members who have unpaid bookings */
SELECT Members.Name, Bookings.PaymentStatus
FROM Bookings
JOIN Members ON Bookings.MemberID = Members.ID
WHERE Bookings.PaymentStatus = 'Unpaid';

/* 
   Indexing for Query Optimization 
*/

/* Indexes for Admin table */
CREATE INDEX idx_name ON Admin(Name);
CREATE INDEX idx_contactinfo ON Admin(ContactInfo);

/* Indexes for Staff table */
CREATE INDEX idx_role ON Staff(Role);
CREATE INDEX idx_name_staff ON Staff(Name);
CREATE INDEX idx_contactdetails ON Staff(ContactDetails);

/* Index for Membership_Tiers table */
CREATE INDEX idx_tiername ON Membership_Tiers(TierName);

/* Indexes for Members table */
CREATE INDEX idx_membershiplevel ON Members(MembershipLevel);
CREATE INDEX idx_registrationdate ON Members(RegistrationDate);

/* Index for Projects table */
CREATE INDEX idx_leaderid ON Projects(LeaderID);

/* Indexes for Bookings table */
CREATE INDEX idx_memberid ON Bookings(MemberID);
CREATE INDEX idx_projectcode ON Bookings(ProjectCode);

/* Indexes for Payments table */
CREATE INDEX idx_memberid_payments ON Payments(MemberID);
CREATE INDEX idx_projectcode_payments ON Payments(ProjectCode);

/* Indexes for Participation table */
CREATE INDEX idx_memberid_participation ON Participation(MemberID);
CREATE INDEX idx_projectcode_participation ON Participation(ProjectCode);

/* Indexes for LoginAttempts table */
CREATE INDEX idx_memberid_login ON LoginAttempts(MemberID);
CREATE INDEX idx_attempttime ON LoginAttempts(AttemptTime);

/* Indexes for Notifications table */
CREATE INDEX idx_memberid_notifications ON Notifications(MemberID);
CREATE INDEX idx_senttime_notifications ON Notifications(SentTime);
