# Lab | Stored procedures

#Instructions
#Write queries, stored procedures to answer the following questions:

/* 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
Convert the query into a simple stored procedure.*/

USE sakila;

DROP PROCEDURE IF EXISTS customers_info;
DELIMITER //
CREATE PROCEDURE customers_info ()
BEGIN
	SELECT DISTINCT(CONCAT(c.first_name, ' ', c.last_name)) AS name, c.email
	FROM customer AS c
	JOIN rental AS r ON c.customer_id = r.customer_id
	JOIN inventory AS i ON i.inventory_id = r.inventory_id
	JOIN film AS f ON f.film_id = i.film_id
	JOIN film_category AS fc ON fc.film_id = f.film_id 
	JOIN category AS ca ON ca.category_id = fc.category_id
	WHERE ca.name = 'Action'
	ORDER BY 1;
END //
DELIMITER ;

CALL customers_info;

/* 2. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string 
argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, 
children, classics, etc.*/

DROP PROCEDURE IF EXISTS customers_info_by_category;
DELIMITER //
CREATE PROCEDURE customers_info_by_category (IN category_movie CHAR(50))
BEGIN
	SELECT DISTINCT(CONCAT(c.first_name, ' ', c.last_name)) AS name, c.email
	FROM customer AS c
	JOIN rental AS r ON c.customer_id = r.customer_id
	JOIN inventory AS i ON i.inventory_id = r.inventory_id
	JOIN film AS f ON f.film_id = i.film_id
	JOIN film_category AS fc ON fc.film_id = f.film_id 
	JOIN category AS ca ON ca.category_id = fc.category_id
	WHERE CAST(ca.name AS BINARY) = CAST(category_movie AS BINARY)
	ORDER BY 1;
END //
DELIMITER ;

CALL customers_info_by_category('Action');

/* 3. Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those 
categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.*/ 

SELECT c.name, COUNT(*) AS number_of_movies
FROM film_category AS fc
JOIN category AS c ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY number_of_movies DESC;


DROP PROCEDURE IF EXISTS number_of_movies_by_category_greater_than;
DELIMITER //
CREATE PROCEDURE number_of_movies_by_category_greater_than(IN number INT)
BEGIN
	SELECT c.name, COUNT(*) AS number_of_movies
	FROM film_category AS fc
	JOIN category AS c ON c.category_id = fc.category_id
	GROUP BY c.name
	HAVING COUNT(*) > number
	ORDER BY number_of_movies DESC;
END //
DELIMITER ;

CALL number_of_movies_by_category_greater_than(66);