FROM python:3.12-slim

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y git

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Workaround due to chatterbot-corpus being so old
RUN pip uninstall -y PyYaml
RUN pip install --upgrade PyYaml --only-binary=:all:

COPY . .

# Bake the training into the image
RUN python ./train.py

EXPOSE 5000

CMD exec gunicorn --bind :5000 --workers 1 --threads 8 --timeout 0 main:app