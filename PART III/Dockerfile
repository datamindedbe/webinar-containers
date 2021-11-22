FROM python:3.9

WORKDIR /app

ENV AWS_ACCESS_KEY_ID ""
ENV AWS_SECRET_ACCESS_KEY ""
ENV AWS_REGION ""

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Put dependencies in their own image layer as a cache, 
# if you change code only the code layer needs to be rebuilt
COPY requirements.txt requirements.txt
COPY setup.py setup.py
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# Install the application
COPY src ./src
RUN python3 -m pip install . --no-cache-dir

# Define which cmd will be executed when running this image
ENTRYPOINT ["python3", "/app/src/titanicpredictor/main.py"]