FROM moul/node
MAINTAINER Manfred Touron "m@42.am"

RUN apt-get -qq -y install make && \
    apt-get clean

ADD . /app/
WORKDIR /app
RUN npm install --production
