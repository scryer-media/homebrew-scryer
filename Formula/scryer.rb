class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.17.3"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.3/scryer-darwin-arm64-portable.tar.gz"
      sha256 "9137220c4f613d8770a12d7307fb67f30d1370f2ad155c8a635cd6a7722e2e11"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.3/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "a82027d6d4006e1d8dad24309cb015d0861dbb2d5cf376545841c58f91ac55db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.3/scryer-linux-arm64-portable.tar.gz"
      sha256 "09de06a06f01278c72f03e2244549118ea3e9e170541f0f84c5e5f62184d6b90"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.3/scryer-linux-x86_64-portable.tar.gz"
      sha256 "1d6a047c0894376e50d26624d7e244b98e0ae9f09cb56303602af35dba5b482f"
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
