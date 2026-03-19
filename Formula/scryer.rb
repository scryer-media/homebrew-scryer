class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.9.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.11/scryer-darwin-arm64.tar.gz"
      sha256 "15bd1fd242b47a3ef74cab1add58a10015b4c2cb48393224d2408197c12181e9"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.11/scryer-darwin-x86_64.tar.gz"
      sha256 "7596b1fe0fbdf0f1e8512ad86d870c7d7c869ed606492b6976461e8c336781ba"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.11/scryer-linux-arm64.tar.gz"
      sha256 "ac06f1e5cb8d70f7fd7bfedbcf78f5048c5adf527ba79f600e206a2129c84bd8"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.11/scryer-linux-x86_64.tar.gz"
      sha256 "bb444c2512b127cbfc1043e2433244efe96f93edb232e5137d64dfafaa503897"

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
