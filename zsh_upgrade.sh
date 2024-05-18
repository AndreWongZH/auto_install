#!/bin/zsh

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# zsh default shell
if [ $SHELL:t = zsh ]; then
  echo "zsh is already set as the default shell"
else
  chsh -s /user/bin/zsh
  echo "zsh is set as the default shell"
fi

echo

# ohmyzsh installation
ohmyzsh_dir="$HOME/.oh-my-zsh/"
if [ -d "$ohmyzsh_dir" ]; then
  echo "$ohmyzsh_dir directory exists"
  echo "oh my zsh is already installed, skipping install"
else
  echo "installing oh my zsh ..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  if [ $? -ne 0]; then
    echo "oh my zsh is not installed"
    exit 1
  fi
  echo "oh my zsh is installed"
fi

echo

zshrc_file="$HOME/.zshrc"
if [ ! -f "$zshrc_file" ]; then
  echo ".zshrc file not found in $zshrc_file, aborting..."
  exit 1
fi
echo "backing up ./zshrc file as .zshrc.backup"
cp $zshrc_file $HOME/.zshrc.backup

echo

# zsh-autosuggestions installation
autosuggest_dir="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
if [ -d "$autosuggest_dir" ]; then
  echo "$autosuggest_dir directory exists"
  echo "zsh autosuggestions is already installed, skipping install"
else
  echo "installing zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $autosuggest_dir
  sed -i "s/^plugins=(\(.*\))/plugins=(\1 zsh-autosuggestions)/" $zshrc_file
  echo "zsh-autosuggestions installed"
fi

echo

# zsh-syntax-highlighting installation
highlight_dir="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
if [ -d "$highlight_dir" ]; then
  echo "$highlight_dir directory exist"
  echo "zsh syntax highlighting is already installed, skipping install"
else
  echo "installing zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $highlight_dir
  sed -i "s/^plugins=(\(.*\))/plugins=(\1 zsh-syntax-highlighting)/" $zshrc_file
  echo "zsh-syntax-highlighting installed"
fi

echo

# not sure if this would work on wsl
if [ -f "/etc/wsl.conf" ]; then
  echo "/etc/wsl.conf exists, WSL is detected"
  echo "for WSL, we need to install powerline fonts in our windows pc manually"
  echo "https://www.nerdfonts.com/"
  echo "skipping fonts install"
else
  echo "installing fonts-powerline ..."
  git clone https://github.com/powerline/fonts.git --depth=1
  ./fonts/install.sh
  if [ $? -ne 0 ]; then
    echo "fonts-powerline not installed"
    rm -rf ./fonts
    exit 1
  fi
  echo "fonts-powerline installed"
  rm -rf ./fonts
fi

echo

powerlevel10k_dir="$ZSH_CUSTOM/themes/powerlevel10k"
if [ -d "$powerlevel10k_dir" ]; then
  echo "$powerlevel10k_dir directory exist"
  echo "powerlevel10k is already installed, skipping install"
else
  echo "installing powerlevel10k ..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $powerlevel10k_dir
  sed -i "s/^ZSH_THEME=\".*\"/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/" $zshrc_file
  if [ $? -ne 0 ]; then
    echo "failed to replace ZSH_THEME to powerlevel10k in $HOME/.zshrc"
    exit 1
  fi
  echo "powerlevel10k installed"
  echo "run p10k configure to configure p10k settings"
fi

echo


# add alias
if ! grep -q "alias reload=\"source ~/.zshrc\"" $zshrc_file; then
  echo "add reload alias"
  echo "" >> $zshrc_file
  echo "alias reload=\"source ~/.zshrc\"" >> $zshrc_file
else
  echo "reload alias added"
fi

echo

if grep -q "# zstyle ':omz:update' mode auto      # update automatically without asking" $zshrc_file; then
  echo "turning on oh my zsh auto-update"
  sed -i "s/^# \(zstyle ':omz:update' mode auto\)/\1/" $zshrc_file
  if [ $? -ne 0 ]; then
    echo "failed to turn on auto-update mode"
  else 
    echo "auto-update turned on"
  fi
else
  echo "auto-update already turned on"
fi

echo

source ~/.zshrc

