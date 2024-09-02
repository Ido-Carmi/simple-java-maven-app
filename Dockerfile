FROM ubuntu:oracular AS brick
RUN apt update -y
RUN apt install -y git maven curl
RUN git clone -b development http://ido:glpat-Zf2pxrxtsP4uAS8EH-NB@172.31.36.166/ddd/SonarQube
RUN mvn clean verify -f pom.xml
#FROM openjdk:24-slim
#COPY --from=brick target/Calculator-1.0-SNAPSHOT.jar .
#CMD java -jar Calculator-1.0-SNAPSHOT.jar
