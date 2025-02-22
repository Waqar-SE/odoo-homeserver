FROM python:3.12 as builder

COPY requirements.txt requirements.txt 

RUN apt update && \
    apt upgrade -y \
    build-essential \
    libsasl2-dev python-dev-is-python3 libldap2-dev libssl-dev \
    python3-dev 

RUN pip install setuptools wheel && \
    pip install --target /odoo/venv/ -r requirements.txt

FROM python:3.12 as final

RUN apt update && \
    apt upgrade -y

WORKDIR /opt/odoo

COPY --from=builder /odoo/venv/ /opt/odoo/venv
ENV PYTHONPATH='/opt/odoo/venv:${PYTHONPATH}'

COPY . .