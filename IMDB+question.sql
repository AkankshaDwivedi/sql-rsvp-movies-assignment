USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

/* To find the total number of rows in each table of the schema, we use the 'SELECT' and 'COUNT' statement for 
each table. The below 'COUNT' queries provide the number of rows for each table helping us undertsamd the table better.
*/

SELECT
	COUNT(*)
FROM
	director_mapping;
    
-- Total number of rows in table 'director_mapping': 3867

SELECT
	COUNT(*)
FROM
	genre;
    
-- Total number of rows in table 'genre': 14662

SELECT
	COUNT(*)
FROM
	movie;
    
-- Total number of rows in table 'movie': 7997

SELECT
	COUNT(*)
FROM
	names;
    
-- Total number of rows in table 'names': 25735

SELECT
	COUNT(*)
FROM
	ratings;
    
-- Total number of rows in table 'ratings': 7997

SELECT
	COUNT(*)
FROM
	role_mapping;
    
-- Total number of rows in table 'role_mapping': 15615





-- Q2. Which columns in the movie table have null values?
-- Type your code below:

/* To find columns in the 'movie' table that have null values we will use 'SUM' and 'CASE' statement.
The query calculates the count of null values for each column and provides insights about the table.

*/

SELECT
	SUM(CASE
			WHEN id IS NULL THEN 1
			ELSE 0
		END) AS id_null_count,
	SUM(CASE
			WHEN title IS NULL THEN 1
            ELSE 0
		END) AS title_null_count,
	SUM(CASE
			WHEN year IS NULL THEN 1
            ELSE 0
		END) AS year_null_count,
	SUM(CASE
			WHEN date_published IS NULL THEN 1
            ELSE 0
		END) AS date_published_null_count,
	SUM(CASE
			WHEN duration IS NULL THEN 1
            ELSE 0
		END) AS duration_null_count,
	SUM(CASE
			WHEN country IS NULL THEN 1
            ELSE 0
		END) AS country_null_count,
	SUM(CASE
			WHEN worlwide_gross_income IS NULL THEN 1
            ELSE 0
		END) AS worlwide_gross_income_null_count,
	SUM(CASE
			WHEN languages IS NULL THEN 1
            ELSE 0
		END) AS languages_null_count,
	SUM(CASE
			WHEN production_company IS NULL THEN 1
            ELSE 0
		END) AS production_company_null_count
FROM
	movie;
    
-- Columns 'country', 'worlwide_gross_income', 'languages' and 'production_company' in the 'movie' table has NULL values.




-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total number of movies released each year

SELECT
	Year,
    COUNT(id) AS number_of_movies
FROM
	movie
GROUP BY
	Year
ORDER BY
	Year;

-- The highest number of movies is released in the year '2017'


-- Total number of movies released each month

SELECT
	MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
	movie
GROUP BY
	month_num
ORDER BY
	number_of_movies DESC;

-- The highest number of movies is released in the month of 'March' followed by 'September' and 'January'.



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

/*
To find the number of movies produced in the USA or India in the year 2019 we will use
'LIKE' operator for pattern matching for 'country' column. 
*/

SELECT 
	COUNT(id) AS movie_count
FROM
	movie
WHERE
	(country LIKE '%India%' OR country LIKE '%USA%')
    AND year = 2019;
    
-- Total number of movies produced in the USA or India in the year 2019: 1059





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


/* To find the unique list of genres present in the data set we will use
'DISTINCT' keyword
*/

SELECT
	DISTINCT genre
FROM genre;

-- There are 13 unique genres in the dataset.





/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

/* To find the genre which had the highest number of movies overall we will use 'LIMIT' clause. 
This will display only the genre with highest number of movies produced.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'genre'.
*/

SELECT 
	genre,
    COUNT(id) AS movies_count
FROM 
	movie AS m
INNER JOIN 
	genre AS g
ON
	m.id = g.movie_id
GROUP BY 
	genre
ORDER BY 
	movies_count DESC
LIMIT 1;

-- 'Drama' genre has the highest number of movies produced overall with 4285 movies count.





/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

/*
Using genre table to find the number of movies that belong to only one genre.
Group by movie_id ti get the total movie count.
Finally, using the result of CTE(movies_with_one_genre) we will find the count of movies that belong to only one genre.

*/

WITH movies_with_one_genre AS
(	SELECT 
		movie_id,
        COUNT(genre) AS total_genre 
	FROM 
		genre 
	GROUP BY 
		movie_id
)
SELECT 
	count(*) AS movies_with_one_genre 
FROM 
	movies_with_one_genre
WHERE 
	total_genre = 1;

-- Number of movies that belong to only one genre: 3289




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* To find the average duration of movies in each genre we group by genre and then use 
'AVG' function on duration column.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'genre'.
*/

SELECT 
	genre,
    ROUND(AVG(duration), 2) AS avg_duration
FROM 
	movie AS m
INNER JOIN
	genre AS g
ON 
	m.id = g.movie_id
GROUP BY 
	genre
ORDER BY
	avg_duration DESC;

-- 'Action' genre has the higest average movie duration of 112.88 seconds followed by 'Romance' and 'Crime' genre.




/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

/*
First we write a CTE to get the rank of each genre based on the movies count for each genre.
Then use 'SELECT' statement to get the genre rank and number of movies for 'Thriller' genre.
*/

WITH genre_rank AS
(	SELECT 
		genre, 
        COUNT(movie_id) AS movie_count,
		RANK() OVER (ORDER BY count(movie_id) DESC) AS genre_rank
	FROM 
		genre
	GROUP BY 
		genre
)
SELECT * 
FROM 
	genre_rank 
WHERE 
	genre = 'Thriller';

-- The rank of the ‘thriller’ genre is 3rd with 1484 movies produced.




/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

/* To find the minimum and maximum values in each column of the ratings table except the movie_id column
we use the 'MIN' and 'MAX' functions for the query.
*/

SELECT 
	MIN(avg_rating) AS min_avg_rating,
	MAX(avg_rating) AS max_avg_rating,
	MIN(total_votes) AS min_total_votes,
	MAX(total_votes) AS max_total_votes,
	MIN(median_rating) AS min_median_rating,
	MAX(median_rating) AS max_median_rating
FROM 
	ratings;

/* From the output we can see that the minimum and maximum for each colum of the 'ratings' table is well within range.
This implies that there are no outliers in 'ratings' table
*/




/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

/*
 Finding the rank of each movie using ROW_NUMBER
 Displaying the top 10 movies using LIMIT clause.
 
 The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'ratings'.
*/

SELECT 
	title, 
    avg_rating,
	ROW_NUMBER () OVER (ORDER BY avg_rating DESC) AS movie_rank 
FROM 
	movie AS m
INNER JOIN 
	ratings AS r
ON 
	m.id = r.movie_id
LIMIT 10;

/* Top 10 movies include: 'Kirket', 'Love in Kilnerry', 'Gini Helida Kathe', 'Runam', 'Fan', 
'Android Kunjappan Version 5.25', 'Yeh Suhaagraat Impossible', 'Safe', 'The Brighton Miracle', 'Shibu'.
*/



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- Calculating the total number of movies based on media ratings and sorting by number of movies.


SELECT 
	median_rating, 
    COUNT(movie_id) AS movie_count
FROM 
	ratings
GROUP BY 
	median_rating
ORDER BY 
	movie_count DESC;

-- The highest number of movies have a median rating of 7, followed by 6 and 8 median rating.



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

/*
Firstly we write a CTE to get the rank of production company using 'RANK' function.
Then, we use this CTE to get the rank of the production company based on the most number of hit movies (average rating > 8) 

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'ratings'.
*/

WITH prod_company_rank AS 
(	SELECT 
		production_company, 
        COUNT(movie_id) AS movie_count,
		RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS prod_company_rank
	FROM 
		movie AS m
	INNER JOIN
		ratings AS r
	ON
		m.id = r.movie_id
	WHERE 
		avg_rating > 8 
        AND production_company IS NOT NULL
	GROUP BY
		production_company
)
SELECT * 
FROM 
	prod_company_rank;

/* 'Dream Warrior Pictures' and 'National Theatre Live' production house has produced the most number of hit movies.
Movies count for both of the production company is 3 and rank is 1.
*/


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/*
We will write a query to find movies released in each genre during March 2017 in the USA had more than 1,000 votes.
The condition check for month, year, number of votes, country will be included under 'WHERE' clause. 

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'genre', 'ratings'.
*/

SELECT 
	genre, 
    COUNT(id) AS movie_count 
FROM 
	movie AS m
INNER JOIN 
	genre AS g
ON
	m.id = g.movie_id
INNER JOIN 
	ratings AS r
ON
	m.id = r.movie_id
WHERE 
	MONTH(date_published) = 3 
    AND year = 2017 
    AND total_votes > 1000 
    AND country LIKE '%USA%'
GROUP BY 
	genre
ORDER BY 
	movie_count DESC;

/* Top genre that had the maximum movie count and was released during March 2017 in the USA with more than 1,000 votes
is 'Drama' with 24 movies.
Follwed by 'Comedy' and 'Action' genre with 9 and 8 movies count respectively.
This information will help the filmakers to target a wider audience in USA.
*/




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

/*
To find the movies of each genre that start with the word ‘The’ and which have an average rating > 8
we will use 'LIKE' operator and put a condition on average_rating.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'genre', 'ratings'.
*/

SELECT 
	title, 
    avg_rating, 
    genre 
FROM 
	movie AS m
INNER JOIN 
	genre AS g
ON
	m.id = g.movie_id
INNER JOIN 
	ratings AS r
ON
	m.id = r.movie_id
WHERE 
	title LIKE 'The%'
    AND avg_rating > 8
ORDER BY 
	avg_rating DESC;


/* 'The Brighton Miracle' movie is at the top with an avg_rating of 9.4 from Drama genre.
Followed by 'The Colour of Darkness' and 'The Blue Elephant 2' with an avg_rating of 9.1 and 8.8 respectively.
There are 8 movies that start with 'The' in their title.
*/




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

/*
Of the movies released between 1 April 2018 and 1 April 2019, to find the count that were given a median rating of 8 
we will use 'BETWEEN' operator. 
The conditions to check the date range and median rating is placed under 'WHERE' clause.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'ratings'.
*/

SELECT 
	COUNT(id) AS movie_count
FROM 
	movie AS m
INNER JOIN 
	ratings AS r 
ON
	m.id = r.movie_id
WHERE 
	date_published BETWEEN '2018-04-01' AND '2019-04-01'
	AND median_rating = 8;

-- Of the movies released between 1 April 2018 and 1 April 2019, 361 movies were given a median rating of 8.




-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

/*
To find of German movies get more votes than Italian movies we will use 'WHERE' clause
on the country column.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'ratings'.
*/


SELECT 
	country, 
    SUM(total_votes) AS total_votes 
FROM
	movie AS m
INNER JOIN
	ratings AS r
ON
	m.id = r.movie_id
WHERE 
	country IN ('Germany', 'Italy')
GROUP BY 
	country;

/* German movies revceived 106710 abd Italian movies received 77965 votes.
German movies received more votes compared to Italian movies.
*/




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

/* 
To find the columns in the names table have null values we will use 'CASE' statements.
*/


SELECT *
FROM
	names;
    
SELECT 
	SUM(CASE
			WHEN name IS NULL THEN 1
			ELSE 0
		END) AS name_nulls,
	SUM(CASE 
			WHEN height IS NULL THEN 1
			ELSE 0
		END) AS height_nulls,
	SUM(CASE 
			WHEN date_of_birth IS NULL THEN 1
			ELSE 0
		END) AS date_of_birth_nulls,
	SUM(CASE 
			WHEN known_for_movies IS NULL THEN 1
			ELSE 0
		END) AS known_for_movies_nulls
FROM
	names;

/*
'height', 'date_of_birth', 'known_for_movies' columns from names tables have 17335, 13431, 15226 null values
respectively.
'name' column do not have any null values.
*/




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* 
First we write a CTE to get the top 3 genres where average_rating > 8.
Using the result of CTE the directors are found whose movies have an average rating > 8 
and are sorted based on number of movies made.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'genre', 'ratings', director_mapping', 'names'.
*/

WITH top_three_genre AS
(	SELECT 
		genre, 
        COUNT(id) AS movie_count
	FROM 
		movie AS m
	INNER JOIN 
		genre AS g
	ON
		m.id = g.movie_id
	INNER JOIN 
		ratings AS r
	ON
		m.id = r.movie_id
	WHERE 
		avg_rating > 8
	GROUP BY 
		genre
	ORDER BY 
		movie_count DESC
	LIMIT 3
)
SELECT 
	n.name AS director_name, 
    COUNT(m.id) AS movie_count 
FROM 
	movie AS m
INNER JOIN 
	genre AS g
ON
	m.id = g.movie_id
INNER JOIN 
	ratings AS r
ON
	m.id = r.movie_id
INNER JOIN 
	director_mapping AS d
ON
	m.id = d.movie_id
INNER JOIN 
	names AS n
ON
	d.name_id = n.id
WHERE 
	genre IN (SELECT genre FROM top_three_genre) 
    AND avg_rating > 8
GROUP BY 
	director_name
ORDER BY 
	movie_count DESC
LIMIT 3;


/* 
Top three genres are 'Drama', 'Action', 'Comedy'
Top three directors in the top three genres whose movies have an average rating > 8 are 
'James Mangold', 'Joe Russo', 'Anthony Russo' with 4,3,3 movie_count respectively.
*/




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---	------------+-------------------+ */
-- Type your code below:

/*
To find the top two actors whose movies have a median rating >= 8 we use COUNT function.
The codition to check the median_rating is placed inside the 'WHERE' clause and 'LIMIT' clause
is used to limit the number of actors to two.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'ratings', 'role_mapping', 'names'.
*/

SELECT 
	name AS actor_name, 
	COUNT(m.id) AS movie_count
FROM 
	movie AS m
INNER JOIN 
	ratings AS r
ON
	m.id = r.movie_id
INNER JOIN 
	role_mapping AS rm
ON 
	m.id = rm.movie_id
INNER JOIN 
	names AS n
ON 
	n.id = rm.name_id
WHERE 
	median_rating >= 8
GROUP BY 
	actor_name
ORDER BY
	movie_count DESC
LIMIT 2;

/* The top two actors whose movies have a median rating >= 8 are 'Mammootty' and 'Mohanlal'
with 8 and 5 movies count respectively.
*/



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

/* 
To find the top three production houses based on the number of votes received by their movies
we will use RANK function and then group by production_company.
To limit the numebr of production houses to three we will use 'LIMIT' clause.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'ratings'.
*/


SELECT 
	production_company, 
	SUM(total_votes) AS vote_count,
	RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM 
	movie AS m
INNER JOIN 
	ratings AS r
ON 
	m.id = r.movie_id
GROUP BY 
	production_company
LIMIT 3;

/* The top three production houses based on the number of votes received by their movies are
'Marvel Studios', 'Twentieth Century Fox', 'Warner Bros.'
*/





/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

/*
To rank the actors we use the weighted average based on votes with 'ROW_NUMBER' function.
The condition on the 'category' and 'country' is placed under 'WHERE' clause.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'ratings', 'role_mapping', 'names'.
*/


SELECT 
	name AS actor_name, 
    SUM(total_votes) AS total_votes, 
    COUNT(m.id) AS movie_count,
	ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating,
	ROW_NUMBER() OVER (ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actor_rank
FROM 
	movie AS m
INNER JOIN 
	ratings AS r 
ON
	m.id = r.movie_id
INNER JOIN
	role_mapping AS rm
ON
	m.id = rm.movie_id
INNER JOIN
	names AS n
ON
	n.id = rm.name_id
WHERE 
	category = 'actor'
	AND country LIKE '%India%'
GROUP BY 
	actor_name
HAVING
	movie_count >= 5;

/* 'Vijay Sethupathi' is at the top with an average rating of 8.42.
Followed by 'Fahadh Faasil' and 'Yogi Babu' with average ratings of 7.99 and 7.83 respectively.
*/



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

/*
To rank the actoress we use the weighted average based on votes with 'ROW_NUMBER' function.
The condition on the 'category', 'country' and 'language' is placed under 'WHERE' clause.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'ratings', 'role_mapping', 'names'.
*/


SELECT 
	name AS actress_name, 
    SUM(total_votes) AS total_votes, 
    COUNT(m.id) AS movie_count,
	ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating,
	ROW_NUMBER() OVER (ORDER BY  ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actress_rank
FROM 
	movie AS m
INNER JOIN 
	ratings AS r 
ON
	m.id = r.movie_id
INNER JOIN
	role_mapping AS rm
ON
	m.id = rm.movie_id
INNER JOIN
	names AS n
ON
	n.id = rm.name_id
WHERE 
	category = 'actress'
	AND country LIKE '%India%'
    AND languages LIKE '%Hindi%'
GROUP BY 
	actress_name
HAVING
	movie_count >= 3;


/* The top five actresses in Hindi movies released in India based on their average ratings are
'Taapsee Pannu', 'Kriti Sanon', 'Divya Dutta', 'Shraddha Kapoor', 'Kriti Kharbanda' with
average rating of 7.74, 7.05, 6.88, 6.63, 4.80 respectively.
*/



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

/*
To classify thriller movues as per avg rating into 'Superhit movies', 'Hit movies', 'One-time-watch movies'
and 'Flop movies' we use 'CASE' statement and put a check on avg_rating to classify the category. 

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'ratings', 'genre'.
*/


SELECT 
	title, 
    genre, 
    avg_rating,
	CASE
		WHEN avg_rating > 8 THEN 'Superhit movies'
		WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
		WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
		WHEN avg_rating < 5 THEN 'Flop movies'
	End AS category
FROM 
	movie AS m
INNER JOIN 
	genre AS g
ON
	m.id = g.movie_id
INNER JOIN
	ratings AS r
ON
	m.id = r.movie_id
WHERE
	genre = 'Thriller';


-- The above query successfully classifies the thriller movies into their respective categories.


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

/*
To find the genre-wise running total and moving average of the average movie duration we use 
a combination of 'SUM', 'ROUND' and 'AVG' function.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'genre'.
*/


SELECT
	genre,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(ROUND(AVG(duration),2)) OVER (ORDER BY genre) AS running_total_duration,
    ROUND(AVG(ROUND(AVG(duration),2)) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM 
	movie AS m
INNER JOIN 
	genre AS g
ON 
	m.id = g.movie_id
GROUP BY 
	genre;


-- The above query successfully calculates the genre-wise running total and moving average of the average movie duration


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

/*
First we write a CTE to find the top three genres.
Then we write a CTE to find the top 5 movies of each year with top 3 genres.
Finally we do a select on the CTE results and put the condition on movie_rank under 'WHERE' clause.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'genre'.
*/


WITH top_three_genre AS 
(	SELECT 
		COUNT(id) AS movie_count, 
        genre 
	FROM
		movie AS m
	INNER JOIN
		genre AS g
	ON
		m.id = g.movie_id
	GROUP BY
		genre
	ORDER BY
		movie_count DESC
	LIMIT 3
),

-- Top 5 movies of each year with top 3 genres.
movie_summary AS 
(	SELECT
		genre,
        year,
        title AS movie_name, 
		CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) AS worlwide_gross_income ,
		ROW_NUMBER() OVER (PARTITION BY year ORDER BY CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) DESC) AS movie_rank
    FROM 
		movie AS m
    INNER JOIN 
		genre AS g
    ON
		m.id = g.movie_id
    WHERE 
		genre IN (SELECT genre FROM top_three_genre)
)    
SELECT 
	* 
FROM 
	movie_summary
WHERE 
	movie_rank <= 5;


-- The above query successfully finds the five highest-grossing movies of each year that belong to the top three genres



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


/*
To find the top two production houses that have produced the highest number of hits 
(median rating >= 8) among multilingual movies we use 'ROW_NUMBER' function based on movie count.
To find the multilingual language we use 'POSITION' function on language column.
The check on median_rating, language is placed under the 'WHERE' clause and 'LIMIT' clause is used
to limit the number of production houses to two.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'ratings'.
*/


SELECT 
	production_company,
    COUNT(id) AS movie_count,
	ROW_NUMBER() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM
	movie AS m
INNER JOIN
	ratings AS r
ON
	m.id = r.movie_id
WHERE
	median_rating >= 8
	AND POSITION(',' IN languages) > 0
	AND production_company IS NOT NULL
GROUP BY
	production_company
LIMIT 2;

/* 
The top two production houses that have produced the highest number of hits (median rating >= 8) 
among multilingual movies are 'Star Cinema' and 'Twentieth Century Fox' with 7 and 4 movies count respectively.
*/




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

/*
To find the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre
we use 'ROW_NUMBER' function based on the movie count.

The check on category = 'actress', avg_rating > 8 and genre = 'Drama' is placed under the 'WHERE' clause
and 'LIMIT' clause is used to limit the number of actresses to three.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'genre', 'names', 'role_mapping', 'ratings'.
*/


SELECT 
	name AS actress_name, 
    SUM(total_votes) AS total_votes, 
    COUNT(m.id) AS movie_count, 
    AVG(avg_rating) AS actress_avg_rating,
	ROW_NUMBER() OVER(ORDER BY COUNT(id) DESC) AS actress_rank
FROM 
	names AS n
INNER JOIN 
	role_mapping AS rm
ON 
	n.id = rm.name_id
INNER JOIN 
	movie AS m
ON 
	m.id = rm.movie_id
INNER JOIN 
	ratings AS r
ON 
	m.id = r.movie_id
INNER JOIN 
	genre AS g
ON 
	m.id = g.movie_id
WHERE 
	category = 'actress'
	AND avg_rating > 8
	AND genre = 'Drama'
GROUP BY 
	actress_name
ORDER BY 
	movie_count DESC
LIMIT 3;


/* The top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre are
'Parvathy Thiruvothu', 'Susan Brown', and 'Amanda Lawrence'.
*/



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

/*
To get the details for top 9 directors (based on number of movies) we use two CTE.
First CTE partitions the dataset uisng director id and finds the next date published using the LEAD function.
The second CTE is used to get the date difference used DATEDIFF function.
Finally the result of the CTE is selected and grouped by director id, order by the movies count
and top 9 directors are limited using LIMIT clause.

The below tables are joined using 'INNER JOIN' to get the relevant columns:
'movie', 'names', 'ratings'.
*/

WITH next_date_published AS
(
	SELECT 
		name_id, 
		name,
		m.id, 
		date_published,
		LEAD(date_published,1) OVER(PARTITION BY name_id ORDER BY date_published, dm.movie_id ) AS next_date_published,
		avg_rating,
		total_votes,
		duration
	FROM 
		director_mapping AS dm
	INNER JOIN 
		names AS n
	ON
		n.id = dm.name_id
	INNER JOIN 
		movie AS m
	ON 
		m.id = dm.movie_id
	INNER JOIN 
		ratings AS r
	ON 
		m.id = r.movie_id
),
top_director AS
(
	SELECT *,
		DATEDIFF(next_date_published, date_published) AS date_difference
	FROM
		next_date_published
)
SELECT 
	name_id AS director_id, 
	name AS director_name,
	COUNT(id) AS number_of_movies, 
    ROUND(Avg(date_difference),2) AS avg_inter_movie_days,
    ROUND(AVG(avg_rating),2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM
	top_director
GROUP BY
	director_id
ORDER BY
	COUNT(id) DESC
LIMIT 9;


/*
 The above query successfully retrives the required details for the top 9 directors
 (based on number of movies)
 */