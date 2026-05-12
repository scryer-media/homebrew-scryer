class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.14.2"
  license "MIT"

  def install_support_files
    (pkgshare/"config.env.example").write <<~EOS
      # Example overrides for the Homebrew-managed scryer service.
      # Uncomment and edit as needed, then copy this file to:
      #   #{etc}/scryer/config.env
      #
      # SCRYER_BIND=127.0.0.1:8090
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.2/scryer-darwin-arm64.tar.gz"
      sha256 "5c46c20d49438693f4490629b639e46eb6dcc16a028f584973ff79a7f3daa62b"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.2/scryer-darwin-x86_64.tar.gz"
      sha256 "dde7be3002039df76467380f876ded78f2c6d1982207bf37cd154a220adba312"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.2/scryer-linux-arm64.tar.gz"
      sha256 "cdae89f16e098c6a6ab7a36467072254e953a0c013e8ef75f3025c3157bb19d0"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.2/scryer-linux-x86_64.tar.gz"
      sha256 "47c2d19ea396e55bc73cbb424ef272b0659d138f3e172bdf299a7b347d57f259"
    end
  end

  def install
    bin.install "scryer"
    install_support_files
  end

  def caveats
    <<~EOS
      To customize the Homebrew-managed service environment:
        mkdir -p #{etc}/scryer
        cp #{opt_pkgshare}/config.env.example #{etc}/scryer/config.env

      Then edit #{etc}/scryer/config.env and restart the service:
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
