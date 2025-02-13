# Copyright 2022 Google LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM gradle:7.5.1-jdk18-alpine AS build

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

RUN gradle build --no-daemon

FROM openjdk:20-slim-buster

RUN mkdir /app

COPY --from=build /home/gradle/src/build/libs/*.jar /app/gradle-application.jar
COPY --from=build /home/gradle/src/manifests/gradle-app.yaml.tpl /app/gradle-app.yaml.tpl

ENTRYPOINT ["java","-jar","/app/gradle-application.jar"]