#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if test -d "/opt/homebrew"; then
      echo "  Adding Homebrew to PATH for Apple Silicon Mac..."
      eval "$(/opt/homebrew/bin/brew shellenv)"
    # Add Homebrew to PATH for Intel Macs
    elif test -d "/usr/local/bin/brew"; then
      echo "  Adding Homebrew to PATH for Intel Mac..."
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Linux
    if test -d "/home/linuxbrew/.linuxbrew"; then
      echo "  Adding Homebrew to PATH for Linux..."
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
  fi
else
  echo "  Homebrew already installed, ensuring it's in PATH..."
  # Ensure Homebrew is in PATH even if already installed
  if test "$(uname)" = "Darwin"; then
    if test -d "/opt/homebrew"; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif test -d "/usr/local/bin/brew"; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  elif test -d "/home/linuxbrew/.linuxbrew"; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

exit 0
