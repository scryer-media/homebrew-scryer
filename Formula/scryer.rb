class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.11.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.4/scryer-darwin-arm64.tar.gz"
      sha256 "7f7d2d22a854d144c9577739be5a7b9969a4320ed9ec5fc4ac9bf1a8e94610f0"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.4/scryer-darwin-x86_64.tar.gz"
      sha256 "91d99350e6a109684daded3208019adc0046b2021d6fc49bee065b84920a1af4"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.4/scryer-linux-arm64.tar.gz"
      sha256 "af608501574c3b154f0579e19475ada4cf0497b85b4d1e58185b2756e3101c81"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.4/scryer-linux-x86_64.tar.gz"
      sha256 "10107bcec29c01f57c5e1b0098659dbba7e2bd977a21cefb8eefd0b806e7769b"

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
