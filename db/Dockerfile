FROM neo4j:latest

USER root
WORKDIR /

# Run the installation of the required packages
RUN apt-get update -y \
    && apt-get install -y vim gzip

# Import starting data and unzip it
COPY /setup-data/taxonomy_iw.csv.gz /var/lib/neo4j/import
COPY /setup-data/neo4j.conf /var/lib/neo4j/conf
RUN cp /var/lib/neo4j/labs/apoc*.jar /var/lib/neo4j/plugins/

# Reset working directory
WORKDIR /var/lib/neo4j

# Set up system variables
ENV NEO4J_AUTH=neo4j/password 
ENV NEO4J_ACCEPT_LICENSE_AGREEMENT=yes 
ENV NEO4J_EDITION=community
ENV NEO4J_HOME=/var/lib/neo4j

EXPOSE 7474 7473 7687 

CMD [ "neo4j" ]