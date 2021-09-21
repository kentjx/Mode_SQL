SELECT * 
FROM mode..apple

SELECT * 
FROM mode..crunchbase_acquisition

SELECT * 
FROM mode..crunchbase_company

SELECT * 
FROM mode..crunchbase_investment_part1

SELECT * 
FROM mode..crunchbase_investment_part2 

SELECT *
FROM mode..football_players

SELECT * 
FROM mode..football_teams

-- Write a query to count the number of non-null rows in the low column. #apple

SELECT COUNT(low) AS LowCount
FROM mode..apple 
WHERE low IS NOT NULL 

-- Write a query that determines counts of every single column. Which column has the most null values? #apple 
SELECT COUNT(date) AS datecount,
COUNT(year) AS yearcount,
COUNT(month) AS monthcount,
COUNT("open") AS opencount, 
COUNT("high") AS highcount,
COUNT("low") AS lowcount,
COUNT("close") AS closecount, 
COUNT(volume) AS volumecount,
COUNT(id) AS idcount
FROM mode..apple  
-- Write a query to calculate the average opening price (hint: you will need to use both COUNT and SUM, as well as some simple arithmetic.) #apple
SELECT SUM("open") / Count("open") AS avg_open
FROM mode..apple

-- What was Apple's lowest stock price (at the time of this data collection)? #apple

SELECT MIN(low) AS Min_low
FROM mode..apple

-- Write an SQL query to determine the nth (say n=5) highest open price from a table.

SELECT TOP 1 "open"
FROM
(
SELECT DISTINCT TOP 5 "open"
FROM mode..apple 
ORDER BY "open" DESC
) as alias
ORDER BY "open" ASC;


-- What was the highest single-day increase in Apple's share value? #apple 
SELECT MAX("open" - "close") AS Highest_single_day_increase
FROM mode..apple

-- Write a query that calculates the average daily trade volume for Apple stock. #apple

SELECT AVG(volume) AS average_vol
FROM MODE..apple

-- Calculate the total number of shares traded each month. Order your results chronologically. #apple

SELECT year, month, SUM(volume) AS Sum_of_vol
FROM mode..apple
GROUP BY year, month 
ORDER BY year, month

-- Write a query to calculate the average daily price change in Apple stock, grouped by year. #apple 

SELECT year, AVG("open" - "close") AS avg_daily_price_change 
FROM mode..apple 
GROUP BY year
ORDER BY year 

-- Write a query that calculates the lowest and highest prices that Apple stock achieved each month. # apple

SELECT year, month, min("low") as min_low, max("high") as max_high
FROM mode..apple
GROUP BY year, month 
ORDER by year, month
 
-- Write a query that includes a column that is flagged "yes" when a player is from California, and sort the results with those players first.
-- #footbll 

SELECT *, 
CASE WHEN "state" = 'CA' THEN 'yes'
ELSE NULL END AS California_or_not 
FROM mode..football_players
ORDER BY California_or_not DESC

-- Write a query that includes players' names and a column that classifies them into four categories based on height. 
-- Keep in mind that the answer we provide is only one of many possible answers, since you could divide players' heights in many ways.
-- #football 

SELECT *, 
CASE WHEN height > 75 THEN 'Very Tall' 
WHEN height > 72 AND height <= 75 THEN 'Tall' 
WHEN height > 69 AND height <= 72 THEN 'Moderate' 
ELSE 'Short' END AS Height_catergory 
FROM mode..football_players


-- Write a query that selects all columns from benn.college_football_players and adds an additional column that displays the player's name if that player is a junior or senior.
-- #football 

SELECT *, 
CASE WHEN "year" IN ('JR', 'SR') THEN "player_name" 
ELSE NULL END AS SR_JR_name
FROM mode..football_players

-- Write a query that counts the number of 300lb+ players for each of the following regions: West Coast (CA, OR, WA), Texas, and Other (Everywhere else).
-- #football condition 1: weight > 300 condition 2: texas, CA, OR, WA and others 
SELECT COUNT(*)
FROM mode..football_players
WHERE "weight" > 300 
AND 
"state" IN ('CA', 'OR','WA', 'TX', '--')


-- Write a query that calculates the combined weight of all underclass players (FR/SO) in California as well as the combined weight of all upperclass players (JR/SR) in California.
-- #football 

SELECT "CLASS", 
SUM("weight") AS Total_weight
FROM
(
SELECT *,
	CASE WHEN "year" = 'FR' OR "year" = 'SO' THEN 'lower_class'
	ELSE 'upper class' END AS CLASS
	FROM mode..football_players
	WHERE state = 'CA'
) as alias
GROUP BY "CLASS"


-- Write a query that displays GROUP BY year the number of players in each state, with FR, SO, JR, and SR players in separate columns and another column for the total number of players. Order results such that states with the most players come first.
-- #football 


--- USE SUBQUERY --- To sum Horizontally
SELECT *, (FR_COUNT + SO_COUNT + JR_COUNT + SR_COUNT) AS Total_COUNT
FROM
(
SELECT "state",
SUM(CASE WHEN "year" = 'FR' THEN 1 
ELSE NULL END) AS FR_COUNT,
SUM(CASE WHEN "year" = 'SO' THEN 1 
ELSE NULL END) AS SO_COUNT,
SUM(CASE WHEN "year" = 'JR' THEN 1 
ELSE NULL END) AS JR_COUNT, 
SUM(CASE WHEN "year" = 'SR' THEN 1 
ELSE NULL END) AS SR_COUNT
FROM mode..football_players
GROUP BY "STATE"
) as alias
ORDER BY Total_COUNT DESC

----- Another Method-----------
SELECT state,
       COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(state) AS total_players
FROM mode..football_players
GROUP BY state
ORDER BY total_players DESC


-- Write a query that shows the number of players at schools with names that start with A through M, and the number at schools with names starting with N - Z.
-- #football 

SELECT
SUM(CASE WHEN school_name < 'N' THEN 1 
ELSE NULL END) AS A_M_count,
SUM(CASE WHEN school_name >= 'N' THEN 1 
ELSE NULL END) AS N_Z_count
FROM mode..football_players

-- Write a query that returns the unique values in the year column, in chronological order.
-- #football

SELECT DISTINCT "year"
FROM mode..football_players
ORDER BY "year" ASC

-- Write a query that counts the number of unique values in the month column for each year.
--#apple 

SELECT "year", COUNT(DISTINCT "month") AS Month_count
FROM mode..apple
GROUP BY "year"
ORDER BY "year" ASC

-- Write a query that separately counts the number of unique values in the month column and the number of unique values in the `year` column.
-- #apple 

SELECT COUNT(DISTINCT "year") As years_count, COUNT(DISTINCT "month") months_count
FROM mode..apple

-- Write a query that selects the school name, player name, position, and weight for every player in Georgia, ordered by weight (heaviest to lightest). Be sure to make an alias for the table, and to reference all column names in relation to the alias.
-- #football 

SELECT p.school_name, 
p.player_name, 
p.position, 
p.weight 
FROM mode..football_players p
WHERE state = 'GA'
ORDER BY p.WEIGHT DESC

-- Write a query that displays player names, school names and conferences for schools in the "FBS (Division I-A Teams)" division.
--#football 

SELECT p.player_name, p.school_name, t.conference
FROM mode..football_players p
JOIN mode..football_teams t 
ON p.school_name = t.school_name 
WHERE division = 'FBS (Division I-A Teams)'


-- Write a query that performs an inner join between the tutorial.crunchbase_acquisitions table and the tutorial.crunchbase_companies table, but instead of listing individual rows, count the number of non-null rows in each table.
--crunchbase 
SELECT COUNT(c.permalink) AS c_rowcount,
COUNT(a.company_permalink) AS a_rowcount
FROM mode..crunchbase_acquisition a 
JOIN mode..crunchbase_company c 
ON a.company_permalink = c.permalink 

-- Modify the query above to be a LEFT JOIN. Note the difference in results. 
-- #crunchbase 

SELECT COUNT(c.permalink) AS c_rowcount,
COUNT(a.company_permalink) AS a_rowcount
FROM mode..crunchbase_acquisition a 
LEFT JOIN mode..crunchbase_company c 
ON a.company_permalink = c.permalink 

-- Count the number of unique companies (don't double-count companies) and unique acquired companies by state. Do not include results for which there is no state data, and order by the number of acquired companies from highest to lowest.
-- #crunchbase

SELECT c.state_code, 
COUNT(DISTINCT c.permalink) AS unique_companies,
COUNT(DISTINCT a.company_permalink) AS unique_accquired
FROM mode..crunchbase_company c 
LEFT JOIN mode..crunchbase_acquisition a
ON c.permalink = a.company_permalink 
WHERE c.state_code IS NOT NULL
GROUP BY c.state_code
ORDER BY unique_accquired DESC

-- Write a query that shows a company's name, "status" (found in the Companies table), and the number of unique investors in that company. Order by the number of investors from most to fewest. Limit to only companies in the state of New York.
-- #crunchbase

SELECT c.name AS company_name,
c.status,
COUNT(DISTINCT i.investor_name) AS unique_investors
FROM mode..crunchbase_company c
LEFT JOIN mode..crunchbase_investment_part1 i
ON c.permalink = i.company_permalink
WHERE c.state_code = 'NY'
GROUP BY c.name, c.status 
ORDER BY unique_investors DESC

SELECT c.name AS company_name,
c.status,
COUNT(DISTINCT i.investor_name) AS unique_investors
FROM mode..crunchbase_company c
LEFT JOIN mode..crunchbase_investment_part2 i
ON c.permalink = i.company_permalink
WHERE c.state_code = 'NY'
GROUP BY c.name, c.status 
ORDER BY unique_investors DESC

--Write a query that lists investors based on the number of companies in which they are invested. Include a row for companies with no investor, and order from most companies to least.
-- #crunchbase 

SELECT 
CASE WHEN i.investor_name IS NULL THEN 'No Investors'
ELSE i.investor_name END AS investor,
COUNT(DISTINCT c.permalink) AS companies_invested_in
FROM mode..crunchbase_company c
LEFT JOIN mode..crunchbase_investment_part1 i
ON c.permalink = i.company_permalink
GROUP BY i.investor_name
ORDER BY companies_invested_in DESC

-- Write a query that joins tutorial.crunchbase_companies and tutorial.crunchbase_investments_part1 using a FULL JOIN. Count up the number of rows that are matched/unmatched as in the example above.
-- #crunchbase 

SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments.company_permalink IS NULL
THEN companies.permalink ELSE NULL END) AS companies_only,
COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments.company_permalink IS NOT NULL
THEN companies.permalink ELSE NULL END) AS both_tables,
COUNT(CASE WHEN companies.permalink IS NULL AND investments.company_permalink IS NOT NULL
THEN investments.company_permalink ELSE NULL END) AS investments_only
FROM mode..crunchbase_company companies
FULL JOIN mode..crunchbase_investment_part1 investments
ON companies.permalink = investments.company_permalink


