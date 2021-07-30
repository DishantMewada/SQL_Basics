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

SELECT 'first_name'
FROM people; -- has different meaning

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
-- LIKE '.%.'

-- Q. show me all the records whose state_code starts with the letter 'C'
SELECT *
FROM people
WHERE state_code LIKE 'C%';

-- Q. look at the company names that end in 'LLC'
SELECT *
FROM people
WHERE company LIKE '%LLC';

-- LIMIT 

SELECT *
FROM people
LIMIT 10;

SELECT *
FROM people
LIMIT 10 OFFSET 5;  -- OFFSET skips first 5 records 

-- ORDER BY field1, field2, ..
SELECT first_name,last_name
FROM people
ORDER BY first_name;

SELECT first_name,last_name
FROM people
ORDER BY first_name ASC; -- ASC is default

SELECT first_name,last_name
FROM people
ORDER BY first_name DESC; 

SELECT state_code, first_name,last_name
FROM people
ORDER BY state_code, first_name;

SELECT quiz_points
FROM people
ORDER BY quiz_points DESC; -- DESC gives latest timestamp


----
SELECT first_name, LENGTH(first_name)
FROM people;

SELECT DISTINCT(first_name)
FROM people
ORDER BY first_name;

-- Q. how many people from California
SELECT COUNT(*)
FROM people
WHERE state_code = 'CA';

SELECT COUNT(state_code)
FROM people
WHERE state_code = 'CA';

-- JOINs

SELECT * 
FROM people
JOIN states;

SELECT first_name, last_name, people.state_code, states.division 
FROM people
JOIN states
ON people.state_code = states.state_abbrev;

SELECT *
FROM people
JOIN states
ON people.state_code = states.state_abbrev
WHERE people.first_name LIKE 'J%' AND states.region = 'South';

SELECT ppl.first_name, st.state_name 
FROM people ppl, states st 
WHERE ppl.state_code=st.state_abbrev;

-- Q. give full states of the participants
SELECT people.first_name, people.last_name, people.state_code, states.state_name 
FROM states 
LEFT JOIN people 
ON people.state_code=states.state_abbrev; 
-- gives NULL, since left join gives everything from left table 
-- and makes null record if not found in the right table

SELECT people.first_name, people.last_name, people.state_code, states.state_name 
FROM people 
LEFT JOIN states
ON people.state_code=states.state_abbrev
ORDER BY people.first_name;
--OR
SELECT people.first_name, people.last_name, people.state_code, states.state_name 
FROM states 
LEFT JOIN people 
ON people.state_code=states.state_abbrev
WHERE people.state_code IS NOT NULL
ORDER BY people.first_name;

-- Q. find states where participants are not present
SELECT states.state_name 
FROM states 
LEFT JOIN people 
ON people.state_code=states.state_abbrev
WHERE people.state_code IS NULL;

-- GROUP BY
SELECT first_name, COUNT(first_name) 
FROM people 
GROUP BY first_name;

-- Q. which 3 states have the most participants
SELECT pl.state_code, st.state_name, COUNT(pl.state_code)
FROM people pl
LEFT JOIN states st
ON pl.state_code=st.state_abbrev
GROUP BY pl.state_code
ORDER BY COUNT(pl.state_code) DESC
LIMIT 3;

-- Q. which 3 states have the least participants
SELECT pl.state_code, st.state_name, COUNT(pl.state_code)
FROM people pl
LEFT JOIN states st
ON pl.state_code=st.state_abbrev
GROUP BY pl.state_code
ORDER BY COUNT(pl.state_code) ASC
LIMIT 3;

-- Q. which states have no participants
SELECT pl.state_code, st.state_name
FROM states st
LEFT JOIN people pl
ON pl.state_code=st.state_abbrev
WHERE pl.state_code IS NULL; 
-- everything from states table and joining it to peoples table

-- Q. How many states are there in which participants are present
SELECT COUNT(DISTINCT(state_code)) as number_of_states
FROM people;

-- Q. give statewise overall score
SELECT state_code, SUM(quiz_points) as total
FROM people 
GROUP BY state_code 
ORDER BY total DESC;
--OR
SELECT pl.state_code, st.state_name, SUM(pl.quiz_points) as total
FROM people pl
LEFT JOIN states st
ON pl.state_code=st.state_abbrev
GROUP BY pl.state_code 
ORDER BY total DESC;

-- Q. give statewise average score

SELECT pl.state_code, st.state_name, AVG(pl.quiz_points) as total
FROM people pl
LEFT JOIN states st
ON pl.state_code=st.state_abbrev
GROUP BY pl.state_code 
ORDER BY total DESC;

-- Q. give average total of states
SELECT AVG(total) AS average 
FROM (SELECT state_code, SUM(quiz_points) AS total 
      FROM people GROUP BY state_code) A;
	  
-- Q. how many hats are needed for each states	  
SELECT state_code, COUNT(shirt_or_hat)
FROM people
WHERE shirt_or_hat = 'hat'
GROUP BY state_code
ORDER BY COUNT(shirt_or_hat) DESC;

SELECT pl.state_code, st.state_name, COUNT(shirt_or_hat)
FROM people pl
JOIN states st
ON pl.state_code=st.state_abbrev
WHERE pl.shirt_or_hat = 'hat'
GROUP BY  st.state_name
ORDER BY COUNT(pl.shirt_or_hat) DESC;

-- Q. show how many members of each team are in each geographic division
SELECT states.division, people.team, count(people.team) 
FROM states
JOIN people ON states.state_abbrev=people.state_code 
GROUP BY states.division, people.team;
