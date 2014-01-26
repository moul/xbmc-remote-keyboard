FROM moul/node
MAINTAINER Manfred Touron "m@42.am"

RUN apt-get -qq -y install make gcc g++ && \
    apt-get clean

ADD . /app/
WORKDIR /app
RUN npm install --production
ENTRYPOINT ["node", "bin/xbmc-remote-keyboard"]
CMD ["-h"]
