#!/bin/bash

BINPATH="/lib/live/mount/persistence/TailsData_unlocked/bin"
USERDATA="/media/amnesia/UserData"

run_as_user() {
  sudo -H -u amnesia bash -c "$1"
}

# Bind user directories
$BINPATH/bind-user-dirs.sh --location "$USERDATA/user"

# Install additional software
$BINPATH/additional-software.sh --config "$USERDATA/live-additional-software.conf"

# Install dotphiles
run_as_user "ln -s \"$USERDATA/dotphiles\" \"\$HOME/.dotfiles\""

# Apply dotphiles
run_as_user '$HOME/.bin/dotsync -L'

# Install vim plugins
run_as_user 'vim +PluginInstall +qall'
