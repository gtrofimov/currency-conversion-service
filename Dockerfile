FROM openjdk:11.0-jdk

LABEL maintainer="gtrofimov@parasoft.com"

RUN apk --no-cache add curl

WORKDIR /app

COPY /target/currency-conversion-service-0.0.1-SNAPSHOT.jar /app/currency-conversion-service.jar

EXPOSE 8100 8000

ENTRYPOINT ["java", "-Dcurrency.exchange.url=http://currency_exchange_service:8000","-jar", "currency-conversion-service.jar"]