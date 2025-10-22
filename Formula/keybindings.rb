# ruby
class Keybindings < Formula
  desc "Little app to show your (favorite) keybindings"
  homepage "https://github.com/daschaa/keybindings"
  url "https://github.com/daschaa/keybindings/releases/download/v1.0.1/keybindings-darwin-arm64-1.0.1.zip"
  version "1.0.1"
  sha256 "6124e3d2f7227e7378419b634ce5daff739a4dcc468355f13e0f622711e9d12d"
  license "MIT"

  # Electron GUI app: use cask instead; formula disabled due to framework id rewrite issues.
  disable! date: "2025-10-22", because: "Use cask 'keybindings' for GUI app"

  def install
    odie "This formula is disabled. Install via: brew install --cask daschaa/tap/keybindings"
  end

  test do
    system "true"
  end
end
