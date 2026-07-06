class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.16.7"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.7/scryer-darwin-arm64-portable.tar.gz"
      sha256 "22ea0be048f7f87ab1798ca6df135138a11536d8ff5dab75dbe3dc2ba201c3de"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.7/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "3186165e573dcc23d1f374eec33ddf1f3b22a94c4d8265bcb8fce015f389c8ec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.7/scryer-linux-arm64-portable.tar.gz"
      sha256 "dc4ae250ba0dace74b2a487674a5059beef84caf3581d319ccb593227e5aba39"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.7/scryer-linux-x86_64-portable.tar.gz"
      sha256 "f738965a93fd4a36e4c7f4b7a62be224143d3219115ac7d391dd181d727a7312"
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
