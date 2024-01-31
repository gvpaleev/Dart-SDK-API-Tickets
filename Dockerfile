# # Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
# FROM dart:stable AS build

# # Resolve app dependencies.
# WORKDIR /app
# COPY pubspec.* ./
# RUN dart pub get
# # Copy app source code and AOT compile it.
# COPY . .
# # Ensure packages are still up-to-date if anything has changed
# RUN dart pub get --offline
# RUN dart compile exe bin/main_2.dart -o bin/server

# # Build minimal serving image from AOT-compiled `/server` and required system
# # libraries and configuration files stored in `/runtime/` from the build stage.
# FROM scratch
# COPY --from=build /runtime/ /
# COPY --from=build /app/bin/* /app/bin/
# COPY ./.env /

# # Start server.
# # EXPOSE 8080
# CMD ["/app/bin/server"]


# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
# COPY pubspec.* ./
# RUN dart pub get
# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
# RUN dart pub get --offline
# RUN dart compile exe bin/main.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM ubuntu:20.04

WORKDIR /app

# Устанавливаем geckodriver
RUN apt-get update && apt-get install -y firefox && apt-get install -y wget && apt-get install -y unzip
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz
RUN tar -xvzf geckodriver-v0.30.0-linux64.tar.gz
RUN chmod +x geckodriver

# Копируем файлы из этапа сборки Dart

# RUN mv geckodriver /app/geckodriver

COPY --from=build /runtime/ /runtime/
COPY ./bin/server .
COPY ./.env .

# Start server.
CMD sh -c './geckodriver --port 9515' & './server'