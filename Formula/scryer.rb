class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.0/scryer-darwin-arm64.tar.gz"
      sha256 "464dc44eedb32837725939cb28b9b43e8cecd3f79bbc4d09f8c700d661e56345"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.0/scryer-darwin-x86_64.tar.gz"
      sha256 "10e71a9e991d08a797b08aebfe18ae6341ef6b3ac771caeabf8b10f1c3862186"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.0/scryer-linux-arm64.tar.gz"
      sha256 "532c8825817a871c5b5dcd8016bfacc04a53d7267251d9d214a34d29c5de1b3b"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.0/scryer-linux-x86_64.tar.gz"
      sha256 "ec4ee616bbe5c2454d71a3724edbe9ca4d8498948bb444c62155c36704e1d167"

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
