#!/bin/sh

# Ensure correct version of Carthage
# Unlink existing version
brew unlink carthage
# Install 0.35.0
brew install https://github.com/Homebrew/homebrew-core/raw/27c7544d9bf5f9e4f09d7e47ba505f250b1259f2/Formula/carthage.rb
# Switch to 0.35.0
brew switch carthage 0.35.0

# Cache Cartfile
if [ -n "$FORCE_CARTHAGE" ] || ! cmp -s Cartfile.resolved Carthage/Cartfile.resolved; then
  # If not running on CircleCI, update dependencies
  if [ -z "${CIRCLECI:-}" ]; then
    echo "Updating dependencies"
    carthage update --platform iOS
  # Else if running on CircleCI, build resolved dependencies
  else
    echo "Resolving dependencies"
    carthage bootstrap --platform iOS
  fi
  cp Cartfile.resolved Carthage
fi
