CREATE OR REPLACE PROCEDURE `premaestriads.datasetdsuni.create_view_genero_name`(table_name STRING, min_score FLOAT64)
BEGIN
  -- Define la consulta SQL dinámica para crear la vista
  DECLARE sql_query STRING;

  -- Define la consulta SQL dinámica para crear la vista
  SET sql_query = (
    SELECT CONCAT(
      'CREATE OR REPLACE VIEW `premaestriads.datasetdsuni.view_trusted_genero_name` AS ',
      'SELECT ',
      '  genero_value, ',
      '  name, ',
      '  SUM(imdb_score) AS sum_imdb_score, ',
      '  SUM(tmdb_score) AS sum_tmdb_score ',
      'FROM (',
      '  SELECT ',
      '    t.name AS name, ',
      '    genero.element AS genero_value, ',
      '    t.imdb_score AS imdb_score, ',
      '    t.tmdb_score AS tmdb_score ',
      '  FROM ',
      '    ', table_name, ' t, ',
      '    UNNEST(t.genres_array.list) AS genero ',
      '  WHERE ',
      '    t.imdb_score > 7 ',
      '    AND t.tmdb_score > 7 ',
      ') ',
      'GROUP BY ',
      '  genero_value, ',
      '  name ',
      'HAVING ',
      '  genero_value = "family" ',
      'ORDER BY ',
      '  name, ',
      '  sum_imdb_score DESC, ',
      '  sum_tmdb_score DESC;')
  );

  -- Ejecuta la consulta SQL dinámica para crear la vista
  EXECUTE IMMEDIATE sql_query;

  EXPORT DATA OPTIONS(
  uri='gs://bucket-datalake-dsuni/trusted/genero_name/*.csv',
  format='CSV',
  overwrite=true
  ) AS
  SELECT *
  FROM `premaestriads.datasetdsuni.view_trusted_genero_name`;

END;

CALL `premaestriads.datasetdsuni.create_view_genero_name`('`premaestriads.datasetdsuni.detalle`', 7.0)