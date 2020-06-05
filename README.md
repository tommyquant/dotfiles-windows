# dotfiles for Windows

This repo contains instructions and files I use to set up my development environment on a clean install of Windows.

I have based my development environment around the Windows Subsystem for Linux (WSL). This means all of my repos and dependencies live inside WSL. For me, this has a few benefits:

- **Consistent environment** - Useful if you need to write shell/bash scripts. For example, if your deployment environment is Linux but you use Windows, it's difficult to get scripts to run exactly the same in both environments. By developing inside WSL, you can write and run your scripts locally in a Linux environment. No more Git Bash!
- **Isolated dependencies** - WSL keeps your host system free of dependencies.
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

### Setting up WSL

1. Open the Microsoft Store and install a Linux distro such as Ubuntu.
1. After installation, launch your distro. This should prompt you to create a new user.
1. Clone this repo into WSL.
1. Create a `.env` file with the following contents:
```sh
# Set your name and email for commits. If you're privacy-conscious, I recommend using your Git provider's private email feature.
GIT_USER_NAME=Bob
GIT_USER_EMAIL=bob_is_cool@email.com
```
5. Execute the `install.sh` script.

Next, you'll need to set up VS Code so that it can connect to WSL.

### Connecting VS Code to WSL

1. (Optional) Open VS Code and install [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync). This extension will download backed up settings and extensions.
1. If you don't have it, install the [Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) extension. This will allow you to connect VS Code to WSL.
1. Open the **Command Palette** and attach to WSL by executing **Remote-WSL: New Window**. This will open a new instance of VS Code and you can now open any file/folder residing within WSL.
1. Start coding!