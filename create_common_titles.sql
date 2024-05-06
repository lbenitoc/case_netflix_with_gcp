EXPORT DATA
OPTIONS(
  uri='gs://bucket-datalake-dsuni/common/titles/*.parquet',
  format='PARQUET'
)
AS
(SELECT 
t.id as id,
UPPER(t.title) as title,
t.type as type,
t.description as description,
CAST(t.release_year as INT) as release_year,
t.age_certification as age_certification,
cast(t.runtime as INT) as runtime,
t.genres as genres,
ARRAY(
  SELECT TRIM(value)
  FROM UNNEST(SPLIT(SUBSTR(t.genres, 2, LENGTH(t.genres) - 2), ',')) AS value
) AS genres_array,
t.production_countries,
ARRAY(
  SELECT TRIM(value)
  FROM UNNEST(SPLIT(SUBSTR(t.production_countries, 2, LENGTH(t.production_countries) - 2), ',')) AS value
) AS production_countries_array,
CAST(t.seasons as INT) as seasons,
t.imdb_id as imdb_id,
cast(t.imdb_score as NUMERIC) as imdb_score,
CASE
WHEN t.imdb_score IS NULL THEN "sin categoria"
WHEN cast(t.imdb_score as numeric)<3 THEN "pesimo" 
WHEN cast(t.imdb_score as numeric)<5 THEN "masomenos"
WHEN cast(t.imdb_score as numeric)<8 THEN "bien"
ELSE "muy bueno"
END AS category_imdb_score,
CAST(t.imdb_votes AS INT) as imdb_votes,
CAST(t.tmdb_popularity AS NUMERIC) as tmdb_popularity,
CAST(t.tmdb_score as NUMERIC) as tmdb_score, 
CASE
WHEN t.imdb_score IS NULL THEN "sin categoria"
WHEN cast(t.tmdb_score as numeric)<3 THEN "pesimo" 
WHEN cast(t.tmdb_score as numeric)<5 THEN "masomenos"
WHEN cast(t.tmdb_score as numeric)<8 THEN "bien"
ELSE "muy bueno"
END AS category_tmdb_score,
FROM
`premaestriads.datasetdsuni.raw_titles` t
WHERE substring(t.id, 1, 1) = 't');
