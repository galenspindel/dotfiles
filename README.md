# galen's dotfiles

Forked from https://github.com/holman/dotfiles

Should be able to set up a brand new machine from scratch (mostly)

## Unified Setup (Recommended)
```sh
git clone https://github.com/galenspindel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Interactive setup (asks about each component)
./setup.sh

# OR: Minimal setup (just dotfiles, no software)
./setup.sh --minimal

# OR: Complete automated setup
./setup.sh --full --force

# OR: Install applications only
./setup.sh --apps

# Preview changes without applying
./setup.sh --dry-run
```

## Manual Setup (Legacy)
```sh
# Optional: Check prerequisites first
script/check-prerequisites

# Run the main setup
script/bootstrap

# Optional: Validate everything worked
script/validate-setup
```

## Post-Setup
- Enable FiraCode Nerd Font in iTerm2 `Preferences -> Profiles -> Text`
- Enable FiraCode Nerd Font in Cursor

## Troubleshooting
If something goes wrong:
- Run `script/check-prerequisites` to verify your system
- Run `script/validate-setup` to check what's broken
- Run `script/restore-backup` to undo changes if needed

## Keeping Things Updated

## Using the Enhanced `dot` Command
The `dot` command has been enhanced with subcommands for targeted updates:

```sh
# Update everything (default)
dot

# Update applications only (casks + App Store)
dot apps

# Update development tools only
dot dev

# Check system status and validate setup
dot check

# Create backup before making changes
dot backup

# Restore from backup if needed
dot restore

# Preview changes without applying them
dot --dry-run

# Open dotfiles directory for editing
dot --edit
```

## Manual Management
This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

## Managing Applications
Applications are now managed separately from command-line tools:

- **`Brewfile`** - Command-line tools and development dependencies
- **`Brewfile.casks`** - GUI applications (cask applications)
- **`bin/mas-install`** - App Store applications

To add/remove applications, edit the appropriate file for your needs.

## Notes about structure

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/install.sh**: Any file named `install.sh` is executed when you run `script/install`. To avoid being loaded automatically, its extension is `.sh`, not `.zsh`.
- **topic/\*.symlink**: Any file ending in `*.symlink` gets symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.
