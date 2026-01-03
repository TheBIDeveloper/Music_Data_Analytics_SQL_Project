USE MusicAnalytics;
GO

--------------------------------------------------
-- 1. Total streams per song
--------------------------------------------------
SELECT s.song_name,
       COUNT(l.history_id) AS total_streams
FROM listening_history l
JOIN songs s ON l.song_id = s.song_id
GROUP BY s.song_name
ORDER BY total_streams DESC;

--------------------------------------------------
-- 2. Total streams per artist
--------------------------------------------------
SELECT a.artist_name,
       COUNT(l.history_id) AS total_streams
FROM listening_history l
JOIN songs s ON l.song_id = s.song_id
JOIN artists a ON s.artist_id = a.artist_id
GROUP BY a.artist_name
ORDER BY total_streams DESC;

--------------------------------------------------
-- 3. Total streams per genre
--------------------------------------------------
SELECT g.genre_name,
       COUNT(l.history_id) AS total_streams
FROM listening_history l
JOIN songs s ON l.song_id = s.song_id
JOIN genres g ON s.genre_id = g.genre_id
GROUP BY g.genre_name
ORDER BY total_streams DESC;

--------------------------------------------------
-- 4. Average listening duration per song
--------------------------------------------------
SELECT s.song_name,
       AVG(l.listen_duration_seconds) AS avg_listen_duration
FROM listening_history l
JOIN songs s ON l.song_id = s.song_id
GROUP BY s.song_name
ORDER BY avg_listen_duration DESC;

--------------------------------------------------
-- 5. Most active users by number of streams
--------------------------------------------------
SELECT u.user_name,
       COUNT(l.history_id) AS total_streams
FROM listening_history l
JOIN users u ON l.user_id = u.user_id
GROUP BY u.user_name
ORDER BY total_streams DESC;

--------------------------------------------------
-- 6. Streams per country
--------------------------------------------------
SELECT u.country,
       COUNT(l.history_id) AS total_streams
FROM listening_history l
JOIN users u ON l.user_id = u.user_id
GROUP BY u.country
ORDER BY total_streams DESC;

--------------------------------------------------
-- 7. Top streamed song per genre
--------------------------------------------------
WITH ranked_songs AS (
    SELECT g.genre_name,
           s.song_name,
           COUNT(l.history_id) AS total_streams,
           RANK() OVER (PARTITION BY g.genre_name ORDER BY COUNT(l.history_id) DESC) AS rnk
    FROM listening_history l
    JOIN songs s ON l.song_id = s.song_id
    JOIN genres g ON s.genre_id = g.genre_id
    GROUP BY g.genre_name, s.song_name
)
SELECT genre_name, song_name, total_streams
FROM ranked_songs
WHERE rnk = 1;

--------------------------------------------------
-- 8. Top streamed artist per country
--------------------------------------------------
WITH country_artist AS (
    SELECT u.country,
           a.artist_name,
           COUNT(l.history_id) AS total_streams,
           RANK() OVER (PARTITION BY u.country ORDER BY COUNT(l.history_id) DESC) AS rnk
    FROM listening_history l
    JOIN songs s ON l.song_id = s.song_id
    JOIN artists a ON s.artist_id = a.artist_id
    JOIN users u ON l.user_id = u.user_id
    GROUP BY u.country, a.artist_name
)
SELECT country, artist_name, total_streams
FROM country_artist
WHERE rnk = 1;

--------------------------------------------------
-- 9. Songs with highest average listen duration
--------------------------------------------------
SELECT s.song_name,
       AVG(l.listen_duration_seconds) AS avg_duration
FROM listening_history l
JOIN songs s ON l.song_id = s.song_id
GROUP BY s.song_name
ORDER BY avg_duration DESC;

--------------------------------------------------
-- 10. User-wise total listen duration
--------------------------------------------------
SELECT u.user_name,
       SUM(l.listen_duration_seconds) AS total_listen_seconds
FROM listening_history l
JOIN users u ON l.user_id = u.user_id
GROUP BY u.user_name
ORDER BY total_listen_seconds DESC;

--------------------------------------------------
-- 11. Streams per release year
--------------------------------------------------
SELECT s.release_year,
       COUNT(l.history_id) AS total_streams
FROM listening_history l
JOIN songs s ON l.song_id = s.song_id
GROUP BY s.release_year
ORDER BY s.release_year;

--------------------------------------------------
-- 12. Average stream per genre
--------------------------------------------------
SELECT g.genre_name,
       AVG(stream_count) AS avg_streams
FROM (
    SELECT s.song_id, g.genre_name, COUNT(l.history_id) AS stream_count
    FROM listening_history l
    JOIN songs s ON l.song_id = s.song_id
    JOIN genres g ON s.genre_id = g.genre_id
    GROUP BY s.song_id, g.genre_name
) t
GROUP BY genre_name
ORDER BY avg_streams DESC;

--------------------------------------------------
-- 13. Total streams per user per genre
--------------------------------------------------
SELECT u.user_name,
       g.genre_name,
       COUNT(l.history_id) AS total_streams
FROM listening_history l
JOIN users u ON l.user_id = u.user_id
JOIN songs s ON l.song_id = s.song_id
JOIN genres g ON s.genre_id = g.genre_id
GROUP BY u.user_name, g.genre_name
ORDER BY total_streams DESC;

--------------------------------------------------
-- 14. Top user per genre
--------------------------------------------------
WITH user_genre AS (
    SELECT u.user_name,
           g.genre_name,
           COUNT(l.history_id) AS total_streams,
           RANK() OVER (PARTITION BY g.genre_name ORDER BY COUNT(l.history_id) DESC) AS rnk
    FROM listening_history l
    JOIN users u ON l.user_id = u.user_id
    JOIN songs s ON l.song_id = s.song_id
    JOIN genres g ON s.genre_id = g.genre_id
    GROUP BY u.user_name, g.genre_name
)
SELECT user_name, genre_name, total_streams
FROM user_genre
WHERE rnk = 1;

--------------------------------------------------
-- 15. Artist-wise average song duration
--------------------------------------------------
SELECT a.artist_name,
       AVG(s.duration_seconds) AS avg_song_duration
FROM songs s
JOIN artists a ON s.artist_id = a.artist_id
GROUP BY a.artist_name
ORDER BY avg_song_duration DESC;

--------------------------------------------------
-- 16. Songs listened by more than 2 users
--------------------------------------------------
SELECT s.song_name,
       COUNT(DISTINCT l.user_id) AS user_count
FROM listening_history l
JOIN songs s ON l.song_id = s.song_id
GROUP BY s.song_name
HAVING COUNT(DISTINCT l.user_id) > 2
ORDER BY user_count DESC;

--------------------------------------------------
-- 17. Total streams per artist per genre
--------------------------------------------------
SELECT a.artist_name,
       g.genre_name,
       COUNT(l.history_id) AS total_streams
FROM listening_history l
JOIN songs s ON l.song_id = s.song_id
JOIN artists a ON s.artist_id = a.artist_id
JOIN genres g ON s.genre_id = g.genre_id
GROUP BY a.artist_name, g.genre_name
ORDER BY total_streams DESC;

--------------------------------------------------
-- 18. Most popular genre by country
--------------------------------------------------
WITH country_genre AS (
    SELECT u.country,
           g.genre_name,
           COUNT(l.history_id) AS total_streams,
           RANK() OVER (PARTITION BY u.country ORDER BY COUNT(l.history_id) DESC) AS rnk
    FROM listening_history l
    JOIN users u ON l.user_id = u.user_id
    JOIN songs s ON l.song_id = s.song_id
    JOIN genres g ON s.genre_id = g.genre_id
    GROUP BY u.country, g.genre_name
)
SELECT country, genre_name, total_streams
FROM country_genre
WHERE rnk = 1;

--------------------------------------------------
-- 19. Total streams per day
--------------------------------------------------
SELECT listen_date,
       COUNT(history_id) AS total_streams
FROM listening_history
GROUP BY listen_date
ORDER BY listen_date;

--------------------------------------------------
-- 20. User engagement ranking
--------------------------------------------------
SELECT u.user_name,
       COUNT(l.history_id) AS total_streams,
       RANK() OVER (ORDER BY COUNT(l.history_id) DESC) AS engagement_rank
FROM listening_history l
JOIN users u ON l.user_id = u.user_id
GROUP BY u.user_name
ORDER BY engagement_rank;
