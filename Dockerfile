FROM php:7.3-apache

ENV MESSAGE="Default message"

COPY src/ /var/www/html/

EXPOSE 80