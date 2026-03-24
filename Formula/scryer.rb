class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.9.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.14/scryer-darwin-arm64.tar.gz"
      sha256 "c7bcad99ab56adf5136e22e91a5c2a288176ba4a66a29f3110cfa2b24c917c56"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.14/scryer-darwin-x86_64.tar.gz"
      sha256 "fd2c3196301d2ffbbddd1111b8eadc520055caa749ed9754c1e0fa54c7aadc77"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.14/scryer-linux-arm64.tar.gz"
      sha256 "7db1cc48d8cd147167b65da4e38fa8d29d7edeb9185508825d08af6c7609709a"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.14/scryer-linux-x86_64.tar.gz"
      sha256 "b4d0032efddd887655209caffd3670f2524d11547e26899aa50d8d0c49e7563b"

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
