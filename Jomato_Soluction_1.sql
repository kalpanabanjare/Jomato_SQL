CREATE DATABASE jomato_database;

select * from jomato;

# Q 1. Create a user-defined functions to stuff the Chicken into ‘Quick Bites’. Eg: ‘Quick Chicken Bites’''

CREATE FUNCTION QuickChickenBites(chicken VARCHAR(255)) RETURNS VARCHAR(255)
AS
BEGIN
  RETURN STUFF(chicken, CHARINDEX('chicken', chicken), LEN('chicken'), 'Quick Chicken Bites');
END;



DELIMITER $$

CREATE FUNCTION QuickChickenBites(chicken VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE pos INT DEFAULT LOCATE('chicken', chicken);
    
    IF pos > 0 THEN
        RETURN CONCAT(
            SUBSTRING(chicken, 1, pos - 1),
            'Quick Chicken Bites',
            SUBSTRING(chicken, pos + 7)
        );
    ELSE
        RETURN chicken;
    END IF;
END$$

DELIMITER ;

# Q 2. Use the function to display the restaurant name and cuisine type which has the maximum number of rating.


SELECT RestaurantName, CuisinesType
FROM jomato
WHERE rating = (
    SELECT MAX(rating)
    FROM jomato
);

# Q3. Create a Rating Status column to display the rating as ‘Excellent’ if it has more the 4 start rating, ‘Good’ if it has above 3.5 and below 5 star rating, ‘Average’ if it is above 3 and below 3.5 and ‘Bad’ if it is below 3 star rating


SELECT RestaurantName, CuisinesType, Rating,
    CASE
        WHEN Rating > 4 THEN 'Excellent'
        WHEN Rating > 3.5 AND Rating <= 4 THEN 'Good'
        WHEN Rating > 3 AND Rating <= 3.5 THEN 'Average'
        ELSE 'Bad'
    END AS RatingStatus
FROM jomato;

# Q4. Find the Ceil, floor and absolute values of the rating column and display the current date and separately display the year, month_name, day

SELECT 
    CEIL(Rating) AS RatingCeil,
    FLOOR(Rating) AS RatingFloor,
    ABS(Rating) AS RatingAbsolute,
    CURDATE() AS CurrentDate,
    YEAR(CURDATE()) AS CurrentYear,
    MONTHNAME(CURDATE()) AS CurrentMonthName,
    DAY(CURDATE()) AS CurrentDay
    from jomato;


# Q5. 5. Display the restaurant type and total average cost using rollup.

SELECT 
    RestaurantType,
    AVG(AverageCost) AS total_average_cost
FROM 
    jomato
GROUP BY 
    RestaurantType WITH ROLLUP;
