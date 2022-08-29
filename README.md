# docker-glpi
Docker container GLPI Version 10.0.2

<p> Just <b>GLPI</b></p>

<p> You need MySql or Mariadb</p>

<h1> Deploy with docker-compose </h1>

<pre><code>
services:
  glpi:
    image: gstrtoint/glpi_isofttec:1.0
    container_name: glpi
    restart: always
    hostname: glpi
    ports:
      - "8000:80"
    volumes:
      - "/opt/docker/glpi:/var/www/html/glpi"
    environment:
      TZ: "America/Sao_Paulo"
</code></pre>

<h4>Post installation</h4>
<h5>Access container with:</h5> <code>docker exec -it glpi /bin/bash</code><h5>go to /var/www/html/glpi and:</h5>

Once GLPI has been installed, you’re almost done.

An extra step would be to secure (or remove) installation directory. As an example, you can consider adding the following to your Apache virtual host configuration (or in the glpi/install/.htaccess file)

With this example found in the link below, the install directory access will be limited to localhost only and will display an error message otherwise. Of course, you may have to adapt this to your needs; refer to your web server’s documentation.

<p>From: <a href="https://glpi-install.readthedocs.io/en/latest/install/index.html"> https://glpi-install.readthedocs.io/en/latest/install/index.html </a></p>

<h3>Other information</h3>
<p><a href="https://glpi-project.org/documentation"> THE LATEST GLPI DOCUMENTATION </a></p>
</br>
</br>
</br>
<h5>Contact me, maybe I can help you!</h5>

Written by  adminti@isofttec.com.br or gstrtoint@gmail.com

Gilmar N. Lima
<p>Tks.</p>
