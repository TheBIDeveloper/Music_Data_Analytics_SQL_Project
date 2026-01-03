-- Create Database
CREATE DATABASE MusicAnalytics;
GO

USE MusicAnalytics;
GO

--------------------------------------------------
-- Artists Table
--------------------------------------------------
CREATE TABLE artists (
    artist_id INT IDENTITY(1,1) PRIMARY KEY,
    artist_name VARCHAR(100),
    country VARCHAR(50)
);

--------------------------------------------------
-- Genres Table
--------------------------------------------------
CREATE TABLE genres (
    genre_id INT IDENTITY(1,1) PRIMARY KEY,
    genre_name VARCHAR(50)
);

--------------------------------------------------
-- Songs Table
--------------------------------------------------
CREATE TABLE songs (
    song_id INT IDENTITY(1,1) PRIMARY KEY,
    song_name VARCHAR(150),
    artist_id INT,
    genre_id INT,
    duration_seconds INT,
    release_year INT,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

--------------------------------------------------
-- Users Table
--------------------------------------------------
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    user_name VARCHAR(100),
    country VARCHAR(50)
);

--------------------------------------------------
-- Listening History Table
--------------------------------------------------
CREATE TABLE listening_history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    song_id INT,
    listen_date DATE,
    listen_duration_seconds INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (song_id) REFERENCES songs(song_id)
);

--------------------------------------------------
-- Insert Artists
--------------------------------------------------
INSERT INTO artists (artist_name, country)
VALUES
('Taylor Swift', 'USA'),
('Drake', 'Canada'),
('Arijit Singh', 'India'),
('Adele', 'UK'),
('Ed Sheeran', 'UK');

--------------------------------------------------
-- Insert Genres
--------------------------------------------------
INSERT INTO genres (genre_name)
VALUES
('Pop'),
('Hip-Hop'),
('Romantic'),
('Rock');

--------------------------------------------------
-- Insert Songs
--------------------------------------------------
INSERT INTO songs (song_name, artist_id, genre_id, duration_seconds, release_year)
VALUES
('Love Story', 1, 1, 230, 2008),
('Gods Plan', 2, 2, 198, 2018),
('Tum Hi Ho', 3, 3, 262, 2013),
('Hello', 4, 1, 295, 2015),
('Shape of You', 5, 1, 263, 2017),
('Perfect', 5, 3, 270, 2017),
('Rolling in the Deep', 4, 4, 228, 2011);

--------------------------------------------------
-- Insert Users
--------------------------------------------------
INSERT INTO users (user_name, country)
VALUES
('User_A', 'USA'),
('User_B', 'India'),
('User_C', 'UK'),
('User_D', 'Canada'),
('User_E', 'Australia');

--------------------------------------------------
-- Insert Listening History
--------------------------------------------------
INSERT INTO listening_history (user_id, song_id, listen_date, listen_duration_seconds)
VALUES
(1, 1, GETDATE()-5, 200),
(2, 3, GETDATE()-4, 260),
(3, 4, GETDATE()-3, 280),
(4, 2, GETDATE()-2, 190),
(5, 5, GETDATE()-1, 260),
(2, 6, GETDATE()-6, 250),
(3, 7, GETDATE()-7, 220),
(1, 5, GETDATE()-8, 260),
(4, 1, GETDATE()-9, 230),
(5, 3, GETDATE()-10, 260);
