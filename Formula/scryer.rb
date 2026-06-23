class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.16.3"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.3/scryer-darwin-arm64-portable.tar.gz"
      sha256 "01247925a80973a7bcdfcd91428c303b1046c40e47d66b9662bde85daf519529"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.3/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "187bcaab03ada294d1199144e3ae2af90041acbe09a48ab56982ec97a456c803"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.3/scryer-linux-arm64-portable.tar.gz"
      sha256 "733c3359a176a436dcfb3e051e27d77ec82a02b6360001b7cac6da627d8e1a04"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.16.3/scryer-linux-x86_64-portable.tar.gz"
      sha256 "160844441c65dfbcf6178c8024240691aac11d003598078fe83a2a10815f806d"
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
