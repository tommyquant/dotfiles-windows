## Installing Windows and packages

1. Download Windows 10 image and create a bootable USB.
2. By default, the installer will detect if you have a serial for the Home edition and won't give you an option to install Pro. To fix this, go into the USB and open the **sources** folder. Afterwards, create a file named **ei.cfg** and put the following into it:

```
[Channel]
Retail
```

3. Restart and boot into the USB and install Windows 10 Pro.
4. After installation, download `bootstrap.ps1` from this repo.
5. Open Powershell in administrator mode.
6. By default, Powershell won't execute foreign scripts. To bypass this, run `Set-ExecutionPolicy RemoteSigned`.
7. Run `& "path/to/bootstrap.ps1"`. This will set a few Windows settings, install packages using Chocolatey and remove pre-installed bloatware.

## Setting up dev environment

All development will occur within WSL and Docker containers running within WSL. To achieve this setup, you will need to be on the Windows Insider program.

### Joining Windows Insider

1. Open the Start menu and then open Windows Insider Program Settings.
2. Join the Windows Insider program. Restart if it prompts you to do so.
3. Open Windows Update and check for updates. This should download and install an Insider build.

Once the new build is installed, you'll need to set up WSL.

### Setting up WSL

1. Open the Microsoft Store and install a WSL distro such as Ubuntu.
2. After installation, open the distro to initialize it.

Finally, you'll need to set up VS Code to connect to WSL.

### Setting up VS Code

1. (Optional) Open VS Code and install [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync). This extension will download backed up settings and extensions.
2. If you don't have them, install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) and [Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) extensions.
