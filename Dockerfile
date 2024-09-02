FROM maven:3.8.5-openjdk-17 AS brick
COPY . .
#WORKDIR simple-java-maven-app
RUN ls
RUN mvn clean verify -f pom.xml
#FROM openjdk:24-slim
#COPY --from=brick target/Calculator-1.0-SNAPSHOT.jar .
#CMD java -jar Calculator-1.0-SNAPSHOT.jar
