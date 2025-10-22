# Daschaa Tap

## How do I install these formulae?

`brew install daschaa/tap/<formula>`

Or `brew tap daschaa/tap` and then `brew install <formula>`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "daschaa/tap"
brew "<formula>"
```

## GUI App (keybindings)

The Electron GUI app is distributed as a cask (recommended for macOS application bundles). The old formula is disabled due to Electron framework dylib ID rewrite issues.

Install:

```bash
brew tap daschaa/tap
brew install --cask keybindings
```

Upgrade (when a new version is released):

```bash
brew upgrade --cask keybindings
```

Uninstall and remove supporting files:

```bash
brew uninstall --cask keybindings
brew zap --cask keybindings   # optional cleanup
```

Add to a Brewfile:

```ruby
cask "keybindings"
```

## Updating the cask version

1. Download the new release ZIP.
2. Compute SHA256:

```bash
shasum -a 256 keybindings-darwin-arm64-<version>.zip
```
3. Update `version` and `sha256` in `Casks/keybindings.rb`.
4. Run:

```bash
brew audit --cask keybindings --new
brew install --cask ./Casks/keybindings.rb
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
