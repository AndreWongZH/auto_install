#!/bin/bash

# zsh installation
if ! command -v zsh &>/dev/null; then
	echo "zsh no installed, installing ..."

	if command -v apt &>/dev/null; then
		sudo apt install -y zsh
	elif command -v brew &>/dev/null; then
		brew install zsh
	else
		echo "zsh is unable to be installed, please install it manually"
		exit 1
	fi

	if [ $? -ne 0 ]; then
		echo "zsh not installed"
		exit 1
	fi
	echo "zsh installed"
	zsh -c "echo $ZSH_VERSION"
else
	echo "zsh is already installed"
fi

echo

# run zsh_upgrade to install the rest of zsh
if [ -f "./zsh_upgrade.sh" ]; then
	echo "upgrading zsh ..."
	./zsh_upgrade.sh
else
	echo "./zsh_upgrade.sh does not exist, unable to patch zsh"
	exit 1
fi

echo
