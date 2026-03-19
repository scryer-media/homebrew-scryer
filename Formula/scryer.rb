class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.9.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.10/scryer-darwin-arm64.tar.gz"
      sha256 "320bba84d61e6f7fb9c2ff1ca03f19eb58a29f7911f777da295f003deee977ba"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.10/scryer-darwin-x86_64.tar.gz"
      sha256 "91115c84a67a5b2e9f305ae9a67aad6667e261ab0b8d4096f8fb121023528870"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.10/scryer-linux-arm64.tar.gz"
      sha256 "4355bba1a40aa91fa19556d722c18515125b4988a458862326583a2cfcb68381"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.10/scryer-linux-x86_64.tar.gz"
      sha256 "6b2120a29845d33a43500beeaabe5e8655e5ebf846adf934832d63d28552cf85"

      def install
        bin.install "scryer"
      end
    end
  end

  service do
    run [opt_bin/"scryer", "--data-dir", var/"scryer"]
    keep_alive true
    log_path var/"log/scryer.log"
    error_log_path var/"log/scryer.log"
  end

  test do
    assert_match "scryer", shell_output("#{bin}/scryer --version")
  end
end
