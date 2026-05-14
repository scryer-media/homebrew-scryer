class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.14.6"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.6/scryer-darwin-arm64.tar.gz"
      sha256 "74bf1c0e4c5cad7cdec06933d5edf660a92b110fc04ee7057f89f4ac9a71cea0"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.6/scryer-darwin-x86_64.tar.gz"
      sha256 "e1062e4bb01c571671e0974478a9d56f334432bea4b0dbcfd8623be64711709f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.6/scryer-linux-arm64.tar.gz"
      sha256 "a4b9fe8865a647af9bacf07cd2c4939749819fd782f6ee68367e9f3cc6b45466"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.6/scryer-linux-x86_64.tar.gz"
      sha256 "2faa98a8de365beeb5323f78229c1bede13ff66028e99ac9c81ad4c39e459b14"
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
