class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.9.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.17/scryer-darwin-arm64.tar.gz"
      sha256 "697c43dfca5b556ab6762a49f541306d9f98544aba7b94094f7fbb60eadaeb0b"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.17/scryer-darwin-x86_64.tar.gz"
      sha256 "c27ad9409c3c8321e859e51fe2c67ad790ee13f319655df58ed08d5e32958528"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.17/scryer-linux-arm64.tar.gz"
      sha256 "5312b05aa5ecd6770c8530efa27b0ebbfcbad3dde5310f80b603b619565921f6"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.17/scryer-linux-x86_64.tar.gz"
      sha256 "ee6e28c99de0b9e1907093c5deea3bf1333b0586d37ca0053aec69ba3c8d11e5"

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
