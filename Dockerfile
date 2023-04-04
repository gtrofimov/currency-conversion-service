FROM adoptopenjdk/openjdk11:jdk-11.0.18_10-alpine

LABEL maintainer="gtrofimov@parasoft.com"

RUN apk --no-cache add curl

WORKDIR /app

COPY /target/currency-conversion-service-0.0.1-SNAPSHOT.jar /app/currency-conversion-service.jar

EXPOSE 8100 8000

ENTRYPOINT ["java", "-Dcurrency.exchange.url=http://exchange:8000","-jar", "currency-conversion-service.jar"]