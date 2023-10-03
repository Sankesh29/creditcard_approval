-- Creating database and two tables 

create database mandatory_project;
use mandatory_project;
create table credit_card1 as 
SELECT * FROM project_z.credit_card;

create table credit_card2
(
Ind_ID int,
label int
);
SELECT * FROM project_z.credit_card;

/*

LOAD DATA LOCAL INFILE 'D:\\Sankesh\\D A\\ODIN\\Capstone Project\\Project 1\\Dataset\\Credit_card_label.csv'
INTO TABLE credit_card2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

*/

SELECT * FROM credit_card1;
SELECT * FROM credit_card2;

-- Creating a new table to work on the project
CREATE TABLE credit AS
SELECT credit_card1.*, credit_card2.label
FROM credit_card1
JOIN credit_card2 
USING (Ind_ID);



/*
1.	Group the customers based on their income type and find the average of their annual income.(some missing values in annual income)
2.	Find the female owners of cars and property.(ALL OK)
3.	Find the male customers who are staying with their families.(All Ok)
4.	Please list the top five people having the highest income.(All ok)
5.	How many married people are having bad credit? (All ok)	
6.	What is the highest education level and what is the total count? (All ok)
7.	Between married males and females, who is having more bad credit? (All ok)
	
*/

-- Removing columns which are not needed for the project

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'credit';

ALTER TABLE credit
DROP  Housing_type ,DROP  Birthday_count, DROP Employed_days, DROP Mobile_phone,DROP Work_phone,DROP Phone,
DROP EMAIL_ID,DROP Type_Occupation;

select * from credit;
DESC credit;

-- replacing empty string with Null values
UPDATE credit
SET GENDER = NULL WHERE TRIM(GENDER) = '';

SELECT DISTINCT GENDER FROM credit;

UPDATE credit
SET Annual_income = NULL WHERE TRIM(Annual_income) = '';

SELECT DISTINCT Annual_income FROM credit;

-- changing data type of annual income from text to int 

ALTER TABLE credit
MODIFY COLUMN Annual_income INT;

-- checking missing values in Annual_income column , there are 23 rows as missing values
SELECT count(*) FROM credit
WHERE Annual_income IS NULL;

SELECT AVG(Annual_income) FROM credit ;
 
-- replacing missing values with mean 

UPDATE credit c
JOIN (
    SELECT AVG(Annual_income) AS avg_income
    FROM credit
) AS subquery
SET c.Annual_income = subquery.avg_income
WHERE c.Annual_income IS NULL;


-- checking missing values in GENDER column, There as 7 rows ehich does not have value in Gender column

SELECT count(*) FROM credit
WHERE GENDER IS NULL;

select count(Ind_ID) from credit;

-- Deleting the rows where Gender is missing
DELETE FROM credit WHERE GENDER IS NULL;


-- No. of rows
select count(Ind_ID) from credit;

-- No. of columns 
SELECT COUNT(*) AS column_count
FROM information_schema.columns
WHERE table_name = 'credit' AND table_schema = 'mandatory_project';


-- 1.	Group the customers based on their income type and find the average of their annual income.
Select AVG(Annual_income),Type_Income FROM credit
GROUP BY Type_Income;

-- 2.	Find the female owners of cars and property.
SELECT * FROM credit
WHERE GENDER='F' AND Propert_Owner='Y' AND Car_Owner='Y';

-- 3.	Find the male customers who are staying with their families.
SELECT * FROM credit
WHERE GENDER='M' AND Family_Members>1;

-- 4.	Please list the top five people having the highest income.
SELECT * FROM credit
ORDER BY Annual_income DESC
LIMIT 5;

-- 5.	How many married people are having bad credit? 
SELECT DISTINCT(Marital_status) FROM credit;

SELECT count(*) FROM credit
WHERE Marital_status IN ('Married','Civil marriage') and label=1;

-- There are 114 married people ('Married','Civil Marriage') who have bad credit

-- 6.	What is the highest education level and what is the total count?
SELECT DISTINCT(EDUCATION) FROM credit;

SELECT EDUCATION,COUNT(EDUCATION) FROM credit
GROUP BY EDUCATION;

-- Higher Education is the Highesr Education level with a count of 421.

-- 7.	Between married males and females, who is having more bad credit? (All ok)
SELECT GENDER,count(GENDER) FROM credit
WHERE label=1
GROUP BY GENDER;

-- The female customers have more bad credit than male customers

