class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.13.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.13.2/scryer-darwin-arm64.tar.gz"
      sha256 "3e419568b987071877c0034e2bacbb11653c0a45c201e757f1518a518bd4e8d2"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.13.2/scryer-darwin-x86_64.tar.gz"
      sha256 "3892268d2dbec0d801438ce6d53b9ce7a4c5cc2e72d368c92d86d59204771dc1"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.13.2/scryer-linux-arm64.tar.gz"
      sha256 "51d473805acd52384dd64448f60f94bca26efa259e658d1fac4b5a71381d5192"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.13.2/scryer-linux-x86_64.tar.gz"
      sha256 "704a354e9923cef7e9d65284918d47e13f47129c71a76beded42cd0c933c037c"

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
