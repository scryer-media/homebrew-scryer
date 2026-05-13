class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.14.5"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.5/scryer-darwin-arm64.tar.gz"
      sha256 "1b269267a8e9e006d409327d32420692fa02f89f4e1c9710e1e8614955fdc1e9"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.5/scryer-darwin-x86_64.tar.gz"
      sha256 "687139ce6888eb464026ade2161cec0a26e8226bba45d75f5110acea3794499d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.5/scryer-linux-arm64.tar.gz"
      sha256 "890a78374dea34fa0bbb712fb747b74f856d46457bc014da2c3df69dded8eee8"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.5/scryer-linux-x86_64.tar.gz"
      sha256 "572ea3c2b2760af97ed2d27f2e48470b19fe29dd4fa87f2e11dd5ad5f1986c99"
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
