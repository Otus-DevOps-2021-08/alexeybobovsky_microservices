FROM python:3.6-alpine

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

WORKDIR /app
COPY . /app

RUN apk --no-cache --update add build-base && \
    pip install -r requirements.txt && \
    apk del build-base

ENTRYPOINT ["python3", "post_app.py"]
