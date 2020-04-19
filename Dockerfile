# For a development environment, Ubuntu is nice because it contains most of the dependencies/tools you need.
# For apps running in containers, I recommend an Alpine image instead.
FROM ubuntu:18.04

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV HOME /home/$USERNAME
ENV SHELL /bin/zsh
ENV ZSH $HOME/.oh-my-zsh

# Set up new user and add to sudoers
RUN apt-get update \
    && apt-get install -y sudo \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell $SHELL \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN apt-get install -y \
    # Add your packages here
    curl \
    git \
    locales \
    nodejs \
    zsh \
    # Set up locale needed for Oh My Zsh themes
    && locale-gen en_US.UTF-8 \
    # Install Oh My Zsh. This needs curl, git and zsh packages installed first.
    # Note that this will install Oh My Zsh to whatever path $ZSH is set to.
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Create the /repos folder where volumes should be mounted to and then assign
# ownership to the new user so they can write to it.
RUN mkdir /repos \
    && chown $USERNAME /repos

# Switch to new user
USER $USERNAME
WORKDIR $HOME

# Add dotfiles
COPY --chown=$USERNAME ./.dotfiles $HOME

# This is the default command if the container runs without the user providing a command.
# This command will keep the container running indefinitely
CMD ["/bin/sh", "-c", "echo Container started ; while sleep 1; do :; done"]