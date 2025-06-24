# asdf configuration
if command -v asdf >/dev/null 2>&1; then
  # Set default tool versions (fallback to specific versions if latest fails)
  export ASDF_NODEJS_VERSION=24.2.0
  export ASDF_RUBY_VERSION=3.4.4

  # Source asdf
  . $(brew --prefix asdf)/libexec/asdf.sh

  # Set libyaml paths for ruby
  export LDFLAGS="-L$(brew --prefix libyaml)/lib"
  export CPPFLAGS="-I$(brew --prefix libyaml)/include" 
  export PKG_CONFIG_PATH="$(brew --prefix libyaml)/lib/pkgconfig"

  # asdf utility functions with fallback versions
  asdf-install-all() {
    echo "Installing all global tools..."
    
    # Try latest first, fallback to specific version
    echo "Installing Node.js..."
    if ! asdf install nodejs latest 2>/dev/null; then
      echo "Latest failed, installing Node.js $ASDF_NODEJS_VERSION"
      asdf install nodejs $ASDF_NODEJS_VERSION
    fi
    
    echo "Installing Ruby..."
    if ! asdf install ruby latest 2>/dev/null; then
      echo "Latest failed, installing Ruby $ASDF_RUBY_VERSION"
      asdf install ruby $ASDF_RUBY_VERSION
    fi
  }

  asdf-update-all() {
    echo "Updating all asdf plugins..."
    asdf plugin update --all
  }

  # Safer cleanup function - only removes versions except latest and current
  asdf-cleanup() {
    echo "Cleaning up old versions (keeping latest and current)..."
    
    # Get currently set global versions
    local current_node=$(asdf current nodejs 2>/dev/null | awk '{print $2}')
    local current_ruby=$(asdf current ruby 2>/dev/null | awk '{print $2}')
    
    # List installed versions and remove old ones (except latest 2)
    asdf list nodejs 2>/dev/null | head -n -2 | while read version; do
      if [[ "$version" != "$current_node" ]]; then
        echo "Removing old Node.js version: $version"
        asdf uninstall nodejs "$version"
      fi
    done
    
    asdf list ruby 2>/dev/null | head -n -2 | while read version; do
      if [[ "$version" != "$current_ruby" ]]; then
        echo "Removing old Ruby version: $version"
        asdf uninstall ruby "$version"
      fi
    done
  }

  # Project-specific helpers with fallback
  asdf-project-setup() {
    local project_type=$1
    case $project_type in
      "node"|"typescript")
        if ! asdf local nodejs latest 2>/dev/null; then
          echo "Using fallback Node.js version $ASDF_NODEJS_VERSION"
          asdf local nodejs $ASDF_NODEJS_VERSION
        fi
        npm install
        ;;
      "ruby"|"rails")
        if ! asdf local ruby latest 2>/dev/null; then
          echo "Using fallback Ruby version $ASDF_RUBY_VERSION"
          asdf local ruby $ASDF_RUBY_VERSION
        fi
        gem install bundler
        bundle install
        ;;
      *)
        echo "Unknown project type: $project_type"
        echo "Supported types: node, typescript, ruby, rails"
        ;;
    esac
  }
fi 