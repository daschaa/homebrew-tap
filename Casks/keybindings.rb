cask "keybindings" do
  arch arm: "arm64"

  version "1.0.1"
  sha256 "6124e3d2f7227e7378419b634ce5daff739a4dcc468355f13e0f622711e9d12d"

  url "https://github.com/daschaa/keybindings/releases/download/v#{version}/keybindings-darwin-#{arch}-#{version}.zip"
  name "keybindings"
  desc "Little app to show your (favorite) keybindings"
  homepage "https://github.com/daschaa/keybindings"

  depends_on arch: :arm64
  depends_on macos: ">= :big_sur"
  conflicts_with formula: "keybindings"
  auto_updates false

  app "keybindings.app"

  # Remove quarantine attribute (harmless if absent)
  postflight do
    app_path = "#{staged_path}/keybindings.app"
    system_command "/usr/bin/xattr", args: ["-d", "com.apple.quarantine", app_path], must_succeed: false
  end

  caveats do
    <<~EOS
      Only Apple Silicon (arm64) is supported.
      Launch from /Applications or run: open -a keybindings
      If Gatekeeper blocks the first launch, right-click the app and choose Open.
    EOS
  end

  zap trash: [
    "~/Library/Application Support/keybindings",
    "~/Library/Logs/keybindings",
    "~/Library/Saved Application State/com.daschaa.keybindings.savedState",
    "~/Library/Preferences/com.daschaa.keybindings.plist"
  ]

  livecheck do
    url :homepage
    strategy :github_latest
  end
end
