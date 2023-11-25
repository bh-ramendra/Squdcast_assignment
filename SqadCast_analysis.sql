-- sol a : 
WITH MovieStats AS (
    SELECT
        m.title,
        m.minutes,
        m.year,
        AVG(r.rating) AS avg_rating,
        COUNT(r.rating) AS num_ratings
    FROM
        movie m
        JOIN [rating] r ON m.id = r.movie_id
    GROUP BY
        m.title, m.minutes, m.year
    HAVING
        COUNT(r.rating) >= 5
)

-- Select top 5 movies based on criteria
SELECT TOP 5
    title,
    minutes,
    year,
    avg_rating,
    num_ratings
FROM
    MovieStats
ORDER BY
    minutes DESC, year ASC, avg_rating DESC, num_ratings DESC;


--sol b:  
SELECT COUNT(DISTINCT rater_id) AS UnisolRatersCount
FROM rating;



-- sol c: 
WITH RaterStats AS (
    SELECT
        rater_id,
        COUNT(movie_id) AS num_movies_rated,
        AVG(rating) AS avg_rating
    FROM
        rating
    GROUP BY
        rater_id
    HAVING
        COUNT(movie_id) >= 5
)

--Select top 5 raters based on most movies rated and highest average rating
SELECT TOP 5
    rater_id,
    num_movies_rated,
    avg_rating
FROM
    RaterStats
ORDER BY
    num_movies_rated DESC, avg_rating DESC;


-- sol d:Top-rated movies by Michael Bay in Comedy genre, released in 2013, and in India
WITH TopRatedMovies AS (
    SELECT
        m.title,
        r.rating
    FROM
        movie m
        JOIN rating r ON m.id = r.movie_id
    WHERE
        m.director = 'Michael Bay' AND
        LOWER(m.genre) LIKE '%comedy%' AND
        m.year = 2013 AND
        m.country = 'India'
    GROUP BY
        m.title, r.rating
    HAVING
        COUNT(r.rating) >= 5
)

-- Select the top-rated movie
SELECT top 1
    title,
    AVG(rating) AS avg_rating
FROM
    TopRatedMovies
GROUP BY
    title
ORDER BY
    avg_rating DESC;

	



--sol e: Count the occurrences of each genre for rater ID 1040
WITH Rater1040GenreCounts AS (
    SELECT
        genre,
        COUNT(*) AS genre_count
    FROM
        movie m
        JOIN rating r ON m.id = r.movie_id
    WHERE
        r.rater_id = 1040
    GROUP BY
        genre
)

-- Determine the favorite genre (genre with the highest count)
SELECT TOP 1
    genre
FROM
    Rater1040GenreCounts
ORDER BY
    genre_count DESC;




--sol f: Highest average rating for a movie genre by Rater ID 1040
WITH Rater1040GenreAvg AS (
    SELECT
        m.genre,
        AVG(r.rating) AS avg_rating
    FROM
        movie m
        JOIN rating r ON m.id = r.movie_id
    WHERE
        r.rater_id = 1040
    GROUP BY
        m.genre
    HAVING
        COUNT(r.rating) >= 5
)

-- Select the genre with the highest average rating
SELECT top 1
    genre,
    avg_rating
FROM
    Rater1040GenreAvg
ORDER BY
    avg_rating DESC;





--sol g: Identify the year with the second-highest number of action movies
WITH ActionMovies AS (
    SELECT
        m.year,
        COUNT(*) AS num_action_movies
    FROM
        movie m
        JOIN rating r ON m.id = r.movie_id
    WHERE
        LOWER(m.genre) LIKE '%action%' AND
        m.country = 'USA' AND
        r.rating >= 6.5 AND
        m.minutes < 120
    GROUP BY
        m.year
)

-- Select the year with the second-highest number of action movies
SELECT
    year
FROM
    (
        SELECT
            year,
            RANK() OVER (ORDER BY num_action_movies DESC) AS rnk
        FROM
            ActionMovies
    ) ranked
WHERE
    rnk = 2;




--sol h : Count the number of movies with at least five reviews and a rating of 7 or higher
with Nmovie as(
SELECT COUNT(DISTINCT movie_id) AS num_high_rated_movies
FROM rating
WHERE rating >= 7
GROUP BY movie_id
HAVING COUNT(rating) >= 5)

select count(*) as num_high_rated_movies from Nmovie 


 


