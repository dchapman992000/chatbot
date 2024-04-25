FROM python:3.12-slim AS build

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y git
COPY app/requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Workaround due to chatterbot-corpus being so old
RUN pip uninstall -y PyYaml
RUN pip install --user --upgrade PyYaml --only-binary=:all:

FROM python:3.12-slim

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

WORKDIR /usr/src/app

# Copy the dependencies from multistage
COPY --from=build /root/.local /root/.local

# Copy in the apps
COPY ./app .

# Bake the training into the image
RUN python ./train.py

EXPOSE 5000

# Since we're copying pip installed files this helps gunicorn work
ENV PATH=/root/.local/bin:$PATH

CMD exec gunicorn --bind :5000 --workers 1 --threads 8 --timeout 0 main:app