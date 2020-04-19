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

1. (Optional) Open VS Code and install [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync). This extension will download backed up settings and extensions.
1. If you don't have it, install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension. These will allow you to connect VS Code to a Docker container.


## Workflow

Where possible, you should have your files isolated from the Windows filesystem for best performance. This means you shouldn't use bind mounts to mount files from Windows into the container. Ideally, you won't have any development-related files on Windows.

Instead, you should clone your repo directly into the container. There are a few methods to do this.

### Method A

1. Open VS Code and execute the **Remote-Containers: Open Repository in Container** command. This will clone your repo into a named volume and then mount that volume into a container. You'll also get an option to choose a Docker image.

### Method B

1. Create a Dockerfile that builds an image with all of your dependencies.
2. Start a container with the new image. You can keep the container running by setting its command to `/bin/sh -c echo Container started ; while sleep 1; do :; done`.
3. Start an interactive session with your container and then clone your repo(s) into the container. Optionally, you can also create a single named volume to store all of your repos so that they persist through container rebuilds. This also lets you share files between containers.

## Setting Git credentials

Before setting your Git credentials, log in to GitHub and get your private email address (or set it up). Afterwards, run these commands in the container (replace your name and email):

```
git config --global user.name "Some private name"
git config --global user.email "hash+username@users.noreply.github.com"
```

When you need to push, Git will ask you for your username and password. If you have 2FA enabled, you'll need to use an access token when it asks for your password. If you don't have a token already, [create one](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line).