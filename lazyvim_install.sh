#!/bin/zsh

if ! command -v nvim &>/dev/null; then
	echo "neovim not installed, installing ..."

	if command -v apt &>/dev/null; then
		sudo apt install -y neovim
	elif command -v brew &>/dev/null; then
		brew install neovim
	else
		echo "unable to install neovim, please install it manually"
		exit 1
	fi

  if [ $? -eq 0 ]; then
	  echo "neovim installed"
  fi
else
  echo "neovim already installed"
fi
