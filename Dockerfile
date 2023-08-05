FROM python:3.8.5-slim-buster

RUN apt-get update && apt-get install -y procps vim

COPY . /web

RUN pip install -r ./web/requirements.txt && pip install gunicorn

ENTRYPOINT ["./web/runserver.sh"]
