#!/bin/bash

echo "export XDG_CONFIG_HOME=~/.config" >> ~/.profile
source ~/.profile
make install/dev-container