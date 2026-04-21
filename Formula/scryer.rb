class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.11.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.3/scryer-darwin-arm64.tar.gz"
      sha256 "3a1d0d87546035f2e3cbdc331ae69fbce8f5e6c3211326e09544f74d782ffa0e"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.3/scryer-darwin-x86_64.tar.gz"
      sha256 "5e76266470ebeb051e158b4ef7fa0a8c45064a5bf8eda21242266b96dfff35ae"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.3/scryer-linux-arm64.tar.gz"
      sha256 "b766aa49f215d858c7eba1aaf140d580377e78e3728b3e6fb93c0b39f1b4057a"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.11.3/scryer-linux-x86_64.tar.gz"
      sha256 "980b287e0d2cf95f2b058dac8153bc4d5b907eb791ef14df1844709051f8d305"

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
