class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.22.2"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.2/scryer-darwin-arm64-portable.tar.gz"
      sha256 "81c17bb39cd4a2ffb82ea1bfd921594c0e771160bc2ad72b8c5697d1e6821ea7"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.2/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "153a93010fce3227f76fdffb03d8d9d20b1bb906ae831b782992237f15df2c9c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.2/scryer-linux-arm64-portable.tar.gz"
      sha256 "297323d0036d38ed45f2ff982ba776cde3eba09e41349b8cfd37d2adee33b475"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.2/scryer-linux-x86_64-portable.tar.gz"
      sha256 "33200de78bff6b53d259e20997d4337b6c198ac321c6316ed66d2531fedafac4"
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
