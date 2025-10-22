# ruby
class Keybindings < Formula
  desc "Little app to show your (favorite) keybindings"
  homepage "https://github.com/daschaa/keybindings"
  version "1.0.0"
  url "https://github.com/daschaa/keybindings/releases/download/v#{version}/keybindings-darwin-arm64-#{version}.zip"
  sha256 "0d9df33f2d74306c724f16f8b449e268229c4a9bdebe475f4c8c9dbd7d751d27"
  license "MIT"

  def install
    odie "keybindings only supports Apple Silicon (arm64) Macs" if Hardware::CPU.intel?

    app_dir_name = "keybindings.app"
    bundle_path = buildpath/app_dir_name

    if bundle_path.directory?
      # Normal case: archive contained keybindings.app at top level.
      prefix.install app_dir_name
    elsif (buildpath/"Contents/Info.plist").exist?
      # Flattened case: we are already inside what should be keybindings.app.
      (prefix/app_dir_name).install Dir["*"]
    else
      # Fallback: search any depth (exact match) then pattern.
      found_exact = Dir.glob("**/#{app_dir_name}").find { |p| File.basename(p) == app_dir_name }
      if found_exact && File.directory?(found_exact)
        prefix.install found_exact
      else
        # List discovered .app bundles (likely only helpers) for diagnostics.
        discovered = Dir.glob("**/*.app").map { |p| p.sub(/^\.\//, '') }.uniq.sort
        odie "#{app_dir_name} not found. Discovered bundles: #{discovered.empty? ? '(none)' : discovered.join(', ')}"
      end
    end

    # Launcher script to open the GUI app.
    (bin/"keybindings").write <<~EOS
      #!/bin/bash
      open "#{prefix}/#{app_dir_name}" "$@"
    EOS
    chmod 0755, bin/"keybindings"
  end

  def caveats
    <<~EOS
      Launch with: keybindings
      Only Apple Silicon is supported.
      macOS Gatekeeper quarantine is normally removed by Homebrew; no manual xattr needed.
      If macOS warns on first launch, right-click the app bundle and choose Open once.
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
