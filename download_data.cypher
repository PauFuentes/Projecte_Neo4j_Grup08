//Habitatges

LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vT0ZhR6BSO_M72JEmxXKs6GLuOwxm_Oy-0UruLJeX8_R04KAcICuvrwn2OENQhtuvddU5RSJSclHRJf/pub?output=csv' AS row
WITH row.Municipi AS Municipi, toInteger(row.Id_Llar) AS Id_Llar, toInteger(row.Any_Padro) AS Any_Padro, row.Carrer AS Carrer, toInteger(row.Numero) AS Numero
WHERE Id_Llar IS NOT NULL
MERGE (h:Habitatge {Municipi: Municipi, Id: Id_Llar, Any_Padro: Any_Padro, Carrer: Carrer, Numero: CASE WHEN Numero IS NULL THEN -1 ELSE Numero END})
RETURN COUNT(h)

/ * if we want to have the places where municipi is not null, not used for this project */
LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vT0ZhR6BSO_M72JEmxXKs6GLuOwxm_Oy-0UruLJeX8_R04KAcICuvrwn2OENQhtuvddU5RSJSclHRJf/pub?output=csv' AS row
WITH row.Municipi AS Municipi, toInteger(row.Id_Llar) AS Id_Llar, toInteger(row.Any_Padro) AS Any_Padro, row.Carrer AS Carrer, toInteger(row.Numero) AS Numero
WHERE Id_Llar IS NOT NULL AND Numero IS NOT NULL
MERGE (h:Habitatge {Municipi: Municipi, Id: Id_Llar, Any_Padro: Any_Padro, Carrer: Carrer, Numero: Numero})
RETURN COUNT(h) 

CREATE CONSTRAINT UniqueHabitatgeIdConstraint FOR (h:Habitatge) REQUIRE (h.Id, h.Any_Padro) IS NODE KEY



//Individus

LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTfU6oJBZhmhzzkV_0-avABPzHTdXy8851ySDbn2gq32WwaNmYxfiBtCGJGOZsMgCWjzlEGX4Zh1wqe/pub?output=csv' AS row WITH toInteger(row.Id) AS Id_Individu, toInteger(row.Year) AS Any_Individu, row.name AS Nom, row.surname AS Cognom, row.second_surname AS Segon_Cognom WHERE Id_Individu IS NOT NULL MERGE (i:Individu{Id: Id_Individu, Any_Padro: Any_Individu, Nom: Nom, Cognom: Cognom, Segon_Cognom: Segon_Cognom}) RETURN COUNT(i)

CREATE CONSTRAINT UniqueIndividuIdConstraint FOR (i:Individu) REQUIRE i.Id IS UNIQUE

CREATE CONSTRAINT ExistsIndividuId FOR (i:Individu) REQUIRE i.Id IS NOT NULL



//Individus—Familia—>Individus

LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRVOoMAMoxHiGboTjCIHo2yT30CCWgVHgocGnVJxiCTgyurtmqCfAFahHajobVzwXFLwhqajz1fqA8d/pub?output=csv' AS row WITH toInteger(row.ID_1) AS Id_1, toInteger(row.ID_2) AS Id_2, row.Relacio AS Relacio, row.Relacio_Harmonitzada AS Relacio_Harmonitzada WHERE Id_1 IS NOT NULL AND Id_2 IS NOT NULL MATCH (i:Individu{Id:Id_1}) MATCH (o:Individu{Id:Id_2}) MERGE (i)-[rel:FAMILIA{Relacio:Relacio, Relacio_Harmonitzada:Relacio_Harmonitzada}]->(o) RETURN COUNT(rel)



//Individus—Same_As—>Individus

LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTgC8TBmdXhjUOPKJxyiZSpetPYjaRC34gmxHj6H2AWvXTGbg7MLKVdJnwuh5bIeer7WLUi0OigI6wc/pub?output=csv' AS row WITH toInteger(row.Id_A) AS Id_1, toInteger(row.Id_B) AS Id_2 WHERE Id_1 IS NOT NULL AND Id_2 IS NOT NULL MATCH (i:Individu{Id:Id_1}) MATCH (o:Individu{Id:Id_2}) MERGE (i)<-[rel:SAME_AS]->(o) RETURN COUNT(rel)



//Individus—Viu—>Habitatges:

LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRM4DPeqFmv7w6kLH5msNk6_Hdh1wuExRirgysZKO_Q70L21MKBkDISIyjvdm8shVixl5Tcw_5zCfdg/pub?output=csv' AS row WITH toInteger(row.IND) AS Id_Individu, toInteger(row.HOUSE_ID) AS Id_Llar, toInteger(row.Year) AS AnyC, row.Location AS Loc
MATCH (p:Individu{Id:Id_Individu})
MATCH (h:Habitatge{Id:Id_Llar,Any_Padro:AnyC,Municipi:Loc})
MERGE (p)-[rel:VIU{Localitzacio:Loc,Any_Habitatge:AnyC}]->(h)
RETURN COUNT(rel)

