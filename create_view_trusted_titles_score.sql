CREATE OR REPLACE PROCEDURE `premaestriads.datasetdsuni.create_view_titles_score`(table_name STRING, min_score FLOAT64)
BEGIN
  -- Define la consulta SQL dinámica para crear la vista
  DECLARE sql_query STRING;
  SET sql_query = (
    SELECT CONCAT(
      'CREATE OR REPLACE VIEW `premaestriads.datasetdsuni.view_trusted_titles_score` AS ',
      'SELECT ',
      '  t.title AS title, ',
      '  AVG(t.imdb_score) AS mean_imdb_score, ',
      '  AVG(t.tmdb_score) AS mean_tmdb_score ',
      'FROM ',
      '    ', table_name, ' t ',
      'GROUP BY ',
      '  t.title ',
      'HAVING AVG(t.imdb_score) > ', CAST(min_score AS STRING), ' ',
      '  AND AVG(t.tmdb_score) > ', CAST(min_score AS STRING), ' ',
      'ORDER BY ',
      '  mean_imdb_score DESC, ',
      '  mean_tmdb_score DESC ',
      'LIMIT 50;')
  );

  -- Ejecuta la consulta SQL dinámica para crear la vista
  EXECUTE IMMEDIATE sql_query;

  EXPORT DATA OPTIONS(
  uri='gs://bucket-datalake-dsuni/trusted/titles_score/*.csv',
  format='CSV',
  overwrite=true
  ) AS
  SELECT *
  FROM `premaestriads.datasetdsuni.view_trusted_titles_score`;

END;

CALL `premaestriads.datasetdsuni.create_view_titles_score`('`premaestriads.datasetdsuni.detalle`',8.0)