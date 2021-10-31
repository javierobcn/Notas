# using ubuntu LTS version
FROM ubuntu:20.04 AS builder-image
# ENV TZ=Europe/Madrid
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y python3.9 python3.9-dev python3.9-venv python3-pip python3-wheel build-essential && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# create and activate virtual environment
# using final folder name to avoid path issues with packages
RUN python3.9 -m venv /home/myuser/venv
ENV PATH="/home/myuser/venv/bin:$PATH"

# ENV GIT_PYTHON_GIT_EXECUTABLE ="usr/bin/git"

# install requirements
COPY requirements.txt .
RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir -r requirements.txt

FROM ubuntu:20.04 AS runner-image
RUN apt-get update && apt-get install --no-install-recommends -y python3.9 python3-venv && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home myuser
COPY --from=builder-image /home/myuser/venv /home/myuser/venv

# RUN apt-get update && apt-get install -y git && \
# 	apt-get clean && rm -rf /var/lib/apt/lists/*

USER myuser
RUN mkdir /home/myuser/code
WORKDIR /home/myuser/code
COPY . .
# RUN git init
# RUN git config --global user.email "javierobcn@gmail.com"
# RUN git config --global user.name "Javier"

EXPOSE 5000

# make sure all messages always reach console
ENV PYTHONUNBUFFERED=1

# activate virtual environment
ENV VIRTUAL_ENV=/home/myuser/venv
ENV PATH="/home/myuser/venv/bin:$PATH"
# ENV PATH="/usr/bin/git:$PATH"

# ENV GIT_PYTHON_GIT_EXECUTABLE ="usr/bin/git"

ENV GIT_PYTHON_REFRESH=quiet

CMD ["mkdocs","serve","--dev-addr=0.0.0.0:8000"]