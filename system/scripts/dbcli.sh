#!/bin/bash

# TODO
echo "Addidtional commands:"
echo "help -> Instructions on how to use the utility"
echo "info -> List of available queries"
echo "exit -> Exit the utility"

run_query() {
  local query=$1
  cypher-shell -a db -u neo4j -p password "$query"
}

while : ; do
  read -p "dbcli " cmd

  # Split the input into parts
  IFS=' ' read -r -a parts <<< "$cmd"
  command="${parts[0]}" # query number or another command
  node_name1="${parts[1]}"
  node_name2="${parts[2]}"

  # Remove quotation marks
  node_name1="${node_name1%\"}"
  node_name1="${node_name1#\"}"
  node_name2="${node_name2%\"}"
  node_name2="${node_name2#\"}"

  case $command in
    1)
      # Finds all children of a given node
      if [ -z "$node_name1" ]; then
        echo "Error: Please provide the node name."
      else
        run_query "MATCH (parent:Category {name: '$node_name1'})-[:PARENTCAT_TO]->(child:Category) RETURN child"
      fi
      ;;
    2)
      # Counts all children of a given node
      if [ -z "$node_name1" ]; then
        echo "Error: Please provide the node name."
      else
        run_query "MATCH (parent:Category {name: '$node_name1'})-[:PARENTCAT_TO]->(child:Category) RETURN count(child) AS childCount"
      fi
      ;;
    3)
      # Finds all grand children of a given node
      if [ -z "$node_name1" ]; then
        echo "Error: Please provide the node name."
      else
        run_query "MATCH (parent:Category {name: '$node_name1'})-[:PARENTCAT_TO]->(child:Category)-[:PARENTCAT_TO]->(grandchild:Category) RETURN grandchild"
      fi
      ;;
    4)
      # Finds all parents of a given node
      if [ -z "$node_name1" ]; then
        echo "Error: Please provide the node name."
      else
        run_query "MATCH (parent:Category)-[:PARENTCAT_TO]->(child:Category {name: '$node_name1'}) RETURN parent"
      fi
      ;;
    5)
      # Counts all parents of a given node
      if [ -z "$node_name1" ]; then
        echo "Error: Please provide the node name."
      else
        run_query "MATCH (child:Category {name: '$node_name1'})<-[:PARENTCAT_TO]-(parent:Category) RETURN count(parent) AS numberOfParents"
      fi
      ;;
    6)
      # Finds all grand parents of a given node
      if [ -z "$node_name1" ]; then
        echo "Error: Please provide the node name."
      else
        run_query "MATCH (grandparent:Category)-[:PARENTCAT_TO]->(parent:Category)-[:PARENTCAT_TO]->(child:Category {name: '$node_name1'}) RETURN grandparent"
      fi
      ;;
    7)
      # Counts how many uniquely named nodes there are
      run_query "MATCH (n:Category) RETURN count(DISTINCT n.name) AS uniqueNodeCount"
      ;;
    8)
      # Finds a root node, one which is not a subcategory of any other node
      run_query "MATCH (root:Category) WHERE NOT ()-[:PARENTCAT_TO]->(root:Category) RETURN root"
      ;;
    9)
      # Finds nodes with the most children, there could be more the one
      run_query "MATCH (parent:Category)-[:PARENTCAT_TO]->(child:Category) WITH parent, count(child) AS numberOfChildren ORDER BY numberOfChildren DESC WITH numberOfChildren, collect(parent.name) AS parents, max(numberOfChildren) AS maxChildren WHERE numberOfChildren = maxChildren RETURN parents, numberOfChildren LIMIT 1"
      ;;
    10)
      # Finds nodes with the least children (number of children is greater than zero), there could be more the one
      run_query "MATCH (parent:Category)-[:PARENTCAT_TO]->(child:Category) WITH parent, COUNT(child) AS ChildCount WHERE ChildCount > 0 WITH min(ChildCount) AS minChildren MATCH (parent:Category)-[:PARENTCAT_TO]->(child:Category) WITH parent, COUNT(child) AS ChildCount, minChildren WHERE ChildCount = minChildren RETURN parent.name AS ParentName, ChildCount" 
      ;;
    11)
      # Renames a given node
      if [ -z "$node_name1" ] || [ -z "$node_name2" ]; then
        echo "Error: Please provide the old and new node names."
      else
        run_query "MATCH (n:Category {name: '$node_name1'}) SET n.name = '$node_name2' RETURN n"
      fi
      ;;
    12)
      # Finds all paths between two given nodes, with directed edges from the first to the second node.
      if [ -z "$node_name1" ] || [ -z "$node_name2" ]; then
        echo "Error: Please provide both start and end node names."
      else
        run_query "MATCH p = (start:Category {name: '$node_name1'})-[:PARENTCAT_TO*]->(end:Category {name: '$node_name2'}) RETURN p"
      fi
      ;;
    "help")
      echo "Queries' 1-6 usage pattern is: <query_number> <node_name>"
      echo "Queries' 6-10 usage pattern is: <query_number>"
      echo "Queries' 11-12 usage pattern is: <query_number> <node_name_1> <node_name_2>"
      ;;
    "info")
      echo "Query 1: All children of a given node"
      echo "Query 2: Number of children of a given node"
      echo "Query 3: All grandchildren of a given node"
      echo "Query 4: All parents of a given node"
      echo "Query 5: Number of parents of a given node"
      echo "Query 6: All grandparents of a given node"
      echo "Query 7: How many uniquely named nodes exist"
      echo "Query 8: List of root nodes (ones without a subcategory)"
      echo "Query 9: Nodes with the most children"
      echo "Query 10: First 1000 nodes with the least children"
      echo "Query 11: Rename a node"
      echo "Query 12: All paths between two given nodes, with directed edges from the first to the second node"
      ;;
    "exit")
      break
      ;;
    *)
      echo "Invalid input"
      ;;
  esac
done
