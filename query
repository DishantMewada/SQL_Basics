/*
DATABASE -> collection of information (TABLES),
usually involving relationships between the data
stored in it

TABLES -> ROW (RECORDS) + COLUMNS (FIELDS)
can have specific relationships to each other

SQL -> Strucutred Query Language
Lets us formulate questions a database can respond to.
SQL statements ->
*whitespace independent
*statements are composed of clauses (starting with keyword)

DUAL ROLE OF SQL ->
1. as a DML (Data Manipulation Language) 
*Edit data in the DATABASE
*CRUD records (create, read, update, delete)
2. as a DDL (Data Definition Language)
*Edit the structure (schema) of the DATABASE
*Add, Change, or remove fields or tables

*/


-- order of the clauses is important --

-- R -> Read



SELECT first_name 
FROM people;

SELECT first_name,last_name
FROM people;

SELECT * 
FROM people;

-- Conditions

SELECT * 
FROM people
WHERE state_code = 'CA';

SELECT * 
FROM people
WHERE state_code = 'CA' AND shirt_or_hat IS 'shirt';

-- = IS
-- != IS NOT <>

SELECT first_name, last_name, team
FROM people
WHERE state_code = 'CA' AND shirt_or_hat = 'shirt' AND team IS NOT 'Angry Ants';

-- Q. people from california or colorado wearing a shirt 

SELECT shirt_or_hat, state_code, first_name, last_name 
FROM people
WHERE state_code = 'CA' OR state_code = 'CO' AND shirt_or_hat = 'shirt';

-- will give wrong results since
-- A OR B AND C --> A OR ( B AND C )

SELECT shirt_or_hat, state_code, first_name, last_name 
FROM people
WHERE (state_code = 'CA' OR state_code = 'CO') AND shirt_or_hat = 'shirt';

-- LIKE '%..'
-- LIKE '..%'
-- LIKE '%.%'

-- Q. show me all the records whose state_code starts with the letter 'C'
SELECT *
FROM people
WHERE state_code LIKE 'C%';

