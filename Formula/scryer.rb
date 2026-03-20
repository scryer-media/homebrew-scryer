class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.9.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.13/scryer-darwin-arm64.tar.gz"
      sha256 "22397123c6f53472cd0c9f101ae5ce820da70c08fe57197e2b8d04defe158f88"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.13/scryer-darwin-x86_64.tar.gz"
      sha256 "676423e6c5144ac2044f4463de0019d375b5485038a6b575a2a0da6096abe931"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.13/scryer-linux-arm64.tar.gz"
      sha256 "6e89930f36b0288eb808aaad0a2549f6651dec799f9bcd5c52d4e8dc953bc7b7"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.13/scryer-linux-x86_64.tar.gz"
      sha256 "e52b7216573a3358c2ea80f64c12348279dd6e97434ad06b7b617df73f2ac454"

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
