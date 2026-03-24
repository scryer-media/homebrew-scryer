class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.9.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.15/scryer-darwin-arm64.tar.gz"
      sha256 "d6c567cdbf0172c8983aa4b02a09134e61735d0ad1c6b8f285e51f1f4f6707ee"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.15/scryer-darwin-x86_64.tar.gz"
      sha256 "5219f6b96f638baf97402301a0037090dba108794912da5da56181b76354a282"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.15/scryer-linux-arm64.tar.gz"
      sha256 "1aec576e0df27ff85929ddcf2265b1ba54c42b1def8ac97de2f8cf6c86b819f8"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.15/scryer-linux-x86_64.tar.gz"
      sha256 "293b935a581b262c76023462ca92a35d68d0356577e844b283c232d67b08a202"

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
