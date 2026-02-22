class TmuxWhisper < Formula
  desc "Tmux-first macOS voice coding CLI using whisper.cpp"
  homepage "https://github.com/ricardo-nth/tmux-whisper"
  url "https://github.com/ricardo-nth/tmux-whisper/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "7cda9346da217d4a96f959ec04bf34e6998a8304f13184fe2bdcc7d73815b712"
  license "MIT"

  depends_on :macos

  def install
    libexec.install "bin/tmux-whisper", "bin/dictate-lib.sh"
    (bin/"tmux-whisper").write_env_script libexec/"tmux-whisper", DICTATE_LIB_PATH: libexec/"dictate-lib.sh"
    bin.install_symlink libexec/"dictate-lib.sh" => "dictate-lib.sh"

    pkgshare.install "config", "integrations", "assets", "tools"
    pkgshare.install "install.sh", "bootstrap.sh", "README.md", "CHANGELOG.md"
  end

  def caveats
    <<~EOS
      Optional defaults and assets (paths remain under `dictate` for now):

        cp -Rn "#{opt_pkgshare}/config" "$HOME/.config/dictate"
        mkdir -p "$HOME/.local/share/sounds/dictate"
        cp -n "#{opt_pkgshare}/assets/sounds/dictate/"*.wav "$HOME/.local/share/sounds/dictate/" 2>/dev/null || true

      Then run:

        tmux-whisper debug
    EOS
  end

  test do
    output = shell_output("#{bin}/tmux-whisper --help")
    assert_match "tmux-whisper: local whisper.cpp dictation", output
  end
end
