class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.10.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.3/scryer-darwin-arm64.tar.gz"
      sha256 "22b76906d6be923bc4b58a01803397d791745f62dcfba41b485ce295fb676db8"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.3/scryer-darwin-x86_64.tar.gz"
      sha256 "d0946d38b91e52cfd6e4d718f2e6b60add2bb47c0e0bb9020ed6495d2155c848"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.3/scryer-linux-arm64.tar.gz"
      sha256 "d2be758a02654da7a5fdb804bb3844f69e4bc8d5a961d97d81dacc12cab866b2"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.3/scryer-linux-x86_64.tar.gz"
      sha256 "ce753ce4178d1ad0f3737406c2d123dc0da571cdbec8fa56e2e7b7b03d8c1293"

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
