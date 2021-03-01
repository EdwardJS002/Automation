FROM ubuntu:latest

##############
# BUILD TIME #
##############

RUN apt-get -y update
RUN apt-get -y upgrade
##RUN  apt-get install -y sqlite3 libsqlite3-dev nodejs npm gammu gammu-smsd libdbd-sqlite3

##RUN apt-get install -y npm nodejs

RUN apt-get install -y nodejs

RUN sh -c "mkdir SMS-API"
COPY ./ ./SMS-API

############
# RUN TIME #
############

CMD [ "npm", "run", "start" ]
