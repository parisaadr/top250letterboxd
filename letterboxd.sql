SELECT * FROM letterboxd;

SELECT Title, Genre
FROM letterboxd
WHERE Genre IS NULL;

UPDATE letterboxd
SET Genre = 'Drama'
WHERE Genre IS NULL;

SELECT Title, Genre
FROM letterboxd
WHERE Title = 'Satantango';

SELECT Title, Year, LetterboxdScore
FROM letterboxd
ORDER BY LetterboxdScore DESC;

-- now we wanna see which countries and languages have the most movies in the top 250
SELECT Country, COUNT(Country) AS Times_Mentioned
FROM letterboxd
GROUP BY Country
ORDER BY COUNT(Country) DESC;

UPDATE letterboxd
SET Language = 'English '
WHERE Language = 'English';

SELECT Language, COUNT(Language) AS Times_Mentioned
FROM letterboxd
GROUP BY Language
ORDER BY COUNT(Language) DESC;

-- also 
-- during how many movies did they speak english?
SELECT Language, COUNT(Language) AS Times_Mentioned
FROM letterboxd
WHERE Language LIKE '%English%'
GROUP BY Language
ORDER BY COUNT(Language) DESC;

-- let's see which director has the most films in the top 250
SELECT Director, COUNT(Director) AS Times_Mentioned
FROM letterboxd
GROUP BY Director
ORDER BY COUNT(Director) DESC;

-- we wanna see what are the most popular movies based on the number of watches
SELECT Title, LetterboxdWatches
FROM letterboxd
ORDER BY LetterboxdWatches DESC;

-- analysis based on the score
SELECT Title, Year, LetterboxdScore
FROM letterboxd
WHERE LetterboxdScore > '4.37'
ORDER BY LetterboxdScore DESC;

SELECT Title, Year, LetterboxdScore
FROM letterboxd
WHERE LetterboxdScore > (SELECT AVG(LetterboxdScore)
                        FROM letterboxd)
ORDER BY LetterboxdScore DESC;

-- top 10 of each decade
SELECT Title, Year, LetterboxdScore, ReleaseDate
FROM letterboxd
WHERE Year BETWEEN '1990' AND '1999'
ORDER BY LetterboxdScore DESC
LIMIT 10;

SELECT Title, Year, LetterboxdScore
FROM letterboxd
WHERE Year BETWEEN '1950' AND '1959' AND Genre LIKE '%DRAMA%'
ORDER BY LetterboxdScore DESC
LIMIT 10;

-- lets rank the movies based on their level of popularity
SELECT Title, Year, LetterboxdWatches
FROM letterboxd
ORDER BY LetterboxdWatches DESC;

SELECT Title, Year, LetterboxdWatches, LetterboxdVotes,
       (letterboxd.LetterboxdWatches/letterboxd.LetterboxdVotes) AS engagement
FROM letterboxd
ORDER BY engagement DESC;

SELECT SUM(LetterboxdWatches) AS TotalWatched FROM letterboxd;
SELECT SUM(LetterboxdVotes) AS TotalVoted FROM letterboxd;

-- how likely it is for people to write a review or like a movie or just vote for it
SELECT Title, Year, LetterboxdWatches AS watched,
       (letterboxd.LetterboxdVotes/letterboxd.LetterboxdWatches) AS voted,
       (letterboxd.LetterboxedLiked/LetterboxdWatches) AS liked,
       (letterboxd.LetterboxdReviews/letterboxd.LetterboxdWatches) AS reviewed
FROM letterboxd
ORDER BY LetterboxdScore DESC;

SELECT Title, Year, LetterboxdWatches AS watched,
       (letterboxd.LetterboxdVotes/letterboxd.LetterboxdWatches) AS voted,
       (letterboxd.LetterboxedLiked/LetterboxdWatches) AS liked,
       (letterboxd.LetterboxdReviews/letterboxd.LetterboxdWatches) AS reviewed
FROM letterboxd
ORDER BY watched, voted DESC;

-- money!!
SELECT Title, Year, Budget
FROM letterboxd
WHERE Budget IS NOT NULL
ORDER BY Budget DESC;

SELECT Title, Year, BoxOffice, Director
FROM letterboxd
WHERE BoxOffice IS NOT NULL
ORDER BY BoxOffice DESC;

SELECT Title, Year, BoxOffice
FROM letterboxd
WHERE BoxOffice IS NOT NULL
AND Year BETWEEN '1990' AND '1999'
ORDER BY BoxOffice DESC
LIMIT 10;

SELECT Title, Year, BoxOffice, Budget, (BoxOffice - letterboxd.Budget) AS Profit
FROM letterboxd
WHERE Budget AND BoxOffice IS NOT NULL
ORDER BY Profit DESC;

SELECT Title AS AboveAvg, Year, BoxOffice, Budget, (BoxOffice - letterboxd.Budget) AS Profit
FROM letterboxd
WHERE BoxOffice - letterboxd.Budget > (SELECT AVG(BoxOffice - letterboxd.Budget)
                FROM letterboxd)
ORDER BY Profit DESC;

SELECT Title, Year, IF(BoxOffice>letterboxd.Budget, 'Hit', 'Flop') AS Verdict
FROM letterboxd
WHERE BoxOffice AND Budget IS NOT NULL
ORDER BY LetterboxdScore DESC;

-- lets find out which decade did a better job
-- FIRST SOLUTION
ALTER TABLE letterboxd
ADD COLUMN Decade INT;

UPDATE letterboxd
SET letterboxd.Decade = MID(Year,2,2)
WHERE `No.`=`No.`;

SELECT Decade, COUNT(Decade) AS MovieCount
FROM letterboxd
GROUP BY Decade;

SELECT Decade, COUNT(Decade) AS MovieCount, CAST(ROUND(AVG(LetterboxdScore),2) AS DEC(10,2)) AS AvgRating
FROM letterboxd
GROUP BY Decade
ORDER BY AvgRating DESC;

SELECT CASE
            WHEN Decade = 1 THEN '2010s'
            WHEN Decade = 0 THEN '2000s'
            WHEN Decade = 2 THEN '2020s'
            ELSE RIGHT(Decade,1)*10  END AS Decade,
    COUNT(Decade) AS MovieCount, CAST(ROUND(AVG(LetterboxdScore),2) AS DEC(10,2)) AS AvgRating
FROM letterboxd
GROUP BY Decade
ORDER BY AvgRating DESC;

SELECT CASE
            WHEN Decade = 1 THEN '2010s'
            WHEN Decade = 0 THEN '2000s'
            WHEN Decade = 2 THEN '2020s'
            ELSE RIGHT(Decade,1)*10  END AS Decade,
    COUNT(Decade) AS MovieCount, CAST(ROUND(AVG(LetterboxdScore),2) AS DEC(10,2)) AS AvgRating
FROM letterboxd
GROUP BY Decade
ORDER BY MovieCount DESC;

-- SECOND SOLUTION
ALTER TABLE letterboxd
ADD COLUMN TheDecade INT;

UPDATE letterboxd
SET TheDecade = CASE
    WHEN MID(Year, 2, 2) = '00' THEN 2000
    WHEN MID(Year, 2, 2) = '01' THEN 2010
    WHEN MID(Year, 2, 2) = '02' THEN 2020
    ELSE MID(Year, 3, 1)*10
    END
WHERE `No.`=`No.`;

SELECT
    CASE
        WHEN TheDecade = 2000 THEN '2000s'
        WHEN TheDecade = 2010 THEN '2010s'
        WHEN TheDecade = 2020 THEN '2020s'
        ELSE  CONCAT('19', thedecade, 's')
    END AS Decade,
    COUNT(TheDecade) AS MovieCount,
    CAST(ROUND(AVG(LetterboxdScore), 2) AS DEC(10, 2)) AS AvgRating
FROM letterboxd
GROUP BY TheDecade
-- ORDER BY MovieCount DESC
-- ORDER BY Decade
ORDER BY AvgRating DESC;

-- THIRD SOLUTION
SELECT FLOOR((Year)/10) * 10 AS Decadee
FROM letterboxd;

SELECT CONCAT(Decadee, 's') AS Decadee, COUNT(*) AS MovieCount,
       CAST(ROUND(AVG(LetterboxdScore),2) AS DEC(10,2)) AS AvgRating
FROM (SELECT FLOOR((Year)/10) * 10 AS Decadee, LetterboxdScore
      FROM letterboxd) TEMP
GROUP BY Decadee
ORDER BY Decadee DESC;