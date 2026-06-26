class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.16.6"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.6/scryer-darwin-arm64-portable.tar.gz"
      sha256 "cd4991ddf49846b2f012e345c2aff22b4d7323f45e181ba5fe1c899b1d6da42d"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.6/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "5b94eabda2c64ed9d5e14a30abd588057221794171b54ad2ce1f8aef523bf507"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.6/scryer-linux-arm64-portable.tar.gz"
      sha256 "8b9ae69a44047f99339ba4bbd96722ed8a9b4bb81c2e4b5d2029367050957c57"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.6/scryer-linux-x86_64-portable.tar.gz"
      sha256 "8cfa89ba8ff829a1c50ae816f3ba6637a8a5a3f04317c64c0a0bd14d07ea54c8"
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
