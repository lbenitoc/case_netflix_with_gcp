CREATE OR REPLACE PROCEDURE `premaestriads.datasetdsuni.create_view_name_title`(table_name STRING, min_score FLOAT64)
BEGIN
  -- Define la consulta SQL dinámica para crear la vista
  DECLARE sql_query STRING;
  SET sql_query = (
    SELECT CONCAT(
      'CREATE OR REPLACE VIEW `premaestriads.datasetdsuni.view_trusted_name_title` AS ',
      'SELECT ',
      '  t.name AS name, ',
      '  t.title AS title, ',
      '  AVG(t.imdb_score) AS mean_imdb_score, ',
      '  AVG(t.tmdb_score) AS mean_tmdb_score ',
      'FROM ',
      '    ', table_name, ' t ',
      'GROUP BY ',
      '  t.name, ',
      '  t.title ',
      'HAVING AVG(t.imdb_score) > ', CAST(min_score AS STRING), ' ',
      '  AND AVG(t.tmdb_score) > ', CAST(min_score AS STRING), ' ',
      'ORDER BY ',
      '  name, ',
      '  mean_imdb_score DESC, ',
      '  mean_tmdb_score DESC;')
  );

  -- Ejecuta la consulta SQL dinámica para crear la vista
  EXECUTE IMMEDIATE sql_query;

  EXPORT DATA OPTIONS(
  uri='gs://bucket-datalake-dsuni/trusted/name_title/*.csv',
  format='CSV',
  overwrite=true
  ) AS
  SELECT *
  FROM `premaestriads.datasetdsuni.view_trusted_name_title`;

END;

CALL `premaestriads.datasetdsuni.create_view_name_title`('`premaestriads.datasetdsuni.detalle`',6.0)