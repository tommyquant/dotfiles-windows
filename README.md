# dotfiles for Windows

This repo contains instructions and files I use to set up my development environment on a clean install of Windows.

I have based my development environment around the Windows Subsystem for Linux (WSL). This means all of my repos and dependencies live inside WSL. For me, this has a few benefits:

- **Consistent environment** - Useful if you need to write shell/bash scripts. For example, if your deployment environment is Linux but you use Windows, it's difficult to get scripts to run exactly the same in both environments. By developing inside WSL, you can write and run your scripts locally in a Linux environment. No more Git Bash!
- **Isolated dependencies** - WSL keeps your host system free of dependencies.
- **Disk performance** - Personally, I have found using commands like `npm install` to be faster on Linux.

## Installation

### Setting up WSL

1. [Install WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
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

## FAQ

**I get 'Permission denied' when trying to run `cargo build`.**

See [this issue for a fix](https://github.com/rust-lang/rust/issues/62031#issuecomment-508962191).