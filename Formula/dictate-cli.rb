class DictateCli < Formula
  desc "Local-first macOS dictation CLI using whisper.cpp"
  homepage "https://github.com/ricardo-nth/dictate-cli"
  url "https://github.com/ricardo-nth/dictate-cli/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "e780a600dd6d3d84f6d32e879dd7b01000b70371eba07e32fffdd315f9b8cd93"
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
