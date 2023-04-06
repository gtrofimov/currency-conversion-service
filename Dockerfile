FROM adoptopenjdk/openjdk11:alpine-slim

LABEL maintainer="gtrofimov@parasoft.com"

# Debug
# RUN apk --no-cache add curl
ENV JAVA_OPTS="-Dcurrency.exchange.url=http://exchange:8000"

WORKDIR /app

COPY /target/currency-conversion-service-0.0.1-SNAPSHOT.jar /app/currency-conversion-service.jar

EXPOSE 8100 8050

# ENTRYPOINT ["java", "-Dcurrency.exchange.url=http://exchange:8000","-jar", "currency-conversion-service.jar"]
ENTRYPOINT [ "tail", "-f", "/dev/null" ]
# ENTRYPOINT exec java $JAVA_OPTS -jar currency-conversion-service.jar