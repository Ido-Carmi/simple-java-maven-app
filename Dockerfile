FROM ubuntu:oracular AS brick
RUN apt update -y
RUN apt install -y git maven curl
RUN git clone -b https://github.com/Ido-Carmi/simple-java-maven-app.git
RUN mvn clean verify -f pom.xml
#FROM openjdk:24-slim
#COPY --from=brick target/Calculator-1.0-SNAPSHOT.jar .
#CMD java -jar Calculator-1.0-SNAPSHOT.jar
