#!/bin/bash

script_dir=`dirname "$0"`

for var in .gvimrc .tmux.conf .vim; do
  cp -r $HOME/$var $script_dir/
  echo "cp -r $HOME/$var $script_dir/"
done

rm -rf $script_dir/.config 2> /dev/null
mkdir -vp $script_dir/.config

for var in alacritty broot gtk-3.0 htop kdeglobals mimeapps.list nvim plasmarc qimgv qt5ct rofi zathura zsh; do
  cp -r ~/.config/$var $script_dir/.config/
  echo "cp -r ~/.config/$var $script_dir/.config/"
done

mkdir -vp $script_dir/.config/awesome/
cp    -v ~/.config/awesome/rc.lua   $script_dir/.config/awesome/
echo "cp    -v ~/.config/awesome/rc.lua   $script_dir/.config/awesome/"