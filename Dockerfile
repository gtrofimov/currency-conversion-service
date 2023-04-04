FROM openjdk:11.0.11-jre-slim

LABEL mentainer="gtrfoimov@parasoft.com"

WORKDIR /app

COPY /target/currency-conversion-service-0.0.1-SNAPSHOT.jar /app/currency-conversion-service.jar

EXPOSE 8100

ENTRYPOINT ["java","-jar", "currency-conversion-service.jar"]