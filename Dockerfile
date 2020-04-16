#FROM openjdk:13
FROM debian:10

WORKDIR /root
RUN apt-get update && apt-get install -y git maven
RUN apt-get install -y openjdk-11-jdk
RUN git clone --depth=1 https://github.com/georgewfraser/java-language-server.git
WORKDIR java-language-server
RUN ln /usr/bin/jlink /bin/jlink
RUN ./scripts/link_linux.sh 

# TODO i'm not sure how safe this is
RUN sed -i pom.xml -e 's,<target>13</target>,<target>11</target>,'
RUN sed -i pom.xml -e 's,<source>13</source>,<source>11</source>,'

RUN mvn package -DskipTests
WORKDIR dist

CMD bash -c "declare -x JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 ; ./lang_server_linux.sh"
