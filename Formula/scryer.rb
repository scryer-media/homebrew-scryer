class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.11.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.2/scryer-darwin-arm64.tar.gz"
      sha256 "b5eeb7d88a67186ae0374090a79e1451a2173d2ba1f4822e54816538df85f79b"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.2/scryer-darwin-x86_64.tar.gz"
      sha256 "55a1ba36c1ed6b0b9cbb462e39bbd8c9051b91c3ea1e5e5ea45a0c29c56b1410"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.2/scryer-linux-arm64.tar.gz"
      sha256 "619ec840b87c1ece74bee45f08fea892573fd3f3e2f107c4e8dd017a17456766"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.2/scryer-linux-x86_64.tar.gz"
      sha256 "7f955f702a5df2238f2de3ec3f4862a486c517cc0f69062bd45e56fc05dacb11"

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
