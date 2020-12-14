FROM python:3.9.1-slim as base                                                                                                
                                                                                                                              
FROM base as builder                                                                                                          
                                                                                                                              
RUN mkdir /install                                                                                                            
# RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev                                                             
RUN apt-get update && apt-get -y install gcc
WORKDIR /install                                                                                                              
COPY requirements.txt /requirements.txt                                                                                       
RUN pip install --prefix=/install -r /requirements.txt                                                     
                                                                                                                              
FROM base                                                                                                                     
                                                                                                                              
COPY --from=builder /install /usr/local    

ENV FILE=index.md
ENV SPACE=test
ENV USER=test_user
ENV ACCESSTOKEN=1234
ENV ORGNAME=TST
ENV PARENT_PAGE=${SPACE}

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

ENTRYPOINT python3 ./md2conf.py /data/${FILE} ${SPACE} -u ${USER} -p ${ACCESSTOKEN} -o ${ORGNAME} -a "${PARENT_PAGE}"
