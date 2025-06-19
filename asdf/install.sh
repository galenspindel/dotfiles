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
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
fi

# Ruby
if ! asdf plugin list | grep -q "ruby"; then
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
fi

# Python (if needed)
# if ! asdf plugin list | grep -q "python"; then
#   asdf plugin add python https://github.com/danhper/asdf-python.git
# fi

# Go (if needed)
# if ! asdf plugin list | grep -q "golang"; then
#   asdf plugin add golang https://github.com/kennyp/asdf-golang.git
# fi

# Rust (if needed)
# if ! asdf plugin list | grep -q "rust"; then
#   asdf plugin add rust https://github.com/code-lever/asdf-rust.git
# fi

# PostgreSQL (if needed)
# if ! asdf plugin list | grep -q "postgres"; then
#   asdf plugin add postgres https://github.com/smashedtoatoms/asdf-postgres.git
# fi

# Redis (if needed)
# if ! asdf plugin list | grep -q "redis"; then
#   asdf plugin add redis https://github.com/smashedtoatoms/asdf-redis.git
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

# Python (if needed)
# asdf install python latest
# asdf global python latest

# Go (if needed)
# asdf install golang latest
# asdf global golang latest

# Rust (if needed)
# asdf install rust latest
# asdf global rust latest

# PostgreSQL (if needed)
# asdf install postgres latest
# asdf local postgres latest

# Redis (if needed)
# asdf install redis latest
# asdf local redis latest

echo "  asdf installation complete!" 