CREATE OR REPLACE PROCEDURE `premaestriads.datasetdsuni.create_view_name_genero_role`(table_name STRING, min_score FLOAT64)
BEGIN
  -- Define la consulta SQL dinámica para crear la vista
  DECLARE sql_query STRING;
  SET sql_query = (
    SELECT CONCAT(
      'CREATE OR REPLACE VIEW `premaestriads.datasetdsuni.view_trusted_name_genero_role` AS ',
      'SELECT ',
      '  name, ',
      '  genero_value, ',
      '  role, ',
      '  AVG(imdb_score) AS mean_imdb_score, ',
      '  AVG(tmdb_score) AS mean_tmdb_score ',
      'FROM (',
      '  SELECT ',
      '    t.name AS name, ',
      '    t.role AS role, ',
      '    genero.element AS genero_value, ',
      '    t.imdb_score AS imdb_score, ',
      '    t.tmdb_score AS tmdb_score ',
      '  FROM ',
      '    ', table_name, ' t, ',
      '    UNNEST(t.genres_array.list) AS genero ',
      ') ',
      'GROUP BY ',
      '  name, ',
      '  genero_value, ',
      '  role ',
      'HAVING AVG(imdb_score) > ', CAST(min_score AS STRING), ' ',
      '  AND AVG(tmdb_score) > ', CAST(min_score AS STRING), ' ',
      '  AND role = "DIRECTOR" ',
      'ORDER BY ',
      '  genero_value, ',
      '  mean_imdb_score DESC, ',
      '  mean_tmdb_score DESC;')
  );

  -- Ejecuta la consulta SQL dinámica para crear la vista
  EXECUTE IMMEDIATE sql_query;

  EXPORT DATA OPTIONS(
  uri='gs://bucket-datalake-dsuni/trusted/name_genero_role/*.csv',
  format='CSV',
  overwrite=true
  ) AS
  SELECT *
  FROM `premaestriads.datasetdsuni.view_trusted_name_genero_role`;

END;

CALL `premaestriads.datasetdsuni.create_view_name_genero_role`('`premaestriads.datasetdsuni.detalle`',8.0)