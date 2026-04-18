class TmuxWhisper < Formula
  desc "Tmux-first macOS voice dictation CLI with local ASR backends"
  homepage "https://github.com/ricardo-nth/tmux-whisper"
  url "https://github.com/ricardo-nth/tmux-whisper/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "96ffdc2af3aaaed739cf0a3d2f85cd9c0f47b9515faf3e72d3f30061d6db7d32"
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
    assert_match "tmux-whisper: local dictation with pluggable ASR backends", output
  end
end
