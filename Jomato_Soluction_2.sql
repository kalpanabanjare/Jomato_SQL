select * from jomato;

# Q1 Create a stored procedure to display the restaurant name, type and cuisine where the table booking is not zero

DELIMITER //

CREATE PROCEDURE DisplayBookedRestaurants()
BEGIN
    SELECT RestaurantName, RestaurantType, CuisinesType
    FROM jomato
    WHERE table_booking != 0;
END //

DELIMITER ;


# Q2. Create a transaction and update the cuisine type ‘Cafe’ to ‘Cafeteria’. Check the result and rollback it.

Start transaction;

SET SQL_SAFE_UPDATES = 0;

UPDATE Jomato
SET CuisinesType = 'Cafeteria'
WHERE CuisinesType = 'Cafe';

SET SQL_SAFE_UPDATES = 1;

select * from Jomato
where CuisinesType = 'Cafe';

select * from Jomato
where CuisinesType = 'Cafeteria';


# Q3.. Generate a row number column and find the top 5 areas with the highest rating of restaurants.

SELECT Area,
       AVG(Rating) AS avg_rating,
       ROW_NUMBER() OVER (ORDER BY AVG(Rating) DESC) AS row_num
FROM jomato
GROUP BY Area
ORDER BY avg_rating DESC
LIMIT 5;


# Q4. the while loop to display the 1 to 50.

WITH RECURSIVE Counter AS (
    SELECT 1 AS counter
    UNION ALL
    SELECT counter + 1
    FROM Counter
    WHERE counter < 50
)
SELECT counter FROM Counter;


# Q5. Write a query to Create a Top rating view to store the generated top 5 highest rating of restaurants.

CREATE VIEW TopRating AS
SELECT *
FROM (
    SELECT *
    FROM jomato
    ORDER BY rating DESC
    LIMIT 5
) AS Top5Ratings;

SELECT * FROM TopRating;




#Q6. Write a trigger that sends an email notification to the restaurant owner whenever a new record is inserted.


DELIMITER //

CREATE TRIGGER SendEmailNotification AFTER INSERT ON jomato
FOR EACH ROW
BEGIN
    DECLARE recipient_email VARCHAR(255);
    DECLARE RestaurantName VARCHAR(255);
    DECLARE email_subject VARCHAR(255);
    DECLARE email_body VARCHAR(1000);

    -- Get recipient email and restaurant name from the new record
    SELECT owner_email, RestaurantName INTO recipient_email, RestaurantName
    FROM jomato
    WHERE OrderId = NEW.OrderId;

    -- Construct the email subject and body
    SET email_subject = CONCAT('New Record Inserted for ', RestaurantName);
    SET email_body = CONCAT('A new record has been inserted for your restaurant ', RestaurantName, '.');

    -- Call stored procedure to send email
    CALL SendEmailProcedure(recipient_email, email_subject, email_body);
END;
//

DELIMITER ;

