-- Top 10 songs
CREATE OR REPLACE VIEW top_10_songs AS
SELECT SUM(ms_played) AS time_played, master_metadata_track_name, master_metadata_album_artist_name
FROM working_data
GROUP BY master_metadata_track_name, master_metadata_album_artist_name
ORDER BY time_played DESC LIMIT 10;

-- Top 10 artists
CREATE OR REPLACE VIEW top_10_artists AS
SELECT COUNT(*) AS count ,master_metadata_album_artist_name
FROM working_data
GROUP BY master_metadata_album_artist_name
ORDER BY count DESC LIMIT 10;

-- MS listened per year (started March 31st, 2013
CREATE OR REPLACE VIEW ms_per_year AS
SELECT YEAR(ts) as year, SUM(ms_played) as time_played
FROM working_data
GROUP BY YEAR(ts)
ORDER BY time_played DESC;

-- Top 5 songs per year
CREATE OR REPLACE VIEW top_songs_per_year AS
WITH song_ranking AS (
	SELECT 
		master_metadata_track_name, master_metadata_album_artist_name, 
		YEAR(ts) song_year, 
		SUM(ms_played) AS time_played,
		RANK() OVER(PARTITION BY YEAR(ts) ORDER BY SUM(ms_played) DESC) AS song_rank
	FROM working_data
	GROUP BY master_metadata_track_name, master_metadata_album_artist_name, YEAR(ts)
)

-- Group platforms into categories
ALTER TABLE working_data ADD COLUMN grouped_platform VARCHAR(50);
UPDATE working_data
SET grouped_platform = 
    CASE 
        WHEN platform LIKE '%iPhone%' THEN 'iPhone'
        WHEN platform LIKE '%iPad%' THEN 'iPad'
        WHEN platform LIKE '%WebPlayer%' OR platform LIKE '%web%' THEN 'Web Player'
        WHEN platform LIKE '%Windows%' THEN 'Windows'
        WHEN platform LIKE '%OS X%' OR platform LIKE 'osx' THEN 'Mac'
        WHEN platform LIKE '%Amazon%' OR platform LIKE '%Echo_Dot%' THEN 'Amazon Echo'
        WHEN platform LIKE '%sony_tv%' OR platform LIKE '%ps5%' THEN 'PlayStation'
        WHEN platform LIKE 'not_applicable' THEN 'Unknown'
        ELSE 'Other'
    END;