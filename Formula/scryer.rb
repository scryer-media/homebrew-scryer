class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.21.20"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.21.20/scryer-darwin-arm64-portable.tar.gz"
      sha256 "42d8902e0e41b9bdc609d1989f23cf23d2bdbde3c7afe0c3184cff5dd46fb236"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.21.20/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "34352f0ca697fabcc6cebef61a8c83cedfdf27e0ca85947b9ea7e718008934d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.21.20/scryer-linux-arm64-portable.tar.gz"
      sha256 "06f6d10a94fc01ca42b3f3b3422374daf02d005969334776db9c49dc9034bd04"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.21.20/scryer-linux-x86_64-portable.tar.gz"
      sha256 "949192612fc722baf73ec2a27d81a964cc778c774bf6ef5f8c048b9b014c9fce"
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
