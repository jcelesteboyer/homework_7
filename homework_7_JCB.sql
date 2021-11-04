--1. Create a new column called “status” in the rental table that uses a case statement 
--to indicate if a film was returned late, early, or on time. 

ALTER TABLE rental
ADD COLUMN status text;
UPDATE rental
SET status = 
	CASE WHEN rental_duration > date_part('day', return_date - rental_date) THEN 'Returned Early'
		 WHEN rental_duration < date_part('day', return_date - rental_date) THEN 'Returned Late'
		 WHEN rental_duration = date_part('day', return_date - rental_date) THEN 'Returned on Time'
END
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id;
/* The first step was to create a new column in the rental table by altering the table and specifying that column
 (and data type) that needs to be added. 
 Once that column is in place, I could modify it with the update to recall the table and the set to specify the column. 
 The CASE WHEN is used with the specified perameters to get the different values. 
 In order to get all the columns needed for the CASE WHEN, I needed to INNER JOIN with the film table. */

--2. Show the total payment amounts for people who live in Kansas City or Saint Louis. 

SELECT SUM(p.amount), ci.city
FROM payment AS p
INNER JOIN customer AS c
ON p.customer_id = c.customer_id
INNER JOIN address AS a
ON c.address_id = a.address_id
INNER JOIN city as ci
ON a.city_id = ci.city_id
WHERE ci.city = 'Kansas City' OR ci.city = 'Saint Louis'
GROUP BY ci.city;

/* In order to view this information we needed to join four tables: payment, customer, address, and city. 
 The two columns needed were the amount so that it can be summed and the city where by we could select
 only for the two citites requested. The output was two columns: city name and sum amount. */


--3. How many films are in each category? Why do you think there is a table for category and a table 
-- for film category?

SELECT COUNT(name), c.category_id
FROM film_category  as fc
INNER JOIN category as c
ON fc.category_id = c.category_id
GROUP BY name, c.category_id;

/* The table that is the output is a column with the category id number paired with the total number of films. 
 There are 16 categories. 
 The category table houses the category name information, whereas the film category only sees each category
 by the id number. If I were to guess why someone would organize it this way would be that it is faster
 to work with just variables in the film_category rather than have a mix of both variables and characters. */

--4. Show a roster for the staff that includes their email, address, city, and country (not ids)

SELECT first_name, last_name, email, address, city, country
FROM staff AS s
INNER JOIN address AS a 
ON s.address_id = a.address_id
LEFT JOIN city AS ci
ON a.city_id = ci.city_id
LEFT JOIN country AS co
ON ci.country_id = co.country_id;

/* The output was a total of two staff members. Mike from Canada and Jon from Australia. 
 A left join in neccessary in this case because the right table had some missing data and we don't want
 to miss any of the staff members. */

-- 5. Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005

SELECT f.film_id, title, length
FROM film AS f
INNER JOIN inventory AS i
ON f.film_id = i.film_id
INNER JOIN rental AS r
ON i.inventory_id = r.inventory_id
WHERE return_date BETWEEN '2005-05-15' AND '2005-05-31'

/* The output is a table that list the film_id, title of the movie, and the length of the movie. 
 There are 295 movies in the table that matched the specified return_date. */

-- 6. Write a subquery to show which movies are rented below the average price for all movies. 

SELECT title, rental_rate
FROM film
WHERE rental_rate < (SELECT AVG(rental_rate)
					 FROM film);

/* The subquery was used to find the average rental price for all movies. 
 The table from the query displays only movies where the rental rate is below the average. 
 Table only has movies priced at .99 because that is the only other rental price lower than the average of 2.98. */ 

-- 7. Write a join statement to show which movies are rented below the average price for all movies.

SELECT f1.title, f1.rental_rate
FROM film f1
INNER JOIN film f2 
ON f1.title <> f2.title
GROUP BY f1.title, f1.rental_rate
HAVING f1.rental_rate < AVG(f2.rental_rate);

/* The table was selected to show the title of the movie and the rental rate. 
Since I needed to join the table to itself, I had to name th table twice and give each a different alias. 
For the ON statment I had to change from an equal (=) to the not equal (<>), otherwise no rows would have shown up. 
The table is grouped by the two rows. In order to use an aggregate funtion, I had to use the HAVING as opposed 
to the WHERE in which you cannot use an aggregate. */

-- 8. Perform an explain plan on 6 and 7, and describe what you’re seeing and important ways they differ.

EXPLAIN ANALYZE SELECT title, rental_rate
FROM film
WHERE rental_rate < (SELECT AVG(rental_rate)
					 FROM film);

/* The query plan resulted in a planning time of 3.581 ms and an execution time of 2.362 ms. 
A Seq scan was performed on the table film followed by filtering and removing rows. 
The aggregate and a final seq scan were performed. */


EXPLAIN ANALYZE SELECT f1.title, f1.rental_rate
FROM film f1
INNER JOIN film f2 
ON f1.title <> f2.title
GROUP BY f1.title, f1.rental_rate
HAVING f1.rental_rate < AVG(f2.rental_rate);

/* The query plan resulted in a planning time of 1.136 ms and an execution time of 1227.617. 
The query on problem number 7 is much longer and more cumbersome than the number 6 problem. 
The same scanning, filtering, and removing rows occurs, but with the added nested loop and a scan on 
both table aliases. The performance of the subquery is must more efficient over the self join. */



-- 9. With a window function, write a query that shows the film, its duration, 
-- and what percentile the duration fits into. 

SELECT title, length, NTILE(100) OVER (ORDER BY length) AS percentile
FROM film;
/* The NTILE window function identifies what percentile the length of the movie falls into. 
 The output is a table with the three columns of title, length, and percentile. */

-- 10. In under 100 words, explain what the difference is between set-based and procedural programming. 
-- Be sure to specify which sql and python are.

/* Set-based programming is a model of programming based on set theory. SQL is a set based programming that
 allows for faster programming. It also has the advantages of being much clearer to read. Set based programming
 focuses on completing the tast over a column, whereas, procedural programming works row by row. Python is a
 procedural programming model that executes a list of instructions line by line. This also known as the top down approach. 
 Procedural programming is best when you need to isolate and manipulate varialbes. */

