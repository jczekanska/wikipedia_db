#!/bin/bash

CSV_FILE="file:///taxonomy_iw.csv"

# Define the Cypher queries
CREATE_CONSTRAINT_QUERY="CREATE CONSTRAINT name_index IF NOT EXISTS FOR (a:Category) REQUIRE a.name IS UNIQUE;"
IMPORT_DATA_QUERY="CALL apoc.periodic.iterate(
  'LOAD CSV FROM \"$CSV_FILE\" AS line RETURN line',
  '
  MERGE (parent:Category {name:line[0]})
  MERGE (child:Category {name:line[1]})
  CREATE (parent)-[:PARENTCAT_TO]->(child)
  ',
  {batchSize:5000, parallel:false}
);"

echo "Connecting to Neo4j and performing import..."

{
  echo $CREATE_CONSTRAINT_QUERY
  echo $IMPORT_DATA_QUERY
} | cypher-shell -a db -u neo4j -p password

if [ $? -eq 0 ]; then
  echo "Data import was successful."
else
  echo "Data import failed."
fi
