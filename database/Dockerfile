FROM mysql:8.0

COPY ./database/init.sql /docker-entrypoint-initdb.d/

ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=youraws_db
ENV MYSQL_USER=youraws_user
ENV MYSQL_PASSWORD=youraws_password

EXPOSE 3306
