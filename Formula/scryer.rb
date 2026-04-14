class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.10.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.7/scryer-darwin-arm64.tar.gz"
      sha256 "aee695debaac09f6b50840edc4cc0901ad9fbbccddeff57d5dd14708c9608cc0"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.7/scryer-darwin-x86_64.tar.gz"
      sha256 "f8c4d0d1cbb986cc8f2c25cf5d006e1a373eaf3f0c666dccc34cbfb53894dac5"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.7/scryer-linux-arm64.tar.gz"
      sha256 "6fcb7d1c5aad1f51c045a2e0708b72c7259e5af501ebfd60b146bc414e6450a1"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.7/scryer-linux-x86_64.tar.gz"
      sha256 "a0044b357294763d17845040696e77ab3ccfbf8eaf76238ff59a8acf6f96ec77"

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
