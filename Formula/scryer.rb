class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.0/scryer-darwin-arm64.tar.gz"
      sha256 "ffc851a9cd3649beb2600b4f1d46cda6f764ff7701345c990fe66b07325cdcf7"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.0/scryer-darwin-x86_64.tar.gz"
      sha256 "9508a60727549dc378357de05ca7e64205364ecf816da744ab46757fa343235e"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.0/scryer-linux-arm64.tar.gz"
      sha256 "8af9414882ebd7329220b14e7af12bcc89537e03830f277f1d3300111578c1f0"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.0/scryer-linux-x86_64.tar.gz"
      sha256 "a97ef05383d6838cdf3f112c5e1f8f72c420cc7483ad34f2c6d0cb573488e2cb"

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
