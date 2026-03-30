class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.10.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.1/scryer-darwin-arm64.tar.gz"
      sha256 "4b8f6e87ab759e7ceefb87a1c411a14d907d98bd4971bf06eeeac8554b11429b"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.1/scryer-darwin-x86_64.tar.gz"
      sha256 "08502736f7c22bffcf009b33dfca3484b5d02d11825987bebe24dd8fb9a7ba4d"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.1/scryer-linux-arm64.tar.gz"
      sha256 "061f735e33f2d27a19a2ceec95b0aa75223e70c626b67ab460b22762a7d781f4"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.1/scryer-linux-x86_64.tar.gz"
      sha256 "a9e357c6a6710de645843787af160b08f7bdf4a4c93b4182d956b4172e8be231"

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
