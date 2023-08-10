-- 1. List all customers who live in Texas (use JOINs)

-- This first question took me like 2 hours to figure out, but I got better as this assignment progressed


SELECT amount
FROM payment
WHERE amount > 0;

SELECT customer.first_name, customer.last_name, address.district
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
WHERE district = 'Texas';



-- 2. Get all payments above $6.99 with the Customer's Full Name

-- I just want to remind yall that this table is jacked up. 99% of the values are -400 something
-- There are only like 31 payments above 0...

SELECT customer.first_name, customer.last_name, payment.amount
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
WHERE amount >= 6.99;



-- 3. Show all customers names who have made payments over $175(use subqueries)

-- TY Christian

SELECT first_name, last_name, customer_id
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    HAVING SUM(amount) > 175
);


-- 4. List all customers that live in Nepal (use the city table)

-- Nepal = country id of 66

SELECT *
FROM country
WHERE country = 'Nepal';

SELECT customer.first_name, customer.last_name, country.country
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country = 'Nepal';


-- I also had this using country ID but either works. Only Kevin Schuler lives in Nepal


-- 5. Which staff member had the most transactions?
-- There are ONLY TWO staff members. By transactions I will assume the most sales


SELECT COUNT(rental.staff_id), staff_id
FROM rental
GROUP BY staff_id;

-- Since this is the same exact answer as Monday's hw I'm gonna assume I just don't understand the question
-- What else would transaction be? staff only has a FK to their address, and staff_id shows up in rental
-- Perhaps just run a join to show I'm learning different methods?


SELECT staff.first_name, staff.last_name, COUNT(rental.staff_id)
FROM staff
INNER JOIN rental
ON staff.staff_id = rental.staff_id
GROUP BY staff.first_name, staff.last_name;



-- 6. How many movies of each rating are there?
-- TONS of duplicates in this inventory.. so annoying. Should be 958 distinct 

SELECT DISTINCT inventory.film_id, COUNT(film.rating)
FROM inventory
INNER JOIN film
ON inventory.film_id = film.film_id
GROUP BY inventory.film_id, film.rating;


SELECT film.rating, COUNT(film.rating)
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
GROUP BY film.rating;

SELECT count(rating)
FROM film
WHERE rating = 'G';

-- Uhhh okay you know.. I don't actually think there is a real way to do what the homework asks 
-- with so many duplicate inventory primary keys. So here's a big brain approach that took me an hour

WITH DistinctInventory AS (
    SELECT DISTINCT film_id
    FROM inventory
)

SELECT film.rating, COUNT(DI.film_id) AS num_of_movies
FROM film
JOIN DistinctInventory DI 
ON film.film_id = DI.film_id
GROUP BY film.rating
ORDER BY film.rating;

-- DistinctInventory is known as a Common Table Expression, takes care of the duplicate PKs in inventory
-- Perform a join on rating and count of the CTE, then num_of_movies just makes our result column easier to understand

-- So the answer is.. 
-- G: 171, PG: 183, PG-13: 213, R: 190, NC-17: 201
--Please fire this database team ASAP


-- 7.Show all customers who have made a single payment
-- above $6.99 (Use Subqueries)


SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM payment
    WHERE payment.amount > 6.99
);


-- Join to see how much the payment was

SELECT customer.first_name, customer.last_name, payment.amount
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
WHERE payment.amount > 6.99;




-- 8. How many free rentals did our stores give away?

-- uhhh, ALL of them? lol
-- I don't really know what this is asking, since the store has PAID customers many thousands 
-- of dollars. There are zero payments of $0, so I'm not sure if negatives count

SELECT *
FROM payment
WHERE amount <= 0;

-- 14,565 rentals have a negative value? idk man

