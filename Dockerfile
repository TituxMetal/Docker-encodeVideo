FROM cellofellow/ffmpeg

VOLUME /var/www

COPY startConvert.sh /bin/startConvert.sh

WORKDIR /var/www

RUN usermod -u 1000 www-data

CMD ["/bin/bash", "-e", "startConvert.sh"]
