CREATE TABLE IF NOT EXISTS `premaestriads.datasetdsuni.detalle`
AS
(SELECT
a.person_id,
a.id,
a.name,
a.character,
a.role,
b.title,
b.type,
b.description,
b.release_year,
b.age_certification,
b.runtime,
b.genres,
b.genres_array,
b.production_countries,
b.production_countries_array,
b.seasons,
b.imdb_id,
b.imdb_score,
b.category_imdb_score,
b.imdb_votes,
b.tmdb_popularity,
b.tmdb_score, 
b.category_tmdb_score,
FROM `premaestriads.datasetdsuni.common_credits` a
FULL JOIN 
`premaestriads.datasetdsuni.common_titles` b 
ON a.id = b.id
WHERE a.id IS NOT NULL AND b.id IS NOT NULL);

CREATE TABLE IF NOT EXISTS `premaestriads.datasetdsuni.sin_cruce`
AS
(SELECT
a.person_id,
a.id,
a.name,
a.character,
a.role,
b.title,
b.type,
b.description,
b.release_year,
b.age_certification,
b.runtime,
b.genres,
b.genres_array,
b.production_countries,
b.production_countries_array,
b.seasons,
b.imdb_id,
b.imdb_score,
b.category_imdb_score,
b.imdb_votes,
b.tmdb_popularity,
b.tmdb_score, 
b.category_tmdb_score,
FROM `premaestriads.datasetdsuni.common_credits` a
FULL JOIN 
`premaestriads.datasetdsuni.common_titles` b 
ON a.id = b.id
WHERE a.id IS NULL OR b.id IS NULL);


EXPORT DATA
OPTIONS(
  uri='gs://bucket-datalake-dsuni/trusted/detalle/*.parquet',
  format='PARQUET'
)
AS (
  SELECT * FROM `premaestriads.datasetdsuni.detalle`
)