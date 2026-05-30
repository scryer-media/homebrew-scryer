class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.15.9"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.9/scryer-darwin-arm64-apple-m1.tar.gz"
      sha256 "d7afe3504e9806940ff1ceb1565766211e5f2b0354c9e4c0fdb0e9b7caadd4d7"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.9/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "396519c2431a768d2f1805fb9bd9300cf13002f21598180a0abd14cff8754cf1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.9/scryer-linux-arm64-portable.tar.gz"
      sha256 "345b02f9a06384b8dd4c9615715fa65c69feb9e4f4a52f394e13c1579554076f"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.9/scryer-linux-x86_64-portable.tar.gz"
      sha256 "499d4ea5b0a896bf00e03bf65448a50628f921af98346631f71d6b2dc38a955a"
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
