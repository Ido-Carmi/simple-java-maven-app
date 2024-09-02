FROM maven:3.8.5-openjdk-17 AS brick
COPY . .
RUN mvn clean verify -f pom.xml
RUN ls
FROM openjdk:24-slim
COPY --from=brick target/my-app*.jar .
CMD java -jar my-app*.jar
