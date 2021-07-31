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


-- Q. report signup date from 01 to 15
SELECT first_name, last_name, signup
FROM people
WHERE signup >= '2021-01-01' AND signup <= '2021-01-15';

SELECT first_name, last_name, signup
FROM people
WHERE signup BETWEEN '2021-01-01' AND '2021-01-15';

-- Q. report signup date 09

SELECT first_name, last_name, signup
FROM people
WHERE signup LIKE '___%-__%-09%';

-- Q. combine first_name.last_name and attach @gmail.com to it
SELECT ( first_name|| '.' || last_name || '@gmail.com') as email_id FROM people;

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

/*
SQL Data Types - 
1. Binary types
- store short binary sequences like 10010
- store long binary sequences like files
2. Date and time types
- store a value that should be treated as date/time data 
(like 2010-04-05 or 2010-04-07-17:35:00)
3. Number types
- store values as integers of various lengths, floating point numbers and so on
4. Text types
- store values intended to be used as text strings (usually VARCHAR)
- fixed or variable numbers of characters
5. Boolean types
- stores a true or false value
6. Null 
- represents a field having no value in it whatsoever


*/

-- MATHs using sql 
-- math is limited in sql, so its a good idea to handle it with application language than sql
SELECT 4+2;
SELECT 1/3; -- 0
SELECT 1/3.0; -- 0.333333333333333
SELECT 3>2; -- 1
SELECT 3<2; -- 0
SELECT 3=3; -- 1
SELECT 4!=3; -- 1

-- Q. find the participants with quiz score more than 70
SELECT first_name, last_name, quiz_points
FROM people
WHERE quiz_points > 70
ORDER BY first_name; -- doesnt include 70, use >= for that

-- Q. find max and min score
SELECT MAX(quiz_points), MIN(quiz_points)
FROM people;

-- Q. build a report of number of people in each team, total number of points earned and average of each team
SELECT team, COUNT(*) as number_of_members, SUM(quiz_points) as points_totals, AVG(quiz_points) as average
FROM people 
GROUP BY team;

-- SUBQUERY

-- Q. find the participants with max quiz_points
-- SELECT first_name, last_name, quiz_points 
-- FROM people 
-- WHERE quiz_points=MAX(quiz_points); -- improper where clause, same variable doesn't work on equality condition in sql

-- first find the max quiz points
SELECT MAX(quiz_points) 
FROM people;
-- and then pass it to the main query 
SELECT first_name, last_name, quiz_points 
FROM people 
WHERE quiz_points=(SELECT MAX(quiz_points) 
				   FROM people);
			
-- Q. find all of the participants from minnesota when you dont know the state_code
-- hint: states table have state_name and state_abbrev

SELECT * FROM people
INNER JOIN states
ON people.state_code = states.state_abbrev
WHERE states.state_name = 'Minnesota';

SELECT * FROM people
WHERE state_code = (SELECT state_abbrev 
                    FROM states
                    WHERE state_name = 'Minnesota');

-- Q. find the two youngest people 
SELECT first_name, last_name, age FROM people
WHERE age >= (SELECT DISTINCT(MIN(age)) as youngest
FROM people) ORDER BY age LIMIT 2;

-- Q. find the two youngest age group
-- To find the minimum age 
SELECT MIN(age) as minimum
FROM people; -- gives 18

-- To find the second minimum age
SELECT MIN(age) as second_minimum
FROM people
WHERE age NOT IN (SELECT MIN(age) as minimum
				  FROM people);  -- gives 19
				   
-- combining query
SELECT first_name, last_name, age 
FROM people 
WHERE age IN(SELECT MIN(age) AS second_minimum 
             FROM people
             WHERE age NOT IN (SELECT MIN(age) as minimum 
			                   FROM people)) 
				   OR
      age IN(SELECT MIN(age) as minimum 
	         FROM people) 
	  ORDER BY age;

-- Q. report top three members of each team
SELECT team, quiz_points 
    FROM (
        SELECT team,quiz_points, Rank() 
          over (Partition BY team
                ORDER BY quiz_points DESC ) AS Rank
        FROM people
        ) rs WHERE Rank <= 3;

-- Transforming data 
SELECT LOWER(first_name), UPPER(last_name) 
FROM people;

-- Q. give first 5 character of the last_name field
SELECT LOWER(first_name), SUBSTR(last_name, 1, 5) 
FROM people;

-- Q.skip first 2 characters of the last_name field
SELECT LOWER(first_name), SUBSTR(last_name, 3) 
FROM people;

-- Q.give last 2 characters of the last_name field
SELECT LOWER(first_name), SUBSTR(last_name, -2) 
FROM people;

-- Q. replace 'a' to '-' in the first_name field
SELECT REPLACE(first_name, 'a', '-') 
FROM people;

-- Q. CASTING a date to character
SELECT quiz_points 
FROM people 
ORDER BY CAST(quiz_points AS CHAR); -- starts with 100

SELECT quiz_points 
FROM people 
ORDER BY quiz_points; -- starts with 63

SELECT MAX(CAST(quiz_points AS CHAR)) FROM people; -- gives 99 since 9 is bigger than 1 as a string

SELECT MAX(CAST(quiz_points AS INT)) FROM people; -- gives 100


-- Q. report max score and average score for each state

SELECT st.state_name, MAX(quiz_points) AS max_score, ROUND(AVG(quiz_points),3) AS average_score 
FROM people pl
LEFT JOIN states st
ON pl.state_code = st.state_abbrev
GROUP BY pl.state_code
ORDER BY average_score DESC;
 
-- CASEs

-- Q. report the total count of hats and shirts needed
SELECT 

SUM(CASE 
	WHEN shirt_or_hat = 'shirt' THEN 1
	ELSE 0
END) AS shirt_count,

SUM(CASE 
	WHEN shirt_or_hat = 'hat' THEN 1
	ELSE 0
END) AS hat_count

FROM people; 

--OR
SELECT shirt_or_hat, COUNT(shirt_or_hat) AS count
FROM people 
GROUP BY shirt_or_hat;

-- INSERT INTO a table
INSERT INTO people 
(first_name) 
VALUES 
('Bob'); -- every other fields will be null since not provided

INSERT INTO people 
(first_name, last_name, state_code, city, shirt_or_hat)
VALUES 
('Mary', 'Hamilton', 'OR', 'Portland', 'hat');

INSERT INTO people 
(first_name, last_name) 
VALUES 
('George', 'White'), 
('Jenn', 'Smith'), 
('Carol', NULL);

-- UPDATE a record in the table 
/* UPDATE table 
   SET field1 = value1, field2 = value2
   WHERE condition;
If you skip the where clause the update will apply to the entire table, BEWARE
*/

-- Q. Carlos Morrison entered his last_name incorrectly, update it
-- UPDATE people SET last_name = 'Morrison' WHERE first_name='Carlos';
-- is not proper since we can have many Carlos
SELECT last_name FROM people WHERE first_name='Carlos';

SELECT last_name 
FROM people 
WHERE first_name='Carlos' AND city='Houston';

UPDATE people 
SET last_name='Morrison' 
WHERE first_name='Carlos' AND city='Houston';

-- even better way is to use primary key like id_number
SELECT * 
FROM people 
WHERE id_number=175;

UPDATE people 
SET last_name='Morrison' 
WHERE id_number=175;

-- fisher LLC is bought by megacorp inc
SELECT * FROM people WHERE company='Fisher LLC';

UPDATE people SET company='Megacorp Inc' WHERE company='Fisher LLC';

SELECT * FROM people WHERE company='Megacorp Inc';

-- DELETE record/s from the table

-- DELETE FROM people;    --> BEWARE deletes all row from the table

SELECT * from people;

-- remove inserted records by INSERT INTO query - 'Bob'
SELECT * FROM people WHERE id_number=1001;

DELETE FROM people WHERE id_number=1001;

-- Q. remove empty quiz points entries
SELECT * FROM people WHERE quiz_points IS NULL; -- dont use = NULL

DELETE FROM people WHERE quiz_points IS NULL;

--------------------------
INSERT INTO people 
(first_name, last_name, quiz_points, team, city, state_code, shirt_or_hat, signup) 
VALUES 
('St. John','Walter',93,'Baffled Badgers','Buffalo','NY','hat', '2021-01-29'),
('Chou','Emerald',92,'Angry Ants','Topeka','KS','shirt','2021-01-29'); 

SELECT * FROM people where first_name IN ('St. John','Chou') AND last_name IN ('Walter','Emerald');


SELECT * FROM people WHERE first_name = 'Bonnie' AND last_name = 'Brooks';

UPDATE people
SET shirt_or_hat = 'shirt'
WHERE first_name = 'Bonnie' AND last_name = 'Brooks';

SELECT * FROM people WHERE first_name = 'Lois' AND last_name = 'Hart';

DELETE FROM people WHERE first_name = 'Lois' AND last_name = 'Hart';

