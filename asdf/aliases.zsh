# Quick version management (asdf v0.18.0+)
alias node-latest='a plugin update nodejs && a install nodejs latest && a global nodejs latest'
alias ruby-latest='a plugin update ruby && a install ruby latest && a global ruby latest'

# Development environment helpers
alias dev-setup='asdf reshim && bundle install && npm install'
alias dev-clean='asdf reshim && bundle clean --force && npm prune' 