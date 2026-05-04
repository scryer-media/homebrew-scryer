class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.13.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.13.3/scryer-darwin-arm64.tar.gz"
      sha256 "37c0aeab0207f6104d081404187d457fba6cb349377d3f6a8f17a3236c46ca76"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.13.3/scryer-darwin-x86_64.tar.gz"
      sha256 "a9367f6d0fc8bd86831f54a36997d052ca2aa583a1741fc9703262957499937c"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.13.3/scryer-linux-arm64.tar.gz"
      sha256 "c693ecc66cb6d59e1aaebdfccaaf7eeedf5dfa3ff0e4d570ed5ed20d9a4bc742"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.13.3/scryer-linux-x86_64.tar.gz"
      sha256 "41c605907cf9b7406d23d2c095596fd3a00f7b4e19a284baf88cae461af2877d"

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
