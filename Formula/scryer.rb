class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.16.1"
  license "MIT"

  def install_support_files
    (pkgshare/"config.env.example").write <<~EOS
      # Homebrew-managed Scryer service overrides.
      SCRYER_BIND=127.0.0.1:8686
    EOS

    (libexec/"scryer-service").write <<~SH
      #!/bin/sh
      CONFIG_FILE="#{etc}/scryer/config.env"

      if [ -f "$CONFIG_FILE" ]; then
        set -a
        . "$CONFIG_FILE"
        set +a
      fi

      exec "#{opt_bin}/scryer" --data-dir "#{var}/scryer" "$@"
    SH

    chmod 0755, libexec/"scryer-service"
  end

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.1/scryer-darwin-arm64-portable.tar.gz"
      sha256 "c0fb69710c8de67b5048ab3d34c14d8010d9c24bc5120ff36e40cfc95b4a357a"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.1/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "f4d1e8d0077acb45c86b5d8bb876ac3bed070f71e9e267ade236ad2d4e29dd22"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.1/scryer-linux-arm64-portable.tar.gz"
      sha256 "6b5eadc6e76c27411bf737495da2e8e53cf0b921e3daf0e2046d832d111e38f9"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.1/scryer-linux-x86_64-portable.tar.gz"
      sha256 "f07a28357353d874a51954a50412939a117ad9b3fba46cfafed1065de99c99de"
    end
  end

  def install
    bin.install "scryer"
    install_support_files

    config_dir = etc/"scryer"
    config_dir.mkpath
    (var/"scryer").mkpath
    (var/"log").mkpath
    config_file = config_dir/"config.env"
    unless config_file.exist?
      config_file.write <<~EOS
        SCRYER_BIND=127.0.0.1:8686
      EOS
    end
  end

  def caveats
    <<~EOS
      Edit #{etc}/scryer/config.env to customize the Homebrew-managed service,
      then restart it with:
        brew services restart scryer
    EOS
  end

  service do
    run [opt_libexec/"scryer-service"]
    keep_alive true
    log_path var/"log/scryer.log"
    error_log_path var/"log/scryer.log"
  end

  test do
    assert_match "scryer", shell_output("#{bin}/scryer --version")
  end
end
