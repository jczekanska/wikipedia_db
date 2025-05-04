# Project Description

The following project is a tool integrating separate Neo4j and Linux containers to manage and interact with a graph database filled with Wikipedia categories. This tool allows users to deploy and configure a Neo4j instance within a Linux container and execute database commands through a shell utility. The project aims to demonstrate containerized database management and seamless command execution within a controlled environment, independent of the host's operating system.

## Badges

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white) ![Neo4J](https://img.shields.io/badge/Neo4j-008CC1?style=for-the-badge&logo=neo4j&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white) ![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

## Requirements

- Docker engine installed
- 2 GB of free disk space

# Installation guide

## Installing Docker

Download [Docker](https://www.docker.com/products/docker-desktop/) engine from the offical website.

Follow the installation instructions provided for your operating system.

Verify the installation by running the following command in your terminal:

```
docker info
```

## Setup

### Building the application

Clone this repository into a designated folder, proceed to the newly created folder, and run the following commands to build and boot up both containers:

```
docker-compose build
```

### Starting up containers

After a successful build of both containers, run them with:

```
docker-compose up -d
```

### Access to developer console on a system container

The provided utility can be accessed via the developer console of a Docker container with Ubuntu installed.
To enter the developer console, run:

```
docker exec -it system bash 
```

Which will provide access to said console.

### Populating the database

To populate the database with Wikipedia categories as nodes in the Docker console, launch the `import.sh` file located in `/home/dbuser/scripts` with the command `./import.sh` (this may take a while).
This script uses the Neo4j APOC library and imports the nodes and relationships in batches.

# Usage

Provided utility enables the user to run predetermined queries on the database.
To run the utility, launch the `dbcli.sh` file located in `/home/dbuser/scripts` with the command `./dbcli.sh`.

When inside the utility, its name is displayed. Provide the number of the chosen query and node names if required (depending on the chosen task).
Below is an example of the first query with node *1880s_films*:

```
dbcli 1 "1880s_films"
```

## Exemplary commands

Number of parameters depends on the query number chosen from listed below:

#### Query 1 (node_name_1)
Lists all children of a given node
#### Query 2 (node_name_1)
Counts number of children of a given node
#### Query 3 (node_name_1)
Lists all grandchildren of a given node
#### Query 4 (node_name_1)
Lists all parents of a given node
#### Query 5 (node_name_1)
Counts number of parents of a given node
#### Query 6 (node_name_1)
Lists all grandparents of a given node
#### Query 7
Counts how many uniquely named nodes exist
#### Query 8
Lists root nodes (ones without a subcategory)
#### Query 9
Lists all nodes with the most children
#### Query 10
Lists all nodes with the least children (minimum 1)
#### Query 11 (node_name_1) (node_name_2)
Renames a node to a specified name
#### Query 12 (node_name_1) (node_name_2)
Finds all paths between two given nodes, with directed edges from the first to the second node

## Additional commands

To get overall information about the utility, additional commands are provided:

- General help
  Usage: `dbcli help`
- Information about available queries
  Usage: `dbcli info`

To exit the utility, enter the following command:
`dbcli exit`

## Elapsed times

Here, we provide the time each query takes in **milliseconds**. The initial execution of a query is always longer, as subsequent executions benefit from caching.

|   Query ID|   Run no. 1|   Run no. 2|   Run no. 3|   Avg. time|
|-----------|------------|------------|------------|------------|
|          1|         140|           2|           2|          48|
|          2|         147|           2|           2|         50⅓|
|          3|         143|           1|           2|         48⅔|
|          4|          61|           2|           2|         21⅔|
|          5|          66|           2|           2|         23⅓|
|          6|          82|           2|           1|         28⅓|
|          7|          57|           1|           2|          20|
|          8|         106|           2|           1|         36⅓|
|          9|         136|           2|           2|         46⅔|
|         10|         109|           2|           2|         37⅔|
|         11|         129|          12|           2|         47⅔|
|         12|          53|          44|          52|         49⅔|

All measurements were taken on a machine with the following hardware specification:
- Processor: Ryzen 7 6800 HS 16 Cores; all 16 of which were allocated to Docker Desktop
- RAM allocated to Docker Desktop: 7.21 GB

# Additional Information

## Choice of Technology

### Why Neo4j and Bash?

Neo4j was chosen due to its powerful graph database capabilities, which are ideal for handling highly connected data and complex queries. It provides efficient data storage, retrieval, and relationship management, making it a suitable choice for this project.

Bash scripting was selected for its simplicity and widespread use in automating command-line tasks. It allows for seamless interaction with the Linux environment and efficient execution of shell commands necessary for managing the Docker containers and Neo4j instance.

## Database architecture

![Database architectiore](architecture.png?raw=true)

The project utilizes a simple yet effective graph database schema to represent Wikipedia categories. In this schema:

- Each Wikipedia category is represented as a node with a single label `Category`. Each node has a `name` attribute that stores the category name.

- Connections between categories are represented by edges with a single label `PARENTCAT_TO`.

# License

Copyright (c) 2024 Julia Czekańska

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
