FROM gradle:8.8.0-jdk21

WORKDIR /app
COPY . .

RUN ./gradlew clean build -x test --no-daemon bootJar

EXPOSE 8080

CMD java \
  -jar /app/build/libs/weighted-0.0.1-SNAPSHOT.jar
