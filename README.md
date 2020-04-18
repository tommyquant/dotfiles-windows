## Installing Windows and packages

1. Download Windows 10 image and create a bootable USB.
1. By default, the installer will detect if you have a serial for the Home edition and won't give you an option to install Pro. To fix this, go into the USB and open the **sources** folder. Afterwards, create a file named **ei.cfg** and put the following into it:
```
[Channel]
Retail
```
3. Restart and boot into the USB and install Windows 10 Pro (UPDATE: you can install Home if you're using WSL 2 as described below).
1. After installation, download `bootstrap.ps1` from this repo.
1. Open Powershell in administrator mode.
1. By default, Powershell won't execute foreign scripts. To bypass this, run `Set-ExecutionPolicy RemoteSigned`.
1. Run `& "path/to/bootstrap.ps1"`. This will set a few Windows settings, install packages using Chocolatey and remove pre-installed bloatware.

## Setting up development environment

All development will occur within WSL and Docker containers (that are also running within WSL). To achieve this setup, you will need to be on the Windows Insider program.

### Joining Windows Insider

1. Open the Start menu and then open Windows Insider Program Settings.
1. Join the Windows Insider program. Restart if it prompts you to do so.
1. Open Windows Update and check for updates. This should download and install an Insider build.

Once the new build is installed, you'll need to set up WSL 2 and Docker.

### Setting up WSL 2 and Docker

1. Set the default WSL version to 2 by running `wsl --set-default-version 2`.
1. Open the Microsoft Store and install a WSL distro such as Ubuntu.
1. After installation, open the distro to initialize it and set up your user.
1. [Install Docker](https://docs.docker.com/engine/install/ubuntu/) within your distro (find the appropriate guide for your distro).
1. Run `sudo usermod -aG docker $USER` so your user can use Docker commands without `sudo`.
1. If Docker hasn't prompted you to use the WSL 2 backend, open Docker Desktop settings and enable **Use the WSL 2 based engine**.
1. While you're in the settings, go to **Resources > WSL Integration** and enable your distro.
1. (Optional) If you want to remove the Hyper-V data, open Docker Desktop's **Troubleshoot** window and use the **Clean / Purge data** option.

Finally, you'll need to set up VS Code so you can develop within WSL and Docker containers.

### Setting up VS Code

1. (Optional) Open VS Code and install [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync). This extension will download backed up settings and extensions.
1. If you don't have them, install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) and [Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) extensions. These will allow you to develop within WSL and Docker containers.
