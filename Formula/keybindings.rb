class Keybindings < Formula
  desc "Little app to show your (favorite) keybindings"
  homepage "https://github.com/daschaa/keybindings"
  url "https://github.com/daschaa/keybindings/releases/download/v1.0.0/keybindings-darwin-arm64-1.0.0.zip"
  sha256 "0d9df33f2d74306c724f16f8b449e268229c4a9bdebe475f4c8c9dbd7d751d27"
  license "MIT"

  # Restrict to Apple Silicon only.
  depends_on arch: :arm64

  def install
    if Hardware::CPU.intel?
      odie "Keybindings only supports Apple Silicon (arm64) Macs."
    end

    app_name = "keybindings.app" # Match Electron productName capitalization.
    unless File.directory?(app_name)
      odie "Expected #{app_name} in the archive, but it was not found."
    end

    prefix.install app_name

    # Attempt to remove the macOS quarantine attribute if present to avoid first-launch warnings.
    if OS.mac?
      app_path = prefix/app_name
      # Check if the attribute exists; ignore failures quietly.
      if system("xattr", "-p", "com.apple.quarantine", app_path.to_s)
        system "xattr", "-d", "com.apple.quarantine", app_path.to_s
      end
    end

    (bin/"keybindings").write <<~EOS
      #!/bin/bash
      open "#{prefix}/#{app_name}" "$@"
    EOS
    chmod 0755, bin/"keybindings"
  end

  def caveats
    <<~EOS
      Keybindings is a GUI application. Launch it via:
        keybindings
      or from Finder at:
        #{prefix}/keybindings.app

      This build is only available for Apple Silicon (arm64) Macs.

      The formula attempts to remove the macOS quarantine attribute automatically. If macOS still blocks the app, open it once via Finder (Right-click > Open) to approve it.
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
