class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.9.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.16/scryer-darwin-arm64.tar.gz"
      sha256 "401e82ec1d992634ded27d4206aa6e3aa3430a551d586da472b24d58658f4fdb"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.16/scryer-darwin-x86_64.tar.gz"
      sha256 "62737c22dba5420b210eadcdc2b96f32b6d5ff7dd7015f8e00bf9e54bab73451"

      def install
        bin.install "scryer"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.16/scryer-linux-arm64.tar.gz"
      sha256 "18da44992a59a3744bf686182672e0ed97ecbaf4d84498e567eb363cbe474321"

      def install
        bin.install "scryer"
      end
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.9.16/scryer-linux-x86_64.tar.gz"
      sha256 "54d72969d96b41f88dee1f5a631662a60b1201c363328f79c4ecf20cf3b7c3d5"

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
