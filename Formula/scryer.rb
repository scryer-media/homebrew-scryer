class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.9.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.12/scryer-darwin-arm64.tar.gz"
      sha256 "5dcad117f1b0b5e59352267b070d695d47226b386fb438e3bcb14c58c69c502b"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.12/scryer-darwin-x86_64.tar.gz"
      sha256 "8e9a5cae1cfc5692709cef11375da5a4b14ac87000bb01bb153d42784ce89a3e"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.12/scryer-linux-arm64.tar.gz"
      sha256 "4a2438309ea6aa2b1678b23da7f3d060a18e3ac755080e061ea4b474c8ef3517"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.12/scryer-linux-x86_64.tar.gz"
      sha256 "7de453fe027a61ee9111aa8e52737dc2cb6688e0fc5e2967b4bb7b10e76b6a96"

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
