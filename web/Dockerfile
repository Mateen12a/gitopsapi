FROM python:3.8.5-slim-buster

RUN apt-get update && apt-get install -y procps vim

COPY . /

RUN pip install -r requirements.txt && pip install gunicorn

ENTRYPOINT ["/runserver.sh"]