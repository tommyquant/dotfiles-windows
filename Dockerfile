# For a development environment, Ubuntu is nice because it contains most of the dependencies/tools you need.
# For apps running in containers, I recommend an Alpine image instead.
FROM ubuntu:18.04

ARG REPOS_DIR=/repos

ENV SHELL /bin/zsh
# This will let the container run GUI applications (as long as the host has an X server)
ENV DISPLAY docker.for.win.localhost:0

# Install base packages
RUN apt-get update \
    && apt-get install -y \
    curl \
    fonts-powerline \
    git \
    locales \
    terminator \
    zsh \
    # Set up locale needed for Oh My Zsh themes
    && locale-gen en_US.UTF-8 \
    # Install Oh My Zsh. This needs curl, git and zsh packages installed first.
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    # Create the /repos folder where volumes should be mounted to
    && mkdir $REPOS_DIR

# Install dev dependencies
RUN echo 'Installing dev dependencies...' \
    # Install Node
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs \
    # Install Yarn
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install yarn

# Add dotfiles
WORKDIR /root
COPY ./.dotfiles .

CMD ["terminator", "-u"]