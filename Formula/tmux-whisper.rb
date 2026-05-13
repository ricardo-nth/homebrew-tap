class TmuxWhisper < Formula
  desc "Tmux-first macOS voice dictation CLI with local ASR backends"
  homepage "https://github.com/ricardo-nth/tmux-whisper"
  url "https://github.com/ricardo-nth/tmux-whisper/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e95c25b615ad93450e19f402998ec640565bae3c8328813f4f9e95491d2f089d"
  license "MIT"
  revision 1

  depends_on :macos

  def install
    libexec.install "bin/tmux-whisper", "bin/dictate-lib.sh", "bin/tmux-whisper-lib"
    (bin/"tmux-whisper").write_env_script(
      libexec/"tmux-whisper",
      DICTATE_LIB_PATH:         libexec/"dictate-lib.sh",
      DICTATE_INTERNAL_LIB_DIR: libexec/"tmux-whisper-lib",
    )
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
    assert_match "tmux-whisper: local dictation for macOS", output
  end
end
