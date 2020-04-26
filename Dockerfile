# For a development environment, Ubuntu is nice because it contains most of the dependencies/tools you need.
# For apps running in containers, I recommend an Alpine image instead.
FROM ubuntu:18.04

# Install base packages
RUN apt-get update \
    && apt-get install -y \
    curl \
    fonts-powerline \
    git \
    locales \
    terminator \
    zsh \
    # Install Oh My Zsh. This needs curl, git and zsh packages installed first.
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install dev dependencies
RUN echo 'Installing dev dependencies...' \
    # Install Node
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs \
    # Install Yarn
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install yarn

# Additional setup. Things below here are likely to change so we add them after package installations so Docker can use the build cache.
ARG DISPLAY
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL

ENV SHELL /bin/zsh
# This will let the container run GUI applications (as long as the host has an X server)
ENV DISPLAY $DISPLAY

RUN echo 'Performing additional setup...' \
    # Set up locale needed for Oh My Zsh themes
    && locale-gen en_US.UTF-8 \
    # Configure Git user
    && git config --global user.name "$GIT_USER_NAME" \
    && git config --global user.email "$GIT_USER_EMAIL"

# Add dotfiles
WORKDIR /root
COPY ./.dotfiles .

CMD ["terminator", "-u"]