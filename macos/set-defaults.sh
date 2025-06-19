# Sets reasonable macOS defaults.
#
# Run ./set-defaults.sh and you'll be good to go.

# Use AirDrop over every interface.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Always open everything in Finder's column view. 
defaults write com.apple.Finder FXPreferredViewStyle clmv

# Show the ~/Library folder.
chflags nohidden ~/Library

# Autohide dock
defaults write com.apple.dock autohide -bool true

# Put screenshots in a screenshot folder
defaults write com.apple.screencapture location -string "~/Desktop/Screenshots"

# Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Show bluetooth icon in menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true


