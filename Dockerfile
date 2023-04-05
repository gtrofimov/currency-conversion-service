FROM openjdk:11.0.11-jre-slim

LABEL maintainer="gtrofimov@parasoft.com"

# Debug
# RUN apk --no-cache add curl

WORKDIR /app

COPY /target/currency-conversion-service-0.0.1-SNAPSHOT.jar /app/currency-conversion-service.jar

EXPOSE 8100 8000 8050

# ENTRYPOINT ["java", "-Dcurrency.exchange.url=http://exchange:8000","-jar", "currency-conversion-service.jar"]
ENTRYPOINT exec java $JAVA_OPTS -Dcurrency.exchange.url=http://exchange:8000 -jar currency-exchange-service.jar