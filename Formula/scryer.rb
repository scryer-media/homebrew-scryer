class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.10.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.4/scryer-darwin-arm64.tar.gz"
      sha256 "d6ae90f2a09f27dc8c7fcfd86f6eace0c3b222e76925599960dfb9b763d9e6dd"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.4/scryer-darwin-x86_64.tar.gz"
      sha256 "9108b2ea1563d5bea8d94dbbb35a371b9665694c154b44a0262c65340b54e885"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.4/scryer-linux-arm64.tar.gz"
      sha256 "67656602946a9e4465ef1d08d3e0f9a312fe1aba4d2f80ab3bc81bff665982f1"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.4/scryer-linux-x86_64.tar.gz"
      sha256 "3ba50cb290a488272ef9a9653123010f20891c71797e826cd7425343cb2e95c2"

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
