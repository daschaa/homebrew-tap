# ruby
class Keybindings < Formula
  desc "Little app to show your (favorite) keybindings"
  homepage "https://github.com/daschaa/keybindings"
  url "https://github.com/daschaa/keybindings/releases/download/v1.0.0/keybindings-darwin-arm64-1.0.0.zip"
  sha256 "0d9df33f2d74306c724f16f8b449e268229c4a9bdebe475f4c8c9dbd7d751d27"
  license "MIT"

  def install
    odie "Keybindings only supports Apple Silicon (arm64) Macs." if Hardware::CPU.intel?

    # Prefer a top-level keybindings.app; avoid nested helper bundles.
    app_path = Dir.glob("**/*.app").find { |p| File.basename(p).casecmp("keybindings.app").zero? } ||
                   Dir.glob("**/*.app").first
    odie "keybindings.app not found in archive." unless app_path

    prefix.install app_path

    (bin/"keybindings").write <<~EOS
      #!/bin/bash
      open "#{prefix}/keybindings.app" "$@"
    EOS
    chmod 0755, bin/"keybindings"
  end

  def caveats
    <<~EOS
      Launch with: keybindings
      Only Apple Silicon is supported.
      If macOS warns on first launch, right-click the app in Finder and choose Open.
    EOS
  end

  livecheck do
    url :homepage
    regex(/keybindings[._-]darwin[._-]arm64[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  test do
    assert_predicate bin/"keybindings", :exist?
    assert_predicate prefix/"keybindings.app", :directory?
  end
end
