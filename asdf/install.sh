#!/bin/sh
#
# asdf
#
# This installs asdf and all required plugins for Node.js, Ruby, and other tools using Homebrew.

set -e

# Install asdf via Homebrew if not already installed
if ! command -v asdf >/dev/null 2>&1; then
  echo "  Installing asdf with Homebrew..."
  brew install asdf
fi

# Source asdf for this session
. "$(brew --prefix asdf)/libexec/asdf.sh"
export PATH="$(brew --prefix asdf)/shims:$PATH"

# Install plugins
echo "  Installing asdf plugins..."

# Node.js
if ! asdf plugin list | grep -q "nodejs"; then
  asdf plugin add nodejs
fi

# Ruby
if ! asdf plugin list | grep -q "ruby"; then
  asdf plugin add ruby
fi

# PostgreSQL (if needed)
# if ! asdf plugin list | grep -q "postgres"; then
#   asdf plugin add postgres
# fi

# Redis (if needed)
# if ! asdf plugin list | grep -q "redis"; then#   asdf plugin add redis
# fi

# Install latest versions (asdf v0.18.0+ supports 'latest' natively)
echo "  Installing latest versions..."

# Node.js
asdf install nodejs latest
asdf set nodejs latest --home

# Ruby
asdf install ruby latest
asdf set ruby latest --home

# Install bundler for Ruby
if ! command -v bundler >/dev/null 2>&1; then
  gem install bundler
fi

echo "  asdf installation complete!" 