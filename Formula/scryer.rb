class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.12.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.12.2/scryer-darwin-arm64.tar.gz"
      sha256 "2e25e2f15c53b0ad29a980b95220430ebe107f98f5d529995a09460d13a413fb"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.12.2/scryer-darwin-x86_64.tar.gz"
      sha256 "30e6e6a9dea14353b8f0fb944840d43c81f4aef6391b21533aa02c12ba91c7be"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.12.2/scryer-linux-arm64.tar.gz"
      sha256 "368fbae31419665e446d53944450865da126c9cef1d253a08059cb3245d1609f"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.12.2/scryer-linux-x86_64.tar.gz"
      sha256 "917dbce6faaa32e347db4bc1b5415ba32e256aba9f6357ae7767928820b3b2d3"

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
