# This Dockerfile is friendly to users in Chinese Mainland :) 
# For users outside mainland China, feel free to modify or delete them :)

# Use a base image with Python 3.9.17 slim version (Bullseye)
FROM python:3.9.17-slim-bullseye
ENV OPENAI_API_KEY=""

RUN echo $OPENAI_API_KEY
ENV OPENAI_API_MODEL: "gpt-3.5-turbo" \
RUN echo $OPENAI_API_MODEL
# Install Debian software needed by MetaGPT
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list &&\
    apt update &&\
    apt install -y git curl wget build-essential gcc clang g++ make &&\
    curl -sL https://deb.nodesource.com/setup_19.x | bash - &&\
    apt install -y nodejs &&\
    apt-get clean

# Set the working directory to /app
WORKDIR /app

# Install Mermaid CLI globally and clone the MetaGPT repository
RUN npm config set registry https://registry.npm.taobao.org
RUN npm install -g @mermaid-js/mermaid-cli
RUN npm cache clean --force
RUN git clone https://github.com/mamer-alomari/MetaGPT.git


# Install Python dependencies and install MetaGPT
#RUN #cd metagpt
RUN mkdir workspace
RUN cd MetaGPT
#RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip install -e .
RUN pip cache purge
#
#RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
#RUN pip install -r requirements.txt
#RUN pip cache purge
#RUN python setup.py install

# Running with an infinite loop using the tail command
CMD ["sh", "-c", "tail -f /dev/null"]

## Step 1: Download metagpt official image and prepare config.yaml
#docker pull metagpt/metagpt:v0.1
#mkdir -p /opt/metagpt/config && docker run --rm metagpt/metagpt:v0.1 cat /app/metagpt/config/config.yaml > /opt/metagpt/config/config.yaml
#vim /opt/metagpt/config/config.yaml # Change the config
#
## Step 2: Run metagpt image
#docker run --name metagpt -d \
#    -v /opt/metagpt/config:/app/metagpt/config \
#    -v /opt/metagpt/workspace:/app/metagpt/workspace \
#    metagpt/metagpt:v0.1
#
## Step 3: Access the metagpt container
#docker exec -it metagpt /bin/bash
#
## Step 4: Play in the container
#cd /app/metagpt
#python startup.py "Write a cli snake game"