# A dockerized template for my website javieranto.com

## Features

* :point_down: Build, start, stop instances, in one click (only with VS Code).

## Better with Visual Studio Code

You can run most of the tasks using bottom taskbar buttons.

![VS Code Taskbar](/src/images/vs_taskbar.png "VS Code Taskbar")

Or open the command palette and type

`Tasks: Run Task`

and choosing one of the returned options.

## Requirements

* [Docker CE](https://docs.docker.com/compose/install/)
* [TaskFile](https://taskfile.dev/#/)
* [VS Code](https://code.visualstudio.com/) (Optional)
* [rclone](https://rclone.org/)(optional)

## Installation

### Clone template repository

```console
git clone https://github.com/javierobcn/Notas.git
```

### 2.- Go ahead

```console
cd notas
```

### 3.- Install Taskfile

Run **Install Tools** button from VS Code taskbar

or execute:

```console
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d && \
echo "alias task='bin/task'" >> ~/.bashrc && \
source ~/.bashrc
```

## Usage
### 1.- Start.

Starting all you need from `docker-compose.yml`. It will launch a browser window pointing to "http://localhost:8069".


```console
task start
```

### 2.- Documents

Put your documents in folder docs, see your documents in <http://localhost:8000>

### 3. Build and publish site

You will need rclone for sync your site folder with ftp remote. Configure a
remote in rclone to your site and change docker compose

```console
task mkdocs-publish
```
