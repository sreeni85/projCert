FROM devopsedu/webapp
COPY . /var/www/html
EXPOSE 80

# Command to start the web server
CMD ["apache2ctl", "-D", "FOREGROUND"]
