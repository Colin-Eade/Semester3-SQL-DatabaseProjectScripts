/**************************************************
SQL QUERIES

Authors: Colin Eade
         Noelle Dacayo
         Megan Clark
**************************************************/

/**************************************************
PATIENT DISPLAY
Returns a table of a specific patient's data
**************************************************/
DECLARE @PATIENT_NO INT
SET @PATIENT_NO = 10008; -- PATIENT_NO input goes here

SELECT
    P.PATIENT_NO AS 'PATIENT-NO',
    P.PATIENT_FNAME + ' ' + P.PATIENT_LNAME AS 'PATIENT-NAME',
	P.PATIENT_ADDRESS AS 'ADDRESS',
	P.PATIENT_EMAIL AS 'EMAIL',
	STUFF(STUFF(P.PATIENT_PHONE, 4, 0, '-'), 8, 0, '-') AS 'TELEPHONE', -- Formats the Phone number with "-" in between the numbers
    P.PATIENT_SEX AS 'SEX',
    P.PATIENT_HCARD_NO AS 'HCN',
	A.ROOM_NO + A.BED_LETTER AS 'LOCATION',
	R.ROOM_EXT AS 'EXT',
	A.ADMISSION_DATE AS 'DATE-ADMITTED',
    P.PATIENT_FINANCIAL_STAT AS 'FINANCIAL-STATUS',
	A.DISCHARGE_DATE AS 'DISCHARGE-DATE'
FROM
    PATIENT P
LEFT JOIN 
	ADMISSION A ON P.PATIENT_NO = A.PATIENT_NO
LEFT JOIN 
	ROOM R ON A.ROOM_NO = R.ROOM_NO
WHERE P.PATIENT_NO = @PATIENT_NO
;
GO

/**************************************************
PHYSICIAN DISPLAY
Returns a table of a specific physician's data
**************************************************/
DECLARE @PHYSICIAN_NO INT
SET @PHYSICIAN_NO = 1001; -- PHYSICIAN_NO input goes here

SELECT
	PH.PHYSICIAN_NO AS 'PHYSICIAN-NO',
	PH.PHYSICIAN_FNAME + ' ' + PH.PHYSICIAN_LNAME AS 'PHYSICIAN-NAME',
	STUFF(STUFF(PH.PHYSICIAN_PHONE, 4, 0, '-'), 8, 0, '-') AS 'TELEPHONE', -- Formats the Phone number with "-" in between the numbers
	PH.PHYSICIAN_SPECIALTY AS 'SPECIALTY'
FROM
	PHYSICIAN PH
WHERE PH.PHYSICIAN_NO = @PHYSICIAN_NO
;
GO

/**************************************************
PHYSICIAN-PATIENT REPORT
Returns a table of all patient's admitted under a specific physician
**************************************************/
DECLARE @PHYSICIAN_NO INT
SET @PHYSICIAN_NO = 1001; -- PHYSICIAN_NO input goes here

SELECT 
	A.PATIENT_NO AS 'PATIENT-NO',
	P.PATIENT_LNAME + ', ' + P.PATIENT_FNAME AS 'PATIENT-NAME',
	A.ROOM_NO + A.BED_LETTER AS 'LOCATION',
	A.ADMISSION_DATE AS 'DATE-ADMITTED'
FROM
	ADMISSION A
JOIN 
	PATIENT P ON A.PATIENT_NO = P.PATIENT_NO
JOIN
	PHYSICIAN PH ON A.PHYSICIAN_NO = PH.PHYSICIAN_NO
WHERE PH.PHYSICIAN_NO = @PHYSICIAN_NO
;
GO

/**************************************************
PATIENT APPOINTMENT DETAILS REPORT
Returns a table of a specific patient's details for a specific physician
**************************************************/
DECLARE @PATIENT_NO INT = 10016; -- PATIENT_NO input goes here
DECLARE @PHYSICIAN_NO INT = 1005; -- PHYSICIAN_NO input goes here

SELECT
    AP.APPOINTMENT_NO AS 'APPOINTMENT-NO',
    AP.APPOINTMENT_TYPE AS 'TYPE',
    AP.APPOINTMENT_DATETIME 'DATE-AND-TIME',
    AP.APPOINTMENT_NOTES AS 'NOTES'
FROM 
    APPOINTMENT AP
JOIN 
    PATIENT P ON AP.PATIENT_NO = P.PATIENT_NO
JOIN 
    PHYSICIAN PHY ON AP.PHYSICIAN_NO = PHY.PHYSICIAN_NO
WHERE 
    AP.PATIENT_NO = @PATIENT_NO AND AP.PHYSICIAN_NO = @PHYSICIAN_NO
ORDER BY 
    AP.APPOINTMENT_DATETIME
;
GO

/**************************************************
PATIENT PRESCRIPTION DETAILS REPORT
Returns a table of a specific patient's prescription details for a specific physician
**************************************************/
DECLARE @PATIENT_NO INT = 10016; -- PATIENT_NO input goes here
DECLARE @PHYSICIAN_NO INT = 1005; -- PHYSICIAN_NO input goes here

SELECT
    PR.PRESCRIPTION_NO AS 'PRESCRIPTION-NO',
    PR.PRESCRIPTION_MEDS AS 'MEDICATION',
    PR.PRESCRIPTION_NOTES AS 'NOTES'
FROM 
    PRESCRIPTION PR
JOIN 
    PATIENT P ON PR.PATIENT_NO = P.PATIENT_NO
JOIN 
    PHYSICIAN PHY ON PR.PHYSICIAN_NO = PHY.PHYSICIAN_NO
WHERE 
    PR.PATIENT_NO = @PATIENT_NO AND PR.PHYSICIAN_NO = @PHYSICIAN_NO
ORDER BY 
    PR.PRESCRIPTION_NO
;
GO

/**************************************************
DAILY REVENUE REPORT
Returns a table of all transactions for a specific date
**************************************************/
DECLARE @DATE DATE
SET @DATE = '2023-02-07' -- Date for report goes here

SELECT
	P.PATIENT_NO AS 'PATIENT-NO',
	P.PATIENT_LNAME + ', ' + P.PATIENT_FNAME AS 'PATIENT-NAME',
	A.ROOM_NO + A.BED_LETTER AS 'LOCATION',
	P.PATIENT_FINANCIAL_STAT AS 'FIN-SOURCE',
	C.COST_CENTRE_NO AS 'COST-CENTRE',
	T.ITEM_NO AS 'ITEM-NO',
	I.ITEM_DESC AS 'DESC',
	I.ITEM_COST AS 'CHARGE'
FROM 
	TRANSACTIONS T
LEFT JOIN
	PATIENT P ON T.PATIENT_NO = P.PATIENT_NO
LEFT JOIN
	ADMISSION A ON P.PATIENT_NO = A.ADMISSION_NO
LEFT JOIN
	ITEM I ON T.ITEM_NO = I.ITEM_NO
LEFT JOIN
	COST_CENTRE C ON I.COST_CENTRE_NO = C.COST_CENTRE_NO
WHERE 
    CONVERT(DATE, T.TRANSACTIONS_DATETIME) = @DATE
;

SELECT 
	SUM(I.ITEM_COST) AS 'TOTAL'
FROM 
	TRANSACTIONS T
LEFT JOIN
	ITEM I ON T.ITEM_NO = I.ITEM_NO
WHERE
	CONVERT(DATE, TRANSACTIONS_DATETIME) = @DATE
;
GO

/**************************************************
ROOM UTILIZATION REPORT
Returns a table of all bed's currently being occupied by admitted patients
**************************************************/
SELECT
	A.ROOM_NO + A.BED_LETTER AS 'LOCATION',
	LEFT(I.ITEM_DESC, 2) AS 'TYPE', -- Gives first 2 characters
	A.PATIENT_NO AS 'PATIENT-NO',
	P.PATIENT_LNAME + ', ' + P.PATIENT_FNAME AS 'PATIENT-NAME',
	A.ADMISSION_DATE AS 'DATE-ADMITTED'
FROM 
	ADMISSION A
LEFT JOIN
	PATIENT P ON A.PATIENT_NO = P.PATIENT_NO
LEFT JOIN
	ROOM R ON A.ROOM_NO = R.ROOM_NO
LEFT JOIN 
	ITEM I ON R.ITEM_NO = I.ITEM_NO
WHERE 
	A.DISCHARGE_DATE IS NULL
ORDER BY 'LOCATION'
;
GO

/**************************************************
ALL ROOMS AND BEDS REPORT
Returns a table of all beds and rooms, showing admission details for occupied beds
**************************************************/
SELECT
    R.ROOM_NO + B.BED_LETTER AS 'LOCATION',
    LEFT(I.ITEM_DESC, 2) AS 'TYPE', -- Gives first 2 characters
    A.PATIENT_NO AS 'PATIENT-NO',
    P.PATIENT_LNAME + ', ' + P.PATIENT_FNAME AS 'PATIENT-NAME',
    A.ADMISSION_DATE AS 'DATE-ADMITTED'
FROM 
    BED B
LEFT JOIN
    ROOM R ON B.ROOM_NO = R.ROOM_NO
LEFT JOIN 
    ITEM I ON R.ITEM_NO = I.ITEM_NO
LEFT JOIN
    ADMISSION A ON R.ROOM_NO = A.ROOM_NO AND B.BED_LETTER = A.BED_LETTER AND A.DISCHARGE_DATE IS NULL
LEFT JOIN
    PATIENT P ON A.PATIENT_NO = P.PATIENT_NO
ORDER BY 'LOCATION';
GO

/**************************************************
OVERALL OCCUPANCY BY ROOM TYPE REPORT
Returns a table of overall occupancy by room type
**************************************************/
DECLARE @ROOM_TYPE VARCHAR(255)
SET @ROOM_TYPE = 'SP'; -- Room type by ITEM_DESC: IC, PR, SP, W3, W4

SELECT
    R.ROOM_NO + B.BED_LETTER AS 'LOCATION',
    LEFT(I.ITEM_DESC, 2) AS 'TYPE', -- Gives first 2 characters
    A.PATIENT_NO AS 'PATIENT-NO',
    P.PATIENT_LNAME + ', ' + P.PATIENT_FNAME AS 'PATIENT-NAME',
    A.ADMISSION_DATE AS 'DATE-ADMITTED'
FROM 
    BED B
LEFT JOIN
    ROOM R ON B.ROOM_NO = R.ROOM_NO
LEFT JOIN 
    ITEM I ON R.ITEM_NO = I.ITEM_NO
LEFT JOIN
    ADMISSION A ON R.ROOM_NO = A.ROOM_NO AND B.BED_LETTER = A.BED_LETTER AND A.DISCHARGE_DATE IS NULL
LEFT JOIN
    PATIENT P ON A.PATIENT_NO = P.PATIENT_NO
WHERE
    LEFT(I.ITEM_DESC, 2) = @ROOM_TYPE -- First 2 letters of ITEM_DESC
ORDER BY 'LOCATION';
GO

/**************************************************
ROOM DISCHARGING PATIENTS ON DATE REPORT
Returns a table of all rooms discharging a patient on a specific date
**************************************************/
DECLARE @DATE DATE
SET @DATE = '2023-01-10' -- Date for report goes here

SELECT
	A.ROOM_NO + A.BED_LETTER AS 'LOCATION',
	LEFT(I.ITEM_DESC, 2) AS 'TYPE', -- Gives first 2 characters
	A.PATIENT_NO AS 'PATIENT-NO',
	P.PATIENT_LNAME + ', ' + P.PATIENT_FNAME AS 'PATIENT-NAME',
	A.ADMISSION_DATE AS 'DATE-ADMITTED'
FROM 
	ADMISSION A
LEFT JOIN
	PATIENT P ON A.PATIENT_NO = P.PATIENT_NO
LEFT JOIN
	ROOM R ON A.ROOM_NO = R.ROOM_NO
LEFT JOIN 
	ITEM I ON R.ITEM_NO = I.ITEM_NO
WHERE 
	A.DISCHARGE_DATE = @DATE
ORDER BY 'LOCATION'
;
GO

/**************************************************
REVENUE ANALYSIS
Returns a table displaying revenue data for each cost centre
Displays total number of transactions toward a specific cost centre
Displays the total charges toward a specific cost centre
Displays sum of what charges were insured or uninsured
**************************************************/
SELECT
    C.COST_CENTRE_NO AS 'COST-CENTRE',
    C.COST_CENTRE_NAME AS 'NAME',
    (
        SELECT COUNT(T.ITEM_NO)
        FROM TRANSACTIONS T
        JOIN ITEM I ON T.ITEM_NO = I.ITEM_NO
        WHERE I.COST_CENTRE_NO = C.COST_CENTRE_NO
    ) AS 'NO-OF-TRANS',
    (
        SELECT SUM(I.ITEM_COST)
        FROM ITEM I
        JOIN TRANSACTIONS T ON I.ITEM_NO = T.ITEM_NO
        WHERE I.COST_CENTRE_NO = C.COST_CENTRE_NO
    ) AS 'TOTAL-CHARGES',
    (
        SELECT SUM(I.ITEM_COST)
        FROM TRANSACTIONS T
        JOIN ITEM I ON T.ITEM_NO = I.ITEM_NO
        JOIN PATIENT P ON T.PATIENT_NO = P.PATIENT_NO
        WHERE I.COST_CENTRE_NO = C.COST_CENTRE_NO AND P.PATIENT_FINANCIAL_STAT <> 'self'
    ) AS 'INSURED',
    (
        SELECT SUM(I.ITEM_COST)
        FROM TRANSACTIONS T
        JOIN ITEM I ON T.ITEM_NO = I.ITEM_NO
        JOIN PATIENT P ON T.PATIENT_NO = P.PATIENT_NO
        WHERE I.COST_CENTRE_NO = C.COST_CENTRE_NO AND P.PATIENT_FINANCIAL_STAT = 'self'
    ) AS 'SELF-PAY'
FROM 
    COST_CENTRE C
;
GO

/**************************************************
PATIENT BILL
Returns a table of all the charges to a patient and the total of the charges
**************************************************/
DECLARE @PATIENT_NO INT
SET @PATIENT_NO = 10008 -- PATIENT_NO input goes here

SELECT 
	C.COST_CENTRE_NO AS 'COST_CENTRE',
	C.COST_CENTRE_NAME AS 'NAME',
	CONVERT(DATE, T.TRANSACTIONS_DATETIME) AS 'DATE_CHARGED',
	I.ITEM_NO AS 'ITEM-NO',
	I.ITEM_DESC AS 'ITEM-DESC',
	I.ITEM_COST AS 'CHARGE'
FROM 
	TRANSACTIONS T
JOIN 
	ITEM I ON T.ITEM_NO = I.ITEM_NO
JOIN
	COST_CENTRE C ON C.COST_CENTRE_NO = I.COST_CENTRE_NO
JOIN
	PATIENT P ON T.PATIENT_NO = P.PATIENT_NO
WHERE 
	P.PATIENT_NO = @PATIENT_NO
ORDER BY 
	C.COST_CENTRE_NO
;

SELECT
	SUM(I.ITEM_COST) AS 'TOTAL-CHARGE'
FROM 
	TRANSACTIONS T
JOIN 
	ITEM I ON T.ITEM_NO = I.ITEM_NO
WHERE 
	T.PATIENT_NO = @PATIENT_NO
;
GO
