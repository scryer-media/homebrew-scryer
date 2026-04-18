class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.11.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.1/scryer-darwin-arm64.tar.gz"
      sha256 "3bf69fb2ef5b22f1436a5853df71a35a368ec468d1d50c3341d8230437f3e820"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.1/scryer-darwin-x86_64.tar.gz"
      sha256 "44028462e73edf507bcc756918e2e13e8a44c64334c5d103916a1ec94c334cfc"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.1/scryer-linux-arm64.tar.gz"
      sha256 "f5d3bc28df12c6a2932d9c9de8c6282611582b62bae10cc0bdd8dbd151abefe2"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.1/scryer-linux-x86_64.tar.gz"
      sha256 "bbd13bef8d8bd9c31405531f171a3e17a03bb43fc5b5003412d8181051f4653c"

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
