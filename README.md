# dotfiles for Windows

This repo contains instructions and files I use to set up my development environment on a clean install of Windows.

I have based my development environment around Docker containers. This means all of my repos and dependencies live inside containers. For me, this has a few benefits:

- **Consistent environment** - Useful if you need to write shell/bash scripts. For example, if your deployment environment is Linux but you use Windows, it's difficult to get scripts to run exactly the same in both environments. By developing inside a container, you can write and run your scripts locally in a Linux environment. No more Git Bash!
- **Full control** - Build containers with exactly what you need. Your environment can be as minimal or full-fledged as you like.
- **Multiple workspaces** - Create separate development environments by creating multiple containers. For example, if you develop in Javascript and Rust, you can create separate containers for each.
- **Isolated dependencies** - Containers keep your host system free of dependencies.
- **Disk performance** - Personally, I have found using commands like `npm install` to be faster on Linux.

## Installation

### Installing Windows and bootstrapping

1. Download Windows 10 image and create a bootable USB.
1. The bootstrap script installs Docker which requires Hyper-V which is not available in the Home edition. By default, the installer will detect if you have a serial for the Home edition and won't let you choose other editions to install. To fix this, go into the USB and open the **sources** folder. Afterwards, create a file named **ei.cfg** and put the following into it:
```
[Channel]
Retail
```
3. Restart and boot into the USB.
1. When prompted for an edition to install, choose Enterprise, Pro, or Education.
1. After installation, download this repo.
1. Open Powershell in administrator mode.
1. By default, Powershell won't execute foreign scripts. To bypass this, run `Set-ExecutionPolicy RemoteSigned`.
1. Run `& "path/to/bootstrap.ps1"`. This will set a few Windows settings, install packages using Chocolatey and remove pre-installed bloatware.

Next, you'll need to set up your development environment. The first step is to create a container that will house all of your tools and dependencies.

### Creating a development container.

This development workflow requires you to have the following on Windows:

- [Docker](https://www.docker.com/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [VcXsrv](https://sourceforge.net/projects/vcxsrv/) or any other X server such as [MobaXterm](https://mobaxterm.mobatek.net/).

>**Note:** The bootstrap script will install these automatically using [Chocolatey](https://chocolatey.org/).

This repo contains the Dockerfile I use to build my development environment. You'll notice that it installs [Terminator](https://terminator-gtk3.readthedocs.io/en/latest/) (go to the FAQ to see why I use this) which is a GUI terminal. But Docker containers can't run GUI applications which is why we need VcXsrv. With this, a container can run a GUI application and send the display information to VcXsrv which will display the application on Windows.

This project uses Docker Compose to set up containers, networks and volumes. Before you start Docker Compose, you'll need to set up some configuration. Create a `.env` file and then set any required variables listed within `docker-compose.yml`. For example `GIT_USER_NAME` and `GIT_USER_EMAIL` are required so your `.env` file should look something like this:

```sh
# Set your name and email for commits. If you're privacy-conscious, I recommend using your Git provider's private email feature.
GIT_USER_NAME=Bob
GIT_USER_EMAIL=bob_is_cool@email.com

# I recommend setting this otherwise Compose will prefix your container name with the current folder name
COMPOSE_PROJECT_NAME=dev
```

Next, build and run the container, run `docker-compose up -d --build`.

> **Note:** If you check the `docker-compose.yml` file, you'll notice that it creates and mounts a named volume instead of using bind mounts. This is to keep your files isolated from the Windows filesystem which will give the best read/write performance. Another benefit of using named volumes is that your files will persist through container rebuilds and you can also mount them into other containers.

Once the container starts, Terminator will open. This is the main process of the container which means if you close Terminator, the container will stop.

Next, you'll need to set up VS Code so that it can connect to Docker containers.

### Connecting VS Code to a container

1. (Optional) Open VS Code and install [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync). This extension will download backed up settings and extensions.
1. If you don't have it, install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension. This will allow you to connect VS Code to a Docker container. I also recommend installing the [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) extension. This extension makes it very easy to manage your containers, images, networks and volumes within VS Code.
1. Open the **Command Palette** and attach to the running container by executing **Remote-Containers: Attach to Running Container**. This will open a new instance of VS Code and you can now open any file/folder from the container.
1. If you're using my Docker Compose and Dockerfile, clone your repos into `/repos`. This will put it in a named volume which will persist through container rebuilds.
1. Start coding!

## FAQ

### I closed Terminator and now my container has stopped running. How do I run it again?

Run `docker start my_container_name`.

### Why use Terminator?

You might be wondering why you need Terminator at all. Why not just use `docker exec -it my_container /bin/sh` to get an interactive shell?

Let's say I open Powershell and use `docker exec` to get an interactive shell within my container. If I close Powershell by pressing the close button (or any other method of closing it), the Windows process started by `docker exec` will terminate **but the shell within the container does not terminate**. This means I have a dangling process within my container and by extension, any processes spawned by the shell will also be dangling.

By using a terminal living within the container, processes are terminated correctly when I close the terminal.

### Why isn't Zsh showing glyphs?

If you're connected to your container in VS Code and open an integrated terminal, you'll notice that the Zsh theme won't look correct. This is because VS Code's terminal is not using a Powerline font. To fix this, install one of the fonts from the [Powerline fonts](https://github.com/powerline/fonts) repo. Afterwards, restart VS Code, open your settings and edit **Terminal > Integrated: Font Family**.
