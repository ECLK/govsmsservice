FROM openjdk:8 AS build
RUN wget https://dist.ballerina.io/downloads/1.2.4/ballerina-linux-installer-x64-1.2.4.deb
RUN dpkg -i ballerina-linux-installer-x64-1.2.4.deb
WORKDIR /usr/src/

ENV TZ=Asia/Colombo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD . /usr/src/

RUN ballerina build --skip-tests --all
RUN ls -l target/bin/

FROM openjdk:8

ENV TZ=Asia/Colombo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY  --from=build /usr/src/target/bin/service.jar /usr/src/target/service.jar
WORKDIR /usr/src/target/
RUN ls -l
EXPOSE 9090
CMD java -jar service.jar --eclk.govsms.username=SMSUSERNAME --eclk.govsms.password=SMSPASSWORD --eclk.govsms.source=SMSSOURCE
