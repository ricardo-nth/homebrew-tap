class DictateCli < Formula
  desc "Local-first macOS dictation CLI using whisper.cpp"
  homepage "https://github.com/ricardo-nth/dictate-cli"
  url "https://github.com/ricardo-nth/dictate-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "2fca0b4c3532b204abccc9e064ca0de7bdb436399316e0442bd217adf83c00cb"
  license "MIT"

  depends_on :macos

  def install
    libexec.install "bin/dictate", "bin/dictate-lib.sh"
    (bin/"dictate").write_env_script libexec/"dictate", DICTATE_LIB_PATH: libexec/"dictate-lib.sh"
    bin.install_symlink libexec/"dictate-lib.sh" => "dictate-lib.sh"

    pkgshare.install "config", "integrations", "assets", "tools", "install.sh", "bootstrap.sh", "README.md", "CHANGELOG.md"
  end

  def caveats
    <<~EOS
      Optional defaults and assets:

        cp -Rn "#{opt_pkgshare}/config" "$HOME/.config/dictate"
        mkdir -p "$HOME/.local/share/sounds/dictate"
        cp -n "#{opt_pkgshare}/assets/sounds/dictate/"*.wav "$HOME/.local/share/sounds/dictate/" 2>/dev/null || true

      Then run:

        dictate debug
    EOS
  end

  test do
    output = shell_output("#{bin}/dictate --help")
    assert_match "dictate: local whisper.cpp dictation", output
  end
end
