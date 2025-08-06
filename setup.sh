#!/usr/bin/env bash
#
# setup.sh - Unified dotfiles setup with modular options
#
# Usage:
#   ./setup.sh                    # Interactive setup (default)
#   ./setup.sh --minimal          # Basic setup only
#   ./setup.sh --full             # Complete setup with all options
#   ./setup.sh --apps             # Install apps (casks + App Store)
#   ./setup.sh --dry-run          # Preview changes without applying
#   ./setup.sh --help             # Show help

set -e

cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd -P)

# Default options
MINIMAL_SETUP=false
FULL_SETUP=false
APPS_ONLY=false
DRY_RUN=false
INTERACTIVE=true
FORCE=false

# Color output functions
info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

warn () {
  printf "\r\033[2K  [ \033[0;33mWARN\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  echo "Setup failed: $1"
  echo "Run with --help for usage information."
  exit 1
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

dry_run () {
  if [ "$DRY_RUN" = true ]; then
    printf "\r  [ \033[0;35mDRY\033[0m ] $1\n"
    return 0
  else
    return 1
  fi
}

# Show help
show_help() {
  cat << EOF
setup.sh - Unified dotfiles setup

USAGE:
    ./setup.sh [OPTIONS]

OPTIONS:
    --minimal       Basic setup only (symlinks + git config)
    --full          Complete setup (includes everything)
    --apps          Install apps only (casks + App Store apps)
    --interactive   Interactive setup with choices (default)
    --dry-run       Preview changes without applying them
    --force         Skip confirmations and prerequisites
    --help          Show this help message

EXAMPLES:
    ./setup.sh                    # Interactive setup
    ./setup.sh --minimal          # Just dotfiles, no software
    ./setup.sh --full --force     # Complete automated setup
    ./setup.sh --apps             # Just install applications
    ./setup.sh --dry-run          # See what would be done

SETUP LEVELS:
    Minimal:     Symlinks, git config, shell setup
    Interactive: Ask about each component
    Apps:        Cask applications + App Store apps
    Full:        Everything (CLI tools, apps, dev environment, macOS defaults)

DEVELOPMENT TOOLS INCLUDE:
    - mise plugins and language versions (Node.js, Ruby)
    - Application configurations (Cursor IDE, Claude CLI)
    - Development environment setup
EOF
}

# Parse command line arguments
parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --minimal)
        MINIMAL_SETUP=true
        INTERACTIVE=false
        shift
        ;;
      --full)
        FULL_SETUP=true
        INTERACTIVE=false
        shift
        ;;
      --apps)
        APPS_ONLY=true
        INTERACTIVE=false
        shift
        ;;
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      --force)
        FORCE=true
        shift
        ;;
      --help|-h)
        show_help
        exit 0
        ;;
      *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
    esac
  done
}

# Run prerequisites check
run_prerequisites() {
  if [ "$FORCE" = true ]; then
    info "Skipping prerequisites check (--force)"
    return 0
  fi

  if dry_run "Would run prerequisites check"; then
    return 0
  fi

  if [ -f "$DOTFILES_ROOT/script/check-prerequisites" ]; then
    info "Running prerequisites check..."
    "$DOTFILES_ROOT/script/check-prerequisites"
  else
    warn "Prerequisites check not found, proceeding anyway"
  fi
}

# Setup git configuration
setup_git() {
  if dry_run "Would setup git configuration"; then
    return 0
  fi

  info "Setting up git configuration..."
  
  # Use the existing bootstrap git setup logic
  if ! [ -f git/gitconfig.local.symlink ]; then
    if [ ! -f git/gitconfig.local.symlink.example ]; then
      fail "git/gitconfig.local.symlink.example not found"
    fi

    git_credential='cache'
    if [ "$(uname -s)" == "Darwin" ]; then
      git_credential='osxkeychain'
    fi

    if [ "$FORCE" = true ]; then
      # Use default values for automated setup
      git_authorname="Your Name"
      git_authoremail="your.email@example.com"
      warn "Using default git credentials (--force). Update later in ~/.gitconfig.local"
    else
      # Interactive input with validation
      while [ -z "$git_authorname" ]; do
        user ' - What is your github author name?'
        read -e git_authorname
        if [ -z "$git_authorname" ]; then
          echo "   Author name cannot be empty. Please try again."
        fi
      done

      while [ -z "$git_authoremail" ]; do
        user ' - What is your github author email?'
        read -e git_authoremail
        if [ -z "$git_authoremail" ]; then
          echo "   Email cannot be empty. Please try again."
        elif ! echo "$git_authoremail" | grep -E '^[^@]+@[^@]+\.[^@]+$' >/dev/null; then
          echo "   Please enter a valid email address."
          git_authoremail=""
        fi
      done
    fi

    if sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.example > git/gitconfig.local.symlink; then
      success 'Git configuration created'
    else
      fail 'Failed to create git configuration'
    fi
  else
    success 'Git configuration already exists'
  fi
}

# Install dotfiles symlinks
install_symlinks() {
  if dry_run "Would install dotfiles symlinks"; then
    # Show what would be symlinked
    for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*' 2>/dev/null); do
      dst="$HOME/.$(basename "${src%.*}")"
      dry_run "  $src -> $dst"
    done
    return 0
  fi

  info 'Installing dotfiles symlinks'
  
  # Use the existing bootstrap link logic but simplified
  local overwrite_all=false backup_all=false skip_all=false
  
  if [ "$FORCE" = true ]; then
    overwrite_all=true
  fi

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*' 2>/dev/null); do
    dst="$HOME/.$(basename "${src%.*}")"
    
    local overwrite= backup= skip=
    local action=

    if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then
      if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then
        local currentSrc="$(readlink "$dst" 2>/dev/null || echo '')"

        if [ "$currentSrc" == "$src" ]; then
          skip=true
        else
          user "File already exists: $dst, what do you want to do?\n        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
          read -n 1 action
          echo

          case "$action" in
            o ) overwrite=true;;
            O ) overwrite_all=true;;
            b ) backup=true;;
            B ) backup_all=true;;
            s ) skip=true;;
            S ) skip_all=true;;
            * ) skip=true;;
          esac
        fi
      fi

      overwrite=${overwrite:-$overwrite_all}
      backup=${backup:-$backup_all}
      skip=${skip:-$skip_all}

      if [ "$overwrite" == "true" ]; then
        rm -rf "$dst"
        success "Removed $dst"
      fi

      if [ "$backup" == "true" ]; then
        mv "$dst" "${dst}.backup"
        success "Backed up $dst to ${dst}.backup"
      fi

      if [ "$skip" == "true" ]; then
        info "Skipped $src"
        continue
      fi
    fi

    if ln -s "$src" "$dst" 2>/dev/null; then
      success "Linked $src to $dst"
    else
      fail "Failed to link $src to $dst"
    fi
  done
}

# Install Homebrew (without apps)
install_homebrew() {
  if dry_run "Would install Homebrew and command-line tools"; then
    return 0
  fi

  info "Installing Homebrew and command-line tools..."
  
  # Install Homebrew if needed
  # if [ -f "$DOTFILES_ROOT/homebrew/install.sh" ]; then
    # Source the install script to get brew in PATH
  #  . "$DOTFILES_ROOT/homebrew/install.sh" 2>&1
  # else
  #  fail "Homebrew install script not found"
  # fi
  
  # Install command-line packages from main Brewfile
  if [ -f "$DOTFILES_ROOT/Brewfile" ]; then
    info "Installing command-line packages from Brewfile..."
    brew bundle --file="$DOTFILES_ROOT/Brewfile"
    success "Homebrew command-line packages installed"
  else
    warn "Brewfile not found, skipping package installation"
  fi
}

# Install applications (casks + App Store apps)
install_apps() {
  if dry_run "Would install applications (casks + App Store apps)"; then
    if [ -f "$DOTFILES_ROOT/Brewfile.casks" ]; then
      dry_run "  Cask apps from Brewfile.casks:"
      grep '^cask ' "$DOTFILES_ROOT/Brewfile.casks" | sed 's/^/    /'
    fi
    if [ -f "$DOTFILES_ROOT/bin/mas-install" ]; then
      dry_run "  App Store apps via mas-install"
    fi
    return 0
  fi

  info "Installing applications..."
  
  # Install cask applications from separate Brewfile.casks
  if [ -f "$DOTFILES_ROOT/Brewfile.casks" ]; then
    info "Installing cask applications from Brewfile.casks..."
    brew bundle --file="$DOTFILES_ROOT/Brewfile.casks"
    success "Cask applications installed"
  else
    warn "Brewfile.casks not found, skipping cask installation"
  fi
  
  # Install App Store apps via mas
  if [ -f "$DOTFILES_ROOT/bin/mas-install" ]; then
    info "Installing App Store applications..."
    "$DOTFILES_ROOT/bin/mas-install" sync
    success "App Store applications installed"
  else
    warn "mas-install script not found, skipping App Store apps"
  fi
}

# Install development tools
install_dev_tools() {
  if dry_run "Would install development tools (mise, language versions, app configs)"; then
    return 0
  fi

  info "Installing development tools and configurations..."
  
  # Run the development tools installer
  if [ -f "$DOTFILES_ROOT/script/install" ]; then
    "$DOTFILES_ROOT/script/install"
    success "Development tools and configurations installed"
  else
    warn "Development tools install script not found"
  fi
}

# Set macOS defaults
set_macos_defaults() {
  if [ "$(uname -s)" != "Darwin" ]; then
    return 0
  fi

  if dry_run "Would set macOS defaults"; then
    return 0
  fi

  if [ -f "$DOTFILES_ROOT/macos/set-defaults.sh" ]; then
    info "Setting macOS defaults..."
    "$DOTFILES_ROOT/macos/set-defaults.sh"
    success "macOS defaults set"
  else
    warn "macOS defaults script not found"
  fi
}

# Interactive setup - ask about each component
interactive_setup() {
  echo ''
  info 'Interactive dotfiles setup'
  echo ''
  
  user 'Install Homebrew and command-line tools? [Y/n]'
  read -n 1 install_brew
  echo
  if [[ "$install_brew" =~ ^[Nn]$ ]]; then
    SKIP_HOMEBREW=true
  fi
  
  user 'Install applications (casks + App Store apps)? [Y/n]'
  read -n 1 install_apps_choice
  echo
  if [[ "$install_apps_choice" =~ ^[Nn]$ ]]; then
    SKIP_APPS=true
  fi
  
  user 'Install development tools (mise, Node.js, Ruby, etc.)? [Y/n]'
  read -n 1 install_dev
  echo
  if [[ "$install_dev" =~ ^[Nn]$ ]]; then
    SKIP_DEV_TOOLS=true
  fi
  
  user 'Set macOS system defaults? [Y/n]'
  read -n 1 set_defaults
  echo
  if [[ "$set_defaults" =~ ^[Nn]$ ]]; then
    SKIP_MACOS_DEFAULTS=true
  fi
  
  echo ''
}

# Main setup orchestration
main_setup() {
  echo ''
  info "Starting dotfiles setup..."
  echo ''
  
  if [ "$APPS_ONLY" = true ]; then
    # Apps-only setup - just install applications
    install_apps
    return 0
  fi
  
  # Always do core setup for other modes
  setup_git
  install_symlinks
  
  # Conditional components based on setup type
  if [ "$MINIMAL_SETUP" = true ]; then
    info "Minimal setup complete - skipping additional software installation"
  elif [ "$FULL_SETUP" = true ]; then
    install_homebrew
    install_apps
    install_dev_tools
    set_macos_defaults
  elif [ "$INTERACTIVE" = true ]; then
    interactive_setup
    
    if [ "$SKIP_HOMEBREW" != true ]; then
      install_homebrew
    fi
    
    if [ "$SKIP_APPS" != true ]; then
      install_apps
    fi
    
    if [ "$SKIP_DEV_TOOLS" != true ]; then
      install_dev_tools
    fi
    
    if [ "$SKIP_MACOS_DEFAULTS" != true ]; then
      set_macos_defaults
    fi
  fi
}

# Validate setup after completion
validate_setup() {
  if [ "$DRY_RUN" = true ]; then
    info "Dry run complete - no validation needed"
    return 0
  fi

  echo ''
  user 'Run setup validation? [Y/n]'
  read -n 1 run_validation
  echo
  
  if [[ ! "$run_validation" =~ ^[Nn]$ ]]; then
    if [ -f "$DOTFILES_ROOT/script/validate-setup" ]; then
      "$DOTFILES_ROOT/script/validate-setup"
    else
      warn "Validation script not found"
    fi
  fi
}

# Main execution
main() {
  parse_args "$@"
  
  if [ "$DRY_RUN" = true ]; then
    warn "DRY RUN MODE - No changes will be made"
    echo ''
  fi
  
  # Skip prerequisites for apps-only mode
  if [ "$APPS_ONLY" != true ]; then
    run_prerequisites
  fi
  
  main_setup
  
  # Skip validation for apps-only mode
  if [ "$APPS_ONLY" != true ]; then
    validate_setup
  fi
  
  echo ''
  success 'Dotfiles setup complete!'
  echo ''
  
  if [ "$DRY_RUN" = false ]; then
    echo 'Next steps:'
    if [ "$APPS_ONLY" = true ]; then
      echo '  1. Applications have been installed'
      echo '  2. You may need to restart some applications'
    else
      echo '  1. Restart your terminal or run: source ~/.zshrc'
      echo '  2. Run "dot" periodically to keep everything updated'
      if [ "$MINIMAL_SETUP" = true ]; then
        echo '  3. Run "./setup.sh --apps" to install applications later'
        echo '  4. Run "./setup.sh --full" for complete setup'
      fi
    fi
  else
    echo 'To actually apply these changes, run without --dry-run'
  fi
  echo ''
}

main "$@"