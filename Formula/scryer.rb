class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.16.5"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.5/scryer-darwin-arm64-portable.tar.gz"
      sha256 "b77c4baab41d61aae0f613ff1b7607c14661bafd50c0b805d2b2bb3791525864"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.5/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "887e562d294c85a59e2f1b84bdaa92510c18e61ea3a2c91150470a04011d2c39"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.5/scryer-linux-arm64-portable.tar.gz"
      sha256 "3dcb12fb7de30dad49564b8c589b696739ff4814b66608a9f0a14311918f4288"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.5/scryer-linux-x86_64-portable.tar.gz"
      sha256 "62ef480d5835a4ab4a88e620a0903ba5ef7a760535ddbf174c85678dca69832e"
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
