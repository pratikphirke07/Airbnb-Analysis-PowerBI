SELECT
[Name 1]
  FROM [PulsarSerialNo].[dbo].[customer]

  where len([Name 1]) >  40

SELECT
[Street] , len([Street])
  FROM [PulsarSerialNo].[dbo].[customer]

  where len([Street]) > 40

  -----------------------------------------------------
select len('Piazza delle Regioni,5Colle di Vald Elsa')