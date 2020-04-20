# dotfiles for Windows

This repo contains instructions and files I use to set up my development environment on a clean install of Windows.

This development environment is based on Docker containers. This means all of your repos and dependencies live inside containers. For me, this has a few benefits:

- **Consistent environment** - This is useful if you need to write shell/bash scripts. For example, if your deployment environment is Linux but you use Windows, it's difficult to get scripts to run exactly the same in both environments. By developing inside a container, you can run your scripts locally in a Linux environment. No more Git Bash!
- **Isolated workspaces and dependencies** - With Docker, it's easy to create containers with exactly what you need. You environment can be as minimal or full-fledged as you like. You can also have multiple development environments by creating multiple containers. For example, you can have separate containers for developing in Javascript and Rust.
- **Disk performance** - Personally, I have found using commands like `npm install` to be faster on Linux.

## Installation

### Installing Windows and bootstrapping

1. Download Windows 10 image and create a bootable USB.
1. By default, the installer will detect if you have a serial for the Home edition and won't give you an option to install Pro. To fix this, go into the USB and open the **sources** folder. Afterwards, create a file named **ei.cfg** and put the following into it:
```
[Channel]
Retail
```
3. Restart and boot into the USB and install Windows 10 Pro.
1. After installation, download `bootstrap.ps1` from this repo.
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

To build and run the container, use Docker Compose by running `docker-compose up -d --build`.

> **Note:** If you check the `docker-compose.yml` file, you'll notice that it creates and mounts a named volume instead of using bind mounts. This is to keep your files isolated from the Windows filesystem which will give the best read/write performance. Another benefit of using named volumes is that your files will persist through container rebuilds and you can also mount them into other containers.

Once the container starts, Terminator will open. This is the main process of the container which means if you close Terminator, the container will stop.

Next, you'll need to set up VS Code so that it can connect to Docker containers.

### Connecting VS Code to a container

1. (Optional) Open VS Code and install [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync). This extension will download backed up settings and extensions.
1. If you don't have it, install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension. This will allow you to connect VS Code to a Docker container. I also recommend installing the [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) extension. This extension makes it very easy to manage your containers, images, networks and volumes within VS Code.
1. Open the **Command Palette** and attach to the running container by executing **Remote-Containers: Attach to Running Container**. This will open a new instance of VS Code and you can now open any file/folder from the container.
1. If you're using my Docker Compose and Dockerfile, clone your repos into `/repos`. This will put it in a named volume which will persist through container rebuilds.

### Setting Git credentials

Before setting your Git credentials, log in to GitHub and get your private email address (or set it up). Afterwards, run these commands in the container (replace your name and email):

```sh
git config --global user.name "Some private name"
git config --global user.email "hash+username@users.noreply.github.com"

# Configure Git to ensure line endings in files you checkout are correct for Windows.
# For compatibility, line endings are converted to Unix style when you commit files.
git config --global core.autocrlf true
```

When you need to push, Git will ask you for your username and password. If you have 2FA enabled, you'll need to use an access token when it asks for your password. If you don't have a token already, [create one](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line).

## FAQ

### Why use Terminator?

You might be wondering why I need Terminator at all. Why not just use `docker exec -it my_container /bin/sh` to get an interactive terminal?

Let's say I open Powershell and use `docker exec` to get an interactive shell within my container. If I close Powershell by pressing the close button (or any other method of closing it), the Windows process started by `docker exec` will terminate **but the shell within the container does not terminate**. This means I have a dangling process within my container and by extension, any processes spawned by the shell will also be dangling.

By using a terminal from the container, processes are terminated correctly when I close the terminal.

### Why isn't Zsh showing glyphs?

If you're connected to your container in VS Code and open an integrated terminal, you'll notice that the Zsh theme won't look correct. This is because VS Code's terminal is not using a Powerline font. To fix this, install one of the fonts from the [Powerline fonts](https://github.com/powerline/fonts) repo. Afterwards, restart VS Code, open your settings and edit **Terminal > Integrated: Font Family**.