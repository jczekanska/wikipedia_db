FROM ubuntu:22.04

# Set user as superuser
USER root
WORKDIR /

# Install required system packages
RUN apt-get update -y \
    && apt-get install -y iputils-ping net-tools tree vim sudo wget gnupg2 

RUN useradd -ms /bin/bash dbuser \
    && usermod -aG root dbuser 

# Add cypher-shell keys and update application repository 
RUN wget -qO - https://debian.neo4j.com/neotechnology.gpg.key | gpg --dearmor -o /usr/share/keyrings/neo4j-archive-keyring.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/neo4j-archive-keyring.gpg] https://debian.neo4j.com stable 5' > /etc/apt/sources.list.d/neo4j.list \
    && apt-get update -y \
    && apt-get install -y cypher-shell

# Create a directory to map user-defined scripts to
USER dbuser
WORKDIR /home/dbuser
RUN mkdir scripts

# Create alias for cypher-shell
USER root
WORKDIR /root
RUN touch .bash_aliases \
    && echo "alias cypher='cypher-shell -u neo4j -p password -a db'" >> .bash_aliases

# Set working directory as the one containing scripts
WORKDIR /home/dbuser/scripts

# Expose connection port
EXPOSE 3000