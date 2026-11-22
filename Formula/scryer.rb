class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.23.0"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.23.0/scryer-darwin-arm64-portable.tar.gz"
      sha256 "f0c08e961cb43d7fade6a5167e1ccceafaca999583f33708aca4423788f22764"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.23.0/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "3567b8abd9aefe0a885be7666afee3cd9864f9464aff5d8e14eaa2eb27be705b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.23.0/scryer-linux-arm64-portable.tar.gz"
      sha256 "a83fadf7af578d0770fa89128ed3a66a23e19c9d20e08ba3576a3f2bed15d205"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.23.0/scryer-linux-x86_64-portable.tar.gz"
      sha256 "5d1e9ff1fee4a54cdeed738a54241575467347206a9154fbf87fb025afeb200b"
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
