# ruby
class Keybindings < Formula
  desc "Little app to show your (favorite) keybindings"
  homepage "https://github.com/daschaa/keybindings"
  version "1.0.1"
  url "https://github.com/daschaa/keybindings/releases/download/v#{version}/keybindings-darwin-arm64-#{version}.zip"
  sha256 "6124e3d2f7227e7378419b634ce5daff739a4dcc468355f13e0f622711e9d12d"
  license "MIT"

  # Electron GUI bundle triggers Homebrew dylib ID rewriting failures; use the cask instead.
  disable! date: "2025-10-22", because: "Use the 'keybindings' cask (GUI app) – formula install_name fixups break signed Electron frameworks"

  def install
    odie "This formula is disabled. Install via: brew install --cask daschaa/tap/keybindings"
  end

  test do
    system "true"
  end
end
