class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.23.1"
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

      SCRYER_PACKAGE=homebrew
      export SCRYER_PACKAGE

      exec "#{opt_bin}/scryer" --data-dir "#{var}/scryer" "$@"
    SH

    chmod 0755, libexec/"scryer-service"
  end

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.23.1/scryer-darwin-arm64-portable.tar.gz"
      sha256 "eb89470082a61c15328e5090fd865cdc87715ae5f71fd0e1defa0a427b831c66"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.23.1/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "8aa721693c341da5da7d63cc3ea1e425bc35e9f7600bd725d67f3af780543713"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.23.1/scryer-linux-arm64-portable.tar.gz"
      sha256 "fbc179469bd631eeac2c179e8d8f2b1f13046e33e617789c31a527dc2cacb98e"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.23.1/scryer-linux-x86_64-portable.tar.gz"
      sha256 "5c4b734803bbfeb2b7eede31b055bc864e1419e04fb4d0b26e13f425ec407c6c"
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
