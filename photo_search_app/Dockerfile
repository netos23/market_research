FROM python:3.8-slim-buster
WORKDIR /app
COPY requirements.txt requirements.txt
RUN python -m pip install --upgrade pip
RUN pip3 install -r requirements.txt
COPY . .
CMD [ "waitress-serve", "--port=5000", "--call", "app:run_app"]
