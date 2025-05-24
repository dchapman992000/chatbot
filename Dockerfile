# 20250524 Not all of the python libraries are compiled as binaries for 3.13 yet
FROM python:3.12-slim AS build

WORKDIR /usr/src/app

#RUN apt-get update && apt-get install -y git
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git

RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

COPY app/requirements.txt .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.12-slim

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

WORKDIR /usr/src/app

# Copy the dependencies from multistage
COPY --from=build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

# Copy in the apps
COPY ./app .

# Bake the training into the image
RUN python ./train.py

EXPOSE 5000

CMD exec gunicorn --bind :5000 --workers 1 --threads 8 --timeout 0 main:app