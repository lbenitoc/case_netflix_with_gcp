EXPORT DATA
OPTIONS(
  uri='gs://bucket-datalake-dsuni/common/credits/*.parquet',
  format='PARQUET'
)
AS
(
  SELECT
  RIGHT(CONCAT('0000000',t.person_id), 7) as person_id,
  t.id as id,
  UPPER(t.name) as name,
  UPPER(t.character) as character,
  t.role as role
  FROM `premaestriads.datasetdsuni.raw_credits` t)
;