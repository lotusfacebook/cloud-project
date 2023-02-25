FROM openjdk:19
VOLUME /tmp
EXPOSE 8080
ARG JAR_FILE=target/react-and-spring-data-rest-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]