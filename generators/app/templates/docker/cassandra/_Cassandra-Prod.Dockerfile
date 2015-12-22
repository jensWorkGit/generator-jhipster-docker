FROM cassandra:<%= dockerVersionDB %>

# add scripts cql
ADD src/main/resources/config/cql/ /cql/

# concat 2 scripts to 1
RUN cat /cql/create-keyspace-prod.cql > create-keyspace-tables.cql
RUN echo "USE <%=baseName%>;" >> create-keyspace-tables.cql
RUN cat /cql/create-tables.cql >> create-keyspace-tables.cql
RUN cat /cql/*_added_entity_*.cql >> create-keyspace-tables.cql

# init, for easier docker exec
RUN echo "#!/bin/bash" > /usr/local/bin/init
RUN echo "cqlsh -f create-keyspace-tables.cql" >> /usr/local/bin/init
RUN chmod 755 /usr/local/bin/init
