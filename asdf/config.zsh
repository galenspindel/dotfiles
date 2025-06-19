# asdf configuration
if command -v asdf >/dev/null 2>&1; then
  # Set default tool versions ("latest" wasn't working, specified versions did)
  export ASDF_NODEJS_VERSION=24.2.0
  export ASDF_RUBY_VERSION=3.4.4

  # unclear if this is needed, but it was part of my debugging
    . $(brew --prefix asdf)/libexec/asdf.sh
    export ASDF_DATA_DIR="$(brew --prefix asdf)"

  # Set libyaml paths for ruby
    export LDFLAGS="-L$(brew --prefix libyaml)/lib"
    export CPPFLAGS="-I$(brew --prefix libyaml)/include"
    export PKG_CONFIG_PATH="$(brew --prefix libyaml)/lib/pkgconfig"

  # asdf utility functions (asdf v0.18.0+)
  asdf-install-all() {
    echo "Installing all global tools..."
    asdf install nodejs latest
    asdf install ruby latest
    # Add other tools as needed
  }

  asdf-update-all() {
    echo "Updating all asdf plugins..."
    asdf plugin update --all
  }

  asdf-cleanup() {
    echo "Cleaning up old versions..."
    asdf uninstall nodejs $(asdf list nodejs | tail -n +2 | head -n -1)
    asdf uninstall ruby $(asdf list ruby | tail -n +2 | head -n -1)
    # Add other tools as needed
  }

  # Project-specific helpers
  asdf-project-setup() {
    local project_type=$1
    case $project_type in
      "node"|"typescript")
        asdf local nodejs latest
        npm install
        ;;
      "ruby"|"rails")
        asdf local ruby latest
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