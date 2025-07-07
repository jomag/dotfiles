#!/bin/bash
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
unzip CascadiaMono.zip -d Cascadia
unzip Hack.zip -d Hack

if [[ "$OSTYPE" == "darwin"* ]]; then
  FONTDIR=~/Library/Fonts/
  echo "MacOS detected. Installing into $FONTDIR."
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  FONTDIR=~/.fonts/
  echo "Linux system detected. Installing into $FONTDIR."
else
  echo "Unable to detect system. Fonts will not be installed."
  exit
fi

echo cp Cascadia/*.ttf $FONTDIR
echo cp Hack/*.ttf $FONTDIR

