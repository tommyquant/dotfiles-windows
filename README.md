## Installing Windows and packages

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

## Setting up development environment

To keep a consistent development environment, all development should be done on Linux. For Windows, this means developing within Docker containers.

First, you'll need to set up VS Code so that it can connect to Docker containers.

1. (Optional) Open VS Code and install [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync). This extension will download backed up settings and extensions.
1. If you don't have it, install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension. These will allow you to connect VS Code to a Docker container.

Next, you'll need to create a container that will be your development environment. This repo already includes a Dockerfile that builds an Ubuntu image with Node and Zsh installed. You can use Docker Compose to build and start the container by running `docker-compose up -d --build`.

If you check the `docker-compose.yml` file, you'll notice that it creates and mounts a named volume instead of using bind mounts. This is to keep your files isolated from the Windows filesystem which will give the best read/write performance. Another benefit of using named volumes is that your files will persist through container rebuilds and you can also mount them into other containers.

Once the container is running, open VS Code and then open the Command Palette. Attach to the running container by executing **Remote-Containers: Attach to Running Container**. This will open a new instance of VS Code and you can now open any file/folder from the container.

If you open a terminal connected to your container (either through VS Code's integrated terminal or an external terminal), you'll notice that the Zsh theme won't look correct. This is because your host system/terminal is not using a Powerline font. To fix this, install one of the fonts from the [Powerline fonts](https://github.com/powerline/fonts) repo and then configure your terminal to use that font. For VS Code, you'll need to restart VS Code, open your settings and edit **Terminal > Integrated: Font Family**.

Finally, you can clone your repos into `/repos` and start working!

## Setting Git credentials

Before setting your Git credentials, log in to GitHub and get your private email address (or set it up). Afterwards, run these commands in the container (replace your name and email):

```sh
git config --global user.name "Some private name"
git config --global user.email "hash+username@users.noreply.github.com"

# Configure Git to ensure line endings in files you checkout are correct for Windows.
# For compatibility, line endings are converted to Unix style when you commit files.
git config --global core.autocrlf true
```

When you need to push, Git will ask you for your username and password. If you have 2FA enabled, you'll need to use an access token when it asks for your password. If you don't have a token already, [create one](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line).