class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.10.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.2/scryer-darwin-arm64.tar.gz"
      sha256 "48b7e826b3a946b29c36b3ed60a0a9ec7f5f068ed69251874d82954424eea161"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.2/scryer-darwin-x86_64.tar.gz"
      sha256 "6a454cb1568e289d1479681975151a33eb791e8dcc3196c88ea105a2270a336e"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.2/scryer-linux-arm64.tar.gz"
      sha256 "fe5bf2d7bfec01e1c9b8dcc0d73bdd7821e0a5216ddef3629d81eb1fdcdd59ff"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.10.2/scryer-linux-x86_64.tar.gz"
      sha256 "93997bb66706d4605e65a34dfaa2cb4cbfec4fc6238593a0103e7281f5242330"

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
