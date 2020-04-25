
/*QUESTION 1 - How many rows are in the data_analyst_jobs table?
	ANSWER = 1793 */

SELECT COUNT(*)
	FROM data_analyst_jobs;


/*QUESTION 2 - Write a query to look at just the first 10 rows. 
	What company is associated with the job posting on the 10th row? 
	ANSWER: ExonMobil*/

SELECT *
	FROM data_analyst_jobs
	LIMIT 10;


/*QUESTION 3 - How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?
	ANSWER: TN only = 21
			TN or KY = 27 (21 in TN, 6 in KY) */
--TN only
SELECT COUNT(*)
	FROM data_analyst_jobs
	WHERE(location = 'TN');

--TN or KY
SELECT COUNT(*)
	FROM data_analyst_jobs
	WHERE(location = 'TN')
	OR(location = 'KY');

--TN or KY - Mary's code...  "IN" functions like an AND
SELECT COUNT(*)
	FROM data_analyst_jobs
	WHERE location IN ('TN', 'KY');



/*QUESTION 4 - How many postings in Tennessee have a star rating above 4?
	ANSWER: 3 companies have above 4 (note: one has a rating of 4; it isn't included)*/

SELECT COUNT (company)
	FROM data_analyst_jobs
	WHERE(location = 'TN')
	AND(star_rating > 4);
	
	

/*QUESTION 5 - How many postings in the dataset have a review count between 500 and 1000? 
	ANSWER: 151 */

SELECT COUNT(review_count)
	FROM data_analyst_jobs
	--WHERE(review_count >= 500 AND review_count <= 1000); -- I did it this way
	WHERE review_count BETWEEN 500 and 1000;     --Cleaner way from Mary.
		

/*QUESTION 6 - Show the average star rating for each state. 
	The output should show the state as state and the average rating for the state as avg_rating. 
	Which state shows the highest average rating?
	NOTES: Result was rounded. Null vallues in ave_rating were removed. 
	ANSWER: NE has highest rating of 4.20*/

SELECT location AS state, ROUND ( AVG(star_rating), 2 ) AS ave_rating
	FROM data_analyst_jobs
	WHERE(star_rating IS NOT NULL)
	GROUP BY(location)
	ORDER BY ave_rating DESC;
		

/*QUESTION 7 - Select unique job titles from the data_analyst_jobs table. How many are there? 
	ANSWER: 881 distinct */
	
SELECT COUNT ( DISTINCT(title) )
	FROM data_analyst_jobs;
			

/*QUESTION 8 - How many unique job titles are there for California companies?
	ANSWER: 230 */

SELECT COUNT ( DISTINCT(title) ) AS loc_titles_tally
	FROM data_analyst_jobs
	WHERE(location = 'CA');
				

/*QUESTION 9 - Find the name of each company and its average star rating for all companies 
that have more than 5000 reviews across all locations. 
How many companies are there with more that 5000 reviews across all locations?
	CORRECT ANSWER: 40 companies have 5000 reviews */

--THIS FIRST ONE IS MINE, AND GIVES WRONG ANSWER OF 71 COMPANIES. 
--NOT SURE WHAT I DID TO GET 41 (MY ORIGINAL ANSWER).
SELECT
	company, total_reviews
	FROM 
	(SELECT company, SUM(review_count) AS total_reviews
		FROM data_analyst_jobs
		GROUP BY company) as da_company
	WHERE total_reviews > 5000
	ORDER BY total_reviews DESC;

/*CORRECT CODE (from walk-through):*/
SELECT company, ROUND(AVG(star_rating),2), COUNT(location)
FROM data_analyst_jobs
WHERE review_count > 5000 AND company IS NOT NULL
GROUP BY company
ORDER BY count(location) DESC;


/*QUESTION #10 - Add the code to order the query in #9 from highest to lowest average star rating. 
	Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? 
	What is that rating?
	MY ANSWER (wrong):  Google, 4.30 
	CORRECT ANSWER:	Six companies tied at 4.199999809 (Amex, GM, Kaiser, Microsoft, Nike, Unilever)
	
	NOTE:  Google answer is wrong becuase data ALREADY gives sum of review_count across all locations. By doing SUM
	it overstates the review count.
	Ways to avoid a sub-query - think about useing HAVING
	*/

---This is what I did, but it overstates review count. Leaving it to show how I did it the first time.
SELECT
	company, total_reviews, avg_rating
	FROM 
	(SELECT company, SUM(review_count) AS total_reviews, ROUND (AVG (star_rating), 2) AS avg_rating
		FROM data_analyst_jobs
		GROUP BY company) as da_company
	WHERE total_reviews > 5000
	ORDER BY avg_rating DESC;

/* CODE, PER WALK-THROUGH - but gets a different answer - 
A few companies tied for top on this code, Amex, General Motors, etc.*/
SELECT DISTINCT company, AVG(star_rating) AS avg_rating
FROM data_analyst_jobs
WHERE review_count > 5000 AND company IS NOT NULL
GROUP BY company
ORDER BY avg_rating DESC;


/*QUESTION #11 - Find all the job titles that contain the word ‘Analyst’. How many different job titles are there?
	ANSWER: 774 */

SELECT COUNT ( DISTINCT(title) )
	FROM data_analyst_jobs
	WHERE title ILIKE '%analyst%';

/*TO SEE WHICH ARE MOST PREVELANT (interesting side trip) */
SELECT DISTINCT TITLE, COUNT(title) as counts
	FROM data_analyst_jobs
	WHERE title ILIKE '%analyst%'
	GROUP BY title
	ORDER BY counts DESC;

/*QUESTION #12 - A. How many different job titles do not contain either the 
	word ‘Analyst’ or the word ‘Analytics’? 
	B. What word do these positions have in common?
	AMSWER A:  4 titles w/out Analyst or Analytics
	ANSWER B:  Tableau = most common word in those 4*/

/*  My way was WAY TOO LONG!!!  Should have found "NOT ILIKE". Ugh.  */
SELECT DISTINCT(title)
FROM
	(SELECT DISTINCT(title)
		FROM data_analyst_jobs
		EXCEPT
			SELECT DISTINCT(title)
			FROM data_analyst_jobs
			WHERE title ILIKE '%analyst%') AS without_analyst
	EXCEPT
		SELECT DISTINCT(title)
		FROM data_analyst_jobs
		WHERE title ILIKE '%analyt%'
	ORDER BY title;

/* Better  */
SELECT DISTINCT title
FROM data_analyst_jobs
WHERE title NOT ILIKE '%analy%';



---------------------------------------------------------
---NEW EXERCISES, SIMPLE SUB-QUERIES---------------------
---------------------------------------------------------

