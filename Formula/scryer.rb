class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.12.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.12.0/scryer-darwin-arm64.tar.gz"
      sha256 "69eec8bcabe97e45a4da10c7b77d578de54016d340769dbdc8099ae94ba8d2f8"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.12.0/scryer-darwin-x86_64.tar.gz"
      sha256 "2d8edd127cc06c8dc25bf46b4926a73ca43c917883e4c737ce75abd3bad7575d"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.12.0/scryer-linux-arm64.tar.gz"
      sha256 "c642f30acdc540497abc2b1b52d7ee7ef603bfe8a48027fcf37d24a4b6521718"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.12.0/scryer-linux-x86_64.tar.gz"
      sha256 "e11dd184acb3ed8c5b2cda02fb7d79909ea348fa6a06a162cf34d8429e482883"

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
