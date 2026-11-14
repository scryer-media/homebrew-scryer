class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.22.4"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.4/scryer-darwin-arm64-portable.tar.gz"
      sha256 "cbe9f9f2a203570a78f5c478693153d2a3e4465a3eafced3cd7ce97e79267280"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.4/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "2a73b77136345342aec6c5c1d1381da589d8873de326971454e7dd8b56b973dc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.4/scryer-linux-arm64-portable.tar.gz"
      sha256 "d8b29baa35bbb4178b31aa3746ce906df2580d8fafe2cc525f362dde52fea5e4"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.4/scryer-linux-x86_64-portable.tar.gz"
      sha256 "50a414a681dd34f23d25bee6aeccf5017a2fb077e7a0cf24010bb9081d2ec85d"
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
