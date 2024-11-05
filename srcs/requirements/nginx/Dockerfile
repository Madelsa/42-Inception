FROM alpine:3.20.3

RUN apk update && apk upgrade && apk add --no-cache nginx nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/mabdelsa.42.fr.key -out /etc/nginx/ssl/mabdelsa.42.fr.crt \
    -subj "/C=AE/ST=Abu Dhabi/L=Abu Dhabi/O=42/CN=mabdelsa"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]