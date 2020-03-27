FROM jupyter/datascience-notebook:dc9744740e12

RUN mkdir src
WORKDIR src/
COPY . .

WORKDIR /src/
