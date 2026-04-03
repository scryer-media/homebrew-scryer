class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.10.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.5/scryer-darwin-arm64.tar.gz"
      sha256 "8a0c4c51b0ebed9f1fe570197257a6ac1f35412570433ae41958e32039247e43"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.5/scryer-darwin-x86_64.tar.gz"
      sha256 "b694aa0df526a48c5d012558296c39dec0ec237e4543e4640f32a6ad61fddf9b"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.5/scryer-linux-arm64.tar.gz"
      sha256 "9d2f3f4fe1521d9c8047ceea824f386d57ca64887e7de335c92f416187faf37d"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.5/scryer-linux-x86_64.tar.gz"
      sha256 "81bc5e19b1fa9a17b6e71ab07f46da66a068bcb2d291ebb9ec57af7cabf71671"

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
