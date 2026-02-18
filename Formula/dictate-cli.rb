class DictateCli < Formula
  desc "Local-first macOS dictation CLI using whisper.cpp"
  homepage "https://github.com/ricardo-nth/dictate-cli"
  url "https://github.com/ricardo-nth/dictate-cli/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c8a4186839e9f1d9051d61b6940b11935734a8134825edeb97312d51c0fe8a84"
  license "MIT"

  depends_on :macos

  def install
    libexec.install "bin/dictate", "bin/dictate-lib.sh"
    (bin/"dictate").write_env_script libexec/"dictate", DICTATE_LIB_PATH: libexec/"dictate-lib.sh"
    bin.install_symlink libexec/"dictate-lib.sh" => "dictate-lib.sh"

    pkgshare.install "config", "integrations", "assets", "tools"
    pkgshare.install "install.sh", "bootstrap.sh", "README.md", "CHANGELOG.md"
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
