# ruby
class Keybindings < Formula
  desc "Little app to show your (favorite) keybindings"
  homepage "https://github.com/daschaa/keybindings"
  url "https://github.com/daschaa/keybindings/releases/download/v1.0.0/keybindings-darwin-arm64-1.0.0.zip"
  sha256 "0d9df33f2d74306c724f16f8b449e268229c4a9bdebe475f4c8c9dbd7d751d27"
  license "MIT"

  def install
    if Hardware::CPU.intel?
      odie "Keybindings only supports Apple Silicon (arm64) Macs."
    end

    # Locate the .app (handles capitalization and nested directory).
    app_path = Dir.glob("**/*.app").find { |p| File.basename(p).casecmp("keybindings.app").zero? } ||
               Dir.glob("**/*.app").first
    odie "No .app bundle found in the archive." unless app_path

    # Install the .app bundle.
    prefix.install app_path

    # Remove quarantine if present (optional).
    potential = prefix/File.basename(app_path)
    if OS.mac? && system("xattr", "-p", "com.apple.quarantine", potential.to_s)
      system "xattr", "-d", "com.apple.quarantine", potential.to_s
    end

    (bin/"keybindings").write <<~EOS
      #!/bin/bash
      open "#{prefix}/#{File.basename(app_path)}" "$@"
    EOS
    chmod 0755, bin/"keybindings"
  end

  def caveats
    <<~EOS
      GUI app. Launch with:
        keybindings
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
