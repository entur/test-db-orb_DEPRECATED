###
### For reference
### This is the dockerfile that mysql-start uses
### It builds a server from a .sql file, then uses a new image with data prepopulated
### This saves on initial load and script execution
###
FROM circleci/mysql:8 as builder
RUN ["sed", "-i", "s/exec \"$@\"/echo \"not running $@\"/", "/usr/local/bin/docker-entrypoint.sh"]
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=testdb
ENV MYSQL_USER=dbuser
ENV MYSQL_PASSWORD=dbpword
COPY all_db.sql /docker-entrypoint-initdb.d/
RUN ["/usr/local/bin/docker-entrypoint.sh", "mysqld", "--datadir", "/initialized-db"]
FROM mysql:8
COPY --from=builder /initialized-db /var/lib/mysql

# This works:
#   docker run -p 3306:3306 --name test-db  -e MYSQL_ROOT_PASSWORD=root -d my-sql-test-db
#   docker run --rm --link test-db:mysqlsrv imega/mysql-client mysql --host=localhost --user=root --password=root --database=testdb --execute='show tables;'  