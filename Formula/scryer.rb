class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.9.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.13/scryer-darwin-arm64.tar.gz"
      sha256 "5de9d00b6271d5a317bfc941a21be7e06f01ad17318e3ba4597182328924b1e2"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.13/scryer-darwin-x86_64.tar.gz"
      sha256 "ba8e6abbfd69421c15baeec506fbb3fd7f930f1bb32dc008e9e4d3435a4f707b"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.13/scryer-linux-arm64.tar.gz"
      sha256 "3025e696809c8e20f88863fa6d42ff4d6f066d1ba3d287a868ebc869dd1c7c91"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.13/scryer-linux-x86_64.tar.gz"
      sha256 "7946afb1bd60a4fdad3560ec18f4a715b0f38abc68d1133a555cb2d53c5d1e76"

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
