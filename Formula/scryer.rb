class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.17.0"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.0/scryer-darwin-arm64-portable.tar.gz"
      sha256 "ae53615feed174395d2534b8df5434d6bd8bf102244182bf58e16cedfe75ab24"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.0/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "a44a06826267c40bf91388f39a06a7feff8b7bcb99cd336d706178c7f80a35db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.0/scryer-linux-arm64-portable.tar.gz"
      sha256 "313769bb553d26b7cf819dfa346546547c8bc03de7f3ca4d651b06287498e03e"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.0/scryer-linux-x86_64-portable.tar.gz"
      sha256 "a96d0ea872a07bfc0dbfce5b903c2ec0145c42515932c0d32415daa979e0482f"
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
