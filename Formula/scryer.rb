class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.14.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.2/scryer-darwin-arm64.tar.gz"
      sha256 "5c46c20d49438693f4490629b639e46eb6dcc16a028f584973ff79a7f3daa62b"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.2/scryer-darwin-x86_64.tar.gz"
      sha256 "dde7be3002039df76467380f876ded78f2c6d1982207bf37cd154a220adba312"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.2/scryer-linux-arm64.tar.gz"
      sha256 "cdae89f16e098c6a6ab7a36467072254e953a0c013e8ef75f3025c3157bb19d0"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.2/scryer-linux-x86_64.tar.gz"
      sha256 "47c2d19ea396e55bc73cbb424ef272b0659d138f3e172bdf299a7b347d57f259"

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
