FROM openjdk:11.0.11-jre-slim

LABEL maintainer="gtrofimov@parasoft.com"

WORKDIR /app

COPY /target/currency-conversion-service-0.0.1-SNAPSHOT.jar /app/currency-conversion-service.jar

EXPOSE 8100

ENTRYPOINT ["java", "-Dcurrency.exchange.url=http://localhost:8000","-jar", "currency-conversion-service.jar"]