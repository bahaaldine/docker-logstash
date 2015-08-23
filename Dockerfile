FROM java:8
MAINTAINER Bahaaldine Azarmi <baha@elastic.co>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y supervisor curl

# Adding logstash to source list
RUN \
    apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4 && \
    if ! grep "logstash" /etc/apt/sources.list; then echo "deb http://packages.elasticsearch.org/logstash/1.5/debian stable main" >> /etc/apt/sources.list;fi && \
    apt-get update

# Logstash
RUN apt-get install -y logstash && \
    apt-get clean

ADD etc/supervisor/conf.d/logstash.conf /etc/supervisor/conf.d/logstash.conf

EXPOSE 5043

CMD [ "/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf" ]

