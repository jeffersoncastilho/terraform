FROM nginx:1.27-alpine

ARG REGION=unknown
ENV REGION=${REGION}

COPY src/index.html /usr/share/nginx/html/index.html
COPY src/health.html /usr/share/nginx/html/health.html

RUN sed -i "s/__REGION__/${REGION}/g" /usr/share/nginx/html/index.html

EXPOSE 80
