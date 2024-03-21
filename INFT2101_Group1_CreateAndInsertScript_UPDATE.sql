/**************************************************
SQL DB CREATE AND INSERT SCRIPTS

Authors: Colin Eade
         Noelle Dacayo
         Megan Clark
**************************************************/

/* Drop the LRCH_DB database if it already exists /
/ ----------------------------------------------- */
DROP DATABASE IF EXISTS LRCH_DB; 
GO

/* Create the LRCH_DB database ------------------ /
/ ----------------------------------------------- */
CREATE DATABASE LRCH_DB;
GO

/* Use the new database as the default for future queries /
/ ------------------------------------------------------ */
USE LRCH_DB;
GO



/**************************************************
BILL
**************************************************/
DROP TABLE IF EXISTS BILL;

/**************************************************
TRANSACTIONS
**************************************************/
DROP TABLE IF EXISTS TRANSACTIONS;

/**************************************************
APPOINTMENT
**************************************************/
DROP TABLE IF EXISTS APPOINTMENT;

/**************************************************
ADMISSION
**************************************************/
DROP TABLE IF EXISTS ADMISSION;

/**************************************************
BED
**************************************************/
DROP TABLE IF EXISTS BED;

/**************************************************
ROOM
**************************************************/
DROP TABLE IF EXISTS ROOM;

/**************************************************
ITEM
**************************************************/
DROP TABLE IF EXISTS ITEM;

/**************************************************
COST_CENTRE
**************************************************/
DROP TABLE IF EXISTS COST_CENTRE;

/**************************************************
PRESCRIPTION
**************************************************/
DROP TABLE IF EXISTS PRESCRIPTION;

/**************************************************
PHYSICIAN
**************************************************/
DROP TABLE IF EXISTS PHYSICIAN;

/**************************************************
PATIENT
**************************************************/
DROP TABLE IF EXISTS PATIENT;

/**************************************************
Now, create the tables in the reverse order
**************************************************/

/**************************************************
PATIENT
**************************************************/
CREATE TABLE PATIENT (
    PATIENT_NO INT IDENTITY(10000, 1) PRIMARY KEY,
    PATIENT_FNAME VARCHAR(255) NOT NULL,
    PATIENT_LNAME VARCHAR(255) NOT NULL,
    PATIENT_SEX CHAR(1) NOT NULL CHECK (PATIENT_SEX IN ('F', 'M')),
    PATIENT_HCARD_NO CHAR(12), 
    PATIENT_FINANCIAL_STAT VARCHAR(255) NOT NULL,
    PATIENT_PHONE CHAR(10) NOT NULL,
    PATIENT_EMAIL VARCHAR(255) NOT NULL,
    PATIENT_ADDRESS VARCHAR(255) NOT NULL
);

/**************************************************
PHYSICIAN
**************************************************/
CREATE TABLE PHYSICIAN (
    PHYSICIAN_NO INT IDENTITY(1000, 1) PRIMARY KEY,
    PHYSICIAN_FNAME VARCHAR(255) NOT NULL,
    PHYSICIAN_LNAME VARCHAR(255) NOT NULL,
    PHYSICIAN_PHONE CHAR(10) NOT NULL,
    PHYSICIAN_EMAIL VARCHAR(255) NOT NULL,
    PHYSICIAN_SPECIALTY VARCHAR(255) NOT NULL,
    PHYSICIAN_ADDRESS VARCHAR(255) NOT NULL
);

/**************************************************
PRESCRIPTION
**************************************************/
CREATE TABLE PRESCRIPTION (
    PRESCRIPTION_NO INT IDENTITY(100000, 1) PRIMARY KEY,
    PHYSICIAN_NO INT NOT NULL FOREIGN KEY REFERENCES PHYSICIAN(PHYSICIAN_NO),
    PATIENT_NO INT NOT NULL FOREIGN KEY REFERENCES PATIENT(PATIENT_NO),
    PRESCRIPTION_MEDS VARCHAR(255) NOT NULL,
    PRESCRIPTION_NOTES VARCHAR(MAX)
);

/**************************************************
COST_CENTRE
**************************************************/
CREATE TABLE COST_CENTRE (
    COST_CENTRE_NO INT IDENTITY(100,100) PRIMARY KEY,
    COST_CENTRE_NAME VARCHAR(255) NOT NULL
);

/**************************************************
ITEM
**************************************************/
CREATE TABLE ITEM (
    ITEM_NO INT IDENTITY(1,1) PRIMARY KEY,
    COST_CENTRE_NO INT NOT NULL FOREIGN KEY REFERENCES COST_CENTRE(COST_CENTRE_NO),
    ITEM_DESC VARCHAR(255) NOT NULL,
    ITEM_COST DECIMAL(10, 2) NOT NULL
);

/**************************************************
ROOM
**************************************************/
CREATE TABLE ROOM (
    ROOM_NO CHAR(3) PRIMARY KEY,
    ITEM_NO INT NOT NULL FOREIGN KEY REFERENCES ITEM(ITEM_NO),
    ROOM_BED_COUNT INT NOT NULL,
    ROOM_EXT CHAR(3) NOT NULL
);

/**************************************************
BED
**************************************************/
CREATE TABLE BED (
    BED_LETTER CHAR(1) CHECK (BED_LETTER IN ('A', 'B', 'C', 'D')),
    ROOM_NO CHAR(3),
    FOREIGN KEY (ROOM_NO) REFERENCES ROOM(ROOM_NO),
    PRIMARY KEY (BED_LETTER, ROOM_NO)
);

/**************************************************
ADMISSION
**************************************************/
CREATE TABLE ADMISSION (
    ADMISSION_NO INT IDENTITY(1000000, 1) PRIMARY KEY,
    PHYSICIAN_NO INT NOT NULL FOREIGN KEY REFERENCES PHYSICIAN(PHYSICIAN_NO),
    PATIENT_NO INT NOT NULL FOREIGN KEY REFERENCES PATIENT(PATIENT_NO),
    BED_LETTER CHAR(1) NOT NULL,
    ROOM_NO CHAR(3) NOT NULL,
    ADMISSION_DATE DATE NOT NULL,
    DISCHARGE_DATE DATE,
    FOREIGN KEY (BED_LETTER, ROOM_NO) REFERENCES BED(BED_LETTER, ROOM_NO)
);

/**************************************************
APPOINTMENT
**************************************************/
CREATE TABLE APPOINTMENT (
    APPOINTMENT_NO INT IDENTITY(10000000, 1) PRIMARY KEY,
    PHYSICIAN_NO INT NOT NULL FOREIGN KEY REFERENCES PHYSICIAN(PHYSICIAN_NO),
    PATIENT_NO INT NOT NULL FOREIGN KEY REFERENCES PATIENT(PATIENT_NO),
	APPOINTMENT_TYPE VARCHAR(255),
    APPOINTMENT_DATETIME DATETIME NOT NULL,
    APPOINTMENT_NOTES VARCHAR(MAX)
);

/**************************************************
TRANSACTIONS
**************************************************/
CREATE TABLE TRANSACTIONS (
    TRANSACTIONS_NO INT IDENTITY(100000000, 1) PRIMARY KEY,
    PATIENT_NO INT NOT NULL FOREIGN KEY REFERENCES PATIENT(PATIENT_NO),
    ITEM_NO INT NOT NULL FOREIGN KEY REFERENCES ITEM(ITEM_NO),
    TRANSACTIONS_DATETIME DATETIME NOT NULL
);

/**************************************************
BILL
**************************************************/
CREATE TABLE BILL (
    BILL_NO INT IDENTITY(1000000000, 1) PRIMARY KEY,
    PATIENT_NO INT NOT NULL FOREIGN KEY REFERENCES PATIENT(PATIENT_NO),
    TRANSACTION_NO INT NOT NULL FOREIGN KEY REFERENCES TRANSACTIONS(TRANSACTIONS_NO)
);

/**************************************************
INSERT RANDOM DATA SCRIPT
**************************************************/



/**************************************************
PATIENT
**************************************************/

INSERT INTO PATIENT (PATIENT_FNAME, PATIENT_LNAME, PATIENT_SEX, PATIENT_HCARD_NO, PATIENT_FINANCIAL_STAT, PATIENT_PHONE, PATIENT_EMAIL, PATIENT_ADDRESS) VALUES
    ('John', 'Doe', 'M', '1234567890AB', 'self', '4165551234', 'john.doe@email.com', '123 Main St'),
    ('Jane', 'Smith', 'F', '9876543210CD', 'Assure', '9055555678', 'jane.smith@email.com', '456 Oak St'),
    ('Michael', 'Johnson', 'M', '5555555555EF', 'ESI', '6475558765', 'michael.johnson@email.com', '789 Pine St'),
    ('Emily', 'Williams', 'F', '7777777777GH', 'Blue Cross', '4165554321', 'emily.williams@email.com', '321 Maple St'),
    ('David', 'Miller', 'M', '1112233444IJ', 'Sunlife', '9055559876', 'david.miller@email.com', '555 Cedar St'),
    ('Emma', 'Taylor', 'F', '2223344555KL', 'self', '4165558765', 'emma.taylor@email.com', '789 Birch St'),
    ('Ryan', 'Anderson', 'M', '3334455666MN', 'Assure', '6475552345', 'ryan.anderson@email.com', '987 Pine St'),
    ('Olivia', 'Moore', 'F', '4445566777OP', 'ESI', '9055556789', 'olivia.moore@email.com', '654 Elm St'),
    ('Daniel', 'Brown', 'M', '5556677888QR', 'Blue Cross', '4165557890', 'daniel.brown@email.com', '321 Oak St'),
    ('Sophia', 'Davis', 'F', '6667788999ST', 'Sunlife', '6475551234', 'sophia.davis@email.com', '456 Maple St'),
    ('Ethan', 'White', 'M', '7778899000UV', 'self', '9055553456', 'ethan.white@email.com', '789 Cedar St'),
    ('Ava', 'Harris', 'F', '8889900011WX', 'Assure', '4165552345', 'ava.harris@email.com', '987 Pine St'),
    ('Mason', 'Jones', 'M', '9990011222YZ', 'ESI', '6475554567', 'mason.jones@email.com', '654 Elm St'),
    ('Chloe', 'Jackson', 'F', '1112233344AA', 'Blue Cross', '9055555678', 'chloe.jackson@email.com', '321 Oak St'),
    ('Liam', 'Martin', 'M', '2223344455BB', 'Sunlife', '4165556789', 'liam.martin@email.com', '456 Maple St'),
    ('Aria', 'Taylor', 'F', '3334455566CC', 'self', '6475557890', 'aria.taylor@email.com', '789 Cedar St'),
    ('Noah', 'Clark', 'M', '4445566677DD', 'Assure', '9055558901', 'noah.clark@email.com', '987 Pine St'),
    ('Isabella', 'Hall', 'F', '5556677788EE', 'ESI', '4165559012', 'isabella.hall@email.com', '654 Elm St'),
    ('James', 'Young', 'M', '6667788899FF', 'Blue Cross', '6475550123', 'james.young@email.com', '321 Oak St'),
    ('Grace', 'Wright', 'F', '7778899000GG', 'Sunlife', '9055551234', 'grace.wright@email.com', '456 Maple St'),
    ('Logan', 'Lewis', 'M', '8889900011HH', 'self', '4165552345', 'logan.lewis@email.com', '789 Cedar St'),
    ('Harper', 'Walker', 'F', '9990011222II', 'Assure', '6475553456', 'harper.walker@email.com', '987 Pine St'),
    ('Benjamin', 'Hill', 'M', '1112233344JJ', 'ESI', '9055554567', 'benjamin.hill@email.com', '654 Elm St'),
    ('Avery', 'Moore', 'F', '2223344455KK', 'Blue Cross', '4165555678', 'avery.moore@email.com', '321 Oak St'),
    ('Jackson', 'Baker', 'M', '3334455566LL', 'Sunlife', '6475556789', 'jackson.baker@email.com', '456 Maple St'),
    ('Scarlett', 'Barnes', 'F', '4445566677MM', 'self', '9055557890', 'scarlett.barnes@email.com', '789 Cedar St'),
    ('Carter', 'Fisher', 'M', '5556677788NN', 'Assure', '4165558901', 'carter.fisher@email.com', '987 Pine St'),
    ('Abigail', 'Reed', 'F', '6667788899OO', 'ESI', '6475559012', 'abigail.reed@email.com', '654 Elm St'),
    ('Henry', 'Cole', 'M', '7778899000PP', 'Blue Cross', '9055550123', 'henry.cole@email.com', '321 Oak St'),
    ('Lily', 'Bryant', 'F', '8889900011QQ', 'Sunlife', '4165551234', 'lily.bryant@email.com', '456 Maple St'),
    ('Owen', 'Hayes', 'M', '9990011222RR', 'self', '6475552345', 'owen.hayes@email.com', '789 Cedar St'),
    ('Ella', 'Cooper', 'F', '1112233344SS', 'Assure', '9055553456', 'ella.cooper@email.com', '987 Pine St'),
    ('Gabriel', 'Mitchell', 'M', '2223344455TT', 'ESI', '4165554567', 'gabriel.mitchell@email.com', '654 Elm St'),
    ('Aubrey', 'Griffin', 'F', '3334455566UU', 'Blue Cross', '6475555678', 'aubrey.griffin@email.com', '321 Oak St'),
    ('Lucas', 'Porter', 'M', '4445566677VV', 'Sunlife', '9055556789', 'lucas.porter@email.com', '456 Maple St'),
    ('Hannah', 'Lawrence', 'F', '5556677788WW', 'self', '4165557890', 'hannah.lawrence@email.com', '789 Cedar St'),
    ('Wyatt', 'Andrews', 'M', '6667788899XX', 'Assure', '6475558901', 'wyatt.andrews@email.com', '987 Pine St'),
	('Ada', 'Wong', 'F', '8742056193', 'self', '6471224563', 'awong@email.com', '150 Raccoon City');

GO

/**************************************************
PHYSICIAN
**************************************************/

INSERT INTO PHYSICIAN (PHYSICIAN_FNAME, PHYSICIAN_LNAME, PHYSICIAN_PHONE, PHYSICIAN_EMAIL, PHYSICIAN_SPECIALTY, PHYSICIAN_ADDRESS) VALUES
    ('James', 'Bryant', '2497660784', 'james.bryant@hospital.com', 'Ophthalmology', '15907 Anderson Manor, Ottawa, ON'),
    ('Joseph', 'Stewart', '2498824396', 'joseph.stewart@hospital.com', 'Pediatrics', '75591 Rebecca River, Vaughan, ON'),
    ('Chad', 'Bates', '6138011106', 'chad.bates@hospital.com', 'Pediatrics', '69245 Tristan Village, Mississauga, ON'),
    ('Steven', 'Gomez', '9052646086', 'steven.gomez@hospital.com', 'Neurology', '379 Elizabeth Fall Suite 829, Hamilton, ON'),
    ('Grant', 'Smith', '5197896135', 'grant.smith@hospital.com', 'Gastroenterology', '3831 Martin Plaza Suite 508, Vaughan, ON'),
    ('Tammy', 'Goodwin', '6133426846', 'tammy.goodwin@hospital.com', 'Gastroenterology', '9230 Charles Parkway, Ottawa, ON'),
    ('Rachel', 'Brown', '3651842737', 'rachel.brown@hospital.com', 'Orthopedics', '7068 Paul Lane Apt. 702, Vaughan, ON'),
    ('Elizabeth', 'Williamson', '8071453707', 'elizabeth.williamson@hospital.com', 'Psychiatry', '659 Camacho Divide Apt. 400, Vaughan, ON'),
    ('Mary', 'Ellison', '8079164995', 'mary.ellison@hospital.com', 'Gastroenterology', '9628 Scott Dam Apt. 324, Toronto, ON'),
    ('Steve', 'Munoz', '4378110642', 'steve.munoz@hospital.com', 'Gastroenterology', '5294 Guerrero Court, Mississauga, ON'),
	('Leon', 'Kennedy', '5239764977', 'lkenn@hospital.com', 'Neurology', '144 Raccoon City, Toronto, ON');

GO

/**************************************************
COST CENTRE
**************************************************/

INSERT INTO COST_CENTRE (COST_CENTRE_NAME) VALUES
    ('Room and Board'),
    ('Laboratory'),
    ('Radiology'),
    ('Nephrology'),
    ('Surgical'),
    ('Medical Consumables');

GO

/**************************************************
ITEM
**************************************************/

INSERT INTO ITEM (COST_CENTRE_NO, ITEM_DESC, ITEM_COST) VALUES
    (100, 'IC: Intensive Care', 300.00),
    (100, 'PR: Private', 250.00),
    (100, 'SP: Semi-Private', 200.00),
    (100, 'W3: Ward, 3 Beds', 150.00),
    (100, 'W4: Ward, 4 Beds', 100.00),
    (100, 'Television', 5.00),
    (100, 'Kleenex', 5.00),
    (200, 'Glucose', 200.00),
    (200, 'Culture', 175.00),
    (300, 'Chest X-Ray', 100.00),
    (300, 'Pelvic Ultrasound', 200.00),
    (400, '1 Hour Dialysis', 180.00),
    (400, '2 Hour Dialysis', 230.00),
    (500, 'Anesthesia', 1200.00),
    (500, 'Surgical Room', 300.00),
    (600, 'Scalpel', 40.00),
    (600, 'Lap Pads', 20.00);

GO

/**************************************************
ROOM
**************************************************/

INSERT INTO ROOM (ROOM_NO, ITEM_NO, ROOM_BED_COUNT, ROOM_EXT) VALUES
    -- PRIVATE ROOMS
	('100', 2, 1, '340'),
    ('101', 2, 1, '341'),
    ('102', 2, 1, '342'),
    ('103', 2, 1, '343'),
    ('104', 2, 1, '344'),
    ('105', 2, 1, '345'),
    ('106', 2, 1, '346'),
    ('107', 2, 1, '347'),
    ('108', 2, 1, '348'),
    ('109', 2, 1, '349'),
    ('110', 2, 1, '350'),
    ('111', 2, 1, '351'),
    ('112', 2, 1, '352'),
    ('113', 2, 1, '353'),
    ('114', 2, 1, '354'),
    ('115', 2, 1, '355'),

	-- SEMI-PRIVATE ROOMS
    ('200', 3, 2, '356'),
    ('201', 3, 2, '357'),
    ('202', 3, 2, '358'),
    ('203', 3, 2, '359'),
    ('204', 3, 2, '360'),
    ('205', 3, 2, '361'),
    ('206', 3, 2, '362'),
    ('207', 3, 2, '363'),
    ('208', 3, 2, '364'),
    ('209', 3, 2, '365'),

	-- WARD 3
	('300', 4, 3, '372'),
	('301', 4, 3, '373'),
	('302', 4, 3, '374'),
	('303', 4, 3, '375'),
	('304', 4, 3, '376'),
	('305', 4, 3, '377'),
	('306', 4, 3, '378'),
	('307', 4, 3, '379'),
	('308', 4, 3, '380'),

	-- WARD 4
	('400', 5, 4, '388'),
	('401', 5, 4, '389'),
	('402', 5, 4, '390'),
	('403', 5, 4, '391'),
	('404', 5, 4, '392'),
	('405', 5, 4, '393'),
	('406', 5, 4, '394'),
	('407', 5, 4, '395')
	;


GO

/**************************************************
BED
**************************************************/

INSERT INTO BED (BED_LETTER, ROOM_NO) VALUES

    -- PRIVATE ROOMS
    ('A', '100'),
    ('B', '101'),
    ('C', '102'),
    ('D', '103'),
    ('A', '104'),
    ('B', '105'),
    ('C', '106'),
    ('D', '107'),
    ('A', '108'),
    ('B', '109'),
    ('C', '110'),
    ('D', '111'),
    ('A', '112'),
    ('B', '113'),
    ('C', '114'),
	('D', '115'),

    -- SEMI-PRIVATE
    ('A', '200'),
	('B', '200'),
	('C', '201'),
    ('D', '201'),
	('A', '202'),
    ('B', '202'),
    ('C', '203'),
	('D', '203'),
    ('A', '204'),
	('B', '204'),
    ('C', '205'),
	('D', '205'),
    ('A', '206'),
	('B', '206'),
    ('C', '207'),
	('D', '207'),
    ('A', '208'),
	('B', '208'),
    ('C', '209'),
	('D', '209'),
    
    -- WARD 3
    ('A', '300'),
	('B', '300'),
	('C', '300'),
    ('D', '301'),
	('A', '301'),
	('B', '301'),
    ('C', '302'),
	('D', '302'),
	('A', '302'),
    ('B', '303'),
	('C', '303'),
	('D', '303'),
    ('A', '304'),
	('B', '304'),
	('C', '304'),
    ('D', '305'),
	('A', '305'),
	('B', '305'),
    ('C', '306'),
	('D', '306'),
	('A', '306'),
    ('B', '307'),
	('C', '307'),
	('D', '307'),
    ('A', '308'),
    ('B', '308'),
	('C', '308'),

	-- WARD 4
	('A', '400'),
	('B', '400'),
	('C', '400'),
	('D', '400'),
	('A', '401'),
	('B', '401'),
	('C', '401'),
	('D', '401'),
	('A', '402'),
	('B', '402'),
	('C', '402'),
	('D', '402'),
	('A', '403'),
	('B', '403'),
	('C', '403'),
	('D', '403'),
	('A', '404'),
	('B', '404'),
	('C', '404'),
	('D', '404'),
	('A', '405'),
	('B', '405'),
	('C', '405'),
	('D', '405'),
    ('A', '406'),
	('B', '406'),
	('C', '406'),
	('D', '406'),
    ('A', '407'),
	('B', '407'),
	('C', '407'),
	('D', '407')
	;


GO

/**************************************************
ADMISSION
**************************************************/

INSERT INTO ADMISSION (PHYSICIAN_NO, PATIENT_NO, BED_LETTER, ROOM_NO, ADMISSION_DATE, DISCHARGE_DATE) VALUES
    (1001, 10008, 'C', '106', '2023-01-01', '2023-01-10'),
    (1005, 10016, 'C', '209', '2023-02-02', '2023-02-15'),
    (1008, 10022, 'A', '301', '2023-03-03', NULL),
    (1002, 10006, 'D', '107', '2023-04-04', '2023-04-10'),
    (1009, 10030, 'D', '209', '2023-05-05', '2023-05-12'),
    (1000, 10004, 'C', '302', '2023-06-06', '2023-06-15'),
    (1010, 10037, 'A', '108', '2023-07-07', '2023-07-18'),
    (1004, 10012, 'C', '209', '2023-08-08', '2023-08-21'),
    (1007, 10019, 'C', '303', '2023-09-09', NULL),
    (1006, 10015, 'B', '113', '2023-10-10', NULL),
    (1008, 10021, 'C', '203', '2023-11-11', '2023-11-03'),
    (1001, 10007, 'C', '304', '2023-12-12', NULL),
    (1005, 10014, 'B', '105', '2024-01-13', NULL),
    (1000, 10003, 'C', '205', '2023-02-14', '2023-02-27'),
    (1009, 10029, 'A', '305', '2024-03-15', NULL),
    (1002, 10005, 'D', '305', '2023-04-16', '2023-04-10'),
    (1010, 10036, 'B', '305', '2024-05-17', NULL),
    (1004, 10011, 'C', '306', '2023-06-18', '2023-06-15'),
    (1007, 10018, 'D', '107', '2023-07-19', '2023-07-28'),
    (1006, 10013, 'C', '207', '2023-08-20', '2023-08-21'),
    (1008, 10020, 'B', '307', '2023-09-21', '2023-09-03'),
    (1001, 10009, 'A', '108', '2023-10-22', '2023-10-24'),
    (1005, 10017, 'B', '208', '2024-11-23', NULL),
    (1000, 10002, 'A', '400', '2023-12-25', '2023-12-28'),
    (1009, 10031, 'B', '400', '2023-12-25', NULL),
    (1003, 10010, 'C', '400', '2023-12-25', '2023-12-29'),
    (1006, 10018, 'D', '400', '2023-12-25', NULL),
    (1002, 10025, 'A', '401', '2023-12-25', '2023-12-30'),
    (1007, 10032, 'B', '401', '2023-12-25', NULL),
    (1000, 10014, 'C', '401', '2023-12-25', '2023-12-31'),
    (1010, 10027, 'D', '401', '2023-12-25', NULL);


GO

/**************************************************
APPOINTMENT
**************************************************/

INSERT INTO APPOINTMENT(PHYSICIAN_NO, PATIENT_NO, APPOINTMENT_TYPE, APPOINTMENT_DATETIME, APPOINTMENT_NOTES) VALUES
    (1010, 10027, 'Injured leg', '2023-12-25 09:00:00', 'Treated with...'),
    (1007, 10032, 'May fall', '2023-12-25 10:30:00', 'Treated with...'),
    (1006, 10018, 'Broken arm', '2023-12-25 11:15:00', 'Notes example'),
    (1009, 10031, 'Headache for a week', '2023-12-25 13:45:00', 'Treated with...'),
    (1005, 10017, 'Unidentified bleeding', '2024-06-23 08:30:00', ''),
    (1010, 10037, 'Stomach pain', '2023-07-07 14:00:00', 'Treated with...'),
    (1010, 10037, 'Bowel Obstruction', '2023-07-08 15:00:00', 'Treated with...'),

    (1001, 10008, 'Chest pain and bleeding', '2023-01-01 09:30:00', 'Notes example'),
    (1001, 10008, 'Low blood sugar', '2023-01-03 10:00:00', 'Notes example'),
    (1001, 10008, 'Low blood sugar', '2023-01-04 11:00:00', 'Notes example'),

    (1005, 10016, 'Abdominal pain', '2023-02-02 12:00:00', 'Notes example'),
    (1005, 10016, 'Colonoscopy', '2023-02-04 13:30:00', 'Notes example'),
    (1005, 10016, 'Bowel Surgery', '2023-02-07 14:45:00', 'Notes example'),
    (1005, 10016, 'Post-op check-in', '2023-02-08 16:00:00', 'Notes example'),
    (1005, 10016, 'Post-op check-in', '2023-02-10 17:15:00', 'Notes example'),
    (1005, 10016, 'Post-op check-in', '2023-02-11 08:00:00', 'Notes example'),
    (1005, 10016, 'Post-op check-in', '2023-02-12 09:00:00', 'Notes example');
GO

/**************************************************
TRANSACTIONS
**************************************************/

INSERT INTO TRANSACTIONS (PATIENT_NO, ITEM_NO, TRANSACTIONS_DATETIME) VALUES
    (10008, 2, '2023-01-01 08:00:00'),
    (10008, 6, '2023-01-01 09:15:00'),
    (10008, 2, '2023-01-02 10:30:00'),
    (10008, 6, '2023-01-02 11:45:00'),
    (10008, 8, '2023-01-02 13:00:00'),
    (10008, 10, '2023-01-02 14:15:00'),
    (10008, 2, '2023-01-03 15:30:00'),
    (10008, 6, '2023-01-03 16:45:00'),
    (10008, 8, '2023-01-03 18:00:00'),
    (10008, 2, '2023-01-04 08:00:00'),
    (10008, 6, '2023-01-04 09:15:00'),
    (10008, 8, '2023-01-04 10:30:00'),
    (10008, 8, '2023-01-04 11:45:00'),
    (10008, 2, '2023-01-05 13:00:00'),
    (10008, 6, '2023-01-05 14:15:00'),
    (10008, 8, '2023-01-05 15:30:00'),
    (10008, 2, '2023-01-06 16:45:00'),
    (10008, 6, '2023-01-06 18:00:00'),

    (10016, 3, '2023-02-02 08:00:00'),
    (10016, 7, '2023-02-02 09:15:00'),
    (10016, 3, '2023-02-03 10:30:00'),
    (10016, 3, '2023-02-04 11:45:00'),
    (10016, 3, '2023-02-05 13:00:00'),
    (10016, 3, '2023-02-06 14:15:00'),
    (10014, 15, '2023-02-07 15:30:00'),
    (10016, 3, '2023-02-07 16:45:00'),
    (10016, 15, '2023-02-07 18:00:00'),
    (10016, 16, '2023-02-07 08:00:00'),
    (10016, 17, '2023-02-07 09:15:00'),
    (10016, 17, '2023-02-07 10:30:00'),
    (10016, 17, '2023-02-07 11:45:00'),
    (10016, 3, '2023-02-08 13:00:00'),
    (10016, 17, '2023-02-08 14:15:00'),
    (10016, 17, '2023-02-07 15:30:00'),
    (10016, 3, '2023-02-09 16:45:00'),
    (10016, 17, '2023-02-09 18:00:00'),
    (10016, 3, '2023-02-10 08:00:00'),
    (10016, 17, '2023-02-10 09:15:00'),
    (10016, 7, '2023-02-10 10:30:00'),
    (10016, 3, '2023-02-11 11:45:00'),
    (10016, 17, '2023-02-11 13:00:00'),
    (10016, 3, '2023-02-12 14:15:00'),
    (10016, 6, '2023-02-12 15:30:00'),
    (10016, 3, '2023-02-13 16:45:00'),
    (10016, 6, '2023-02-13 18:00:00'),
    (10016, 3, '2023-02-14 08:00:00'),
    (10016, 6, '2023-02-14 09:15:00'),
    (10016, 3, '2023-02-15 10:30:00'),
    (10016, 6, '2023-02-15 11:45:00'),
    (10016, 7, '2023-02-15 13:00:00'),

    (10022, 4, '2023-03-03 14:15:00'),
    (10006, 2, '2023-04-04 15:30:00'),
    (10030, 3, '2023-05-05 16:45:00'),
    (10004, 4, '2023-06-06 18:00:00'),
    (10010, 5, '2023-12-25 08:00:00'),
    (10025, 5, '2023-12-25 09:15:00'),
    (10020, 4, '2023-09-21 10:30:00'),
    (10009, 2, '2023-10-22 11:45:00');
GO

/**************************************************
BILL
**************************************************/

INSERT INTO BILL (PATIENT_NO, TRANSACTION_NO) VALUES
	(10008, 100000000),
	(10016, 100000001),
	(10022, 100000002),
	(10006, 100000003),
	(10030, 100000004),
	(10004, 100000005),
	(10010, 100000006),
	(10025, 100000007);
GO
