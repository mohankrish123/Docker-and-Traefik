FROM ubuntu:18.04 AS firststage
RUN mkdir -p /home/stage
COPY . /home/stage

FROM ubuntu:18.04
COPY --from=firststage /home/stage/*.sh /home
RUN echo "Test" >> new.txt
WORKDIR /home
RUN ./test.sh
