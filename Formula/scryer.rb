class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.15.0"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.0/scryer-darwin-arm64-apple-m1.tar.gz"
      sha256 "17e3d051efc3d2dbaf14643530b2c0ba4e47861b928d1be805d0ad080d2de74a"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.0/scryer-darwin-x86_64-haswell.tar.gz"
      sha256 "a573571edeb4f5037f9522d35c3b66d5401367879f2204f1e3d8b0d5e4a06438"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.0/scryer-linux-arm64-portable.tar.gz"
      sha256 "4cefa4076e1015d074855939b4bf36b0ac6d316a3af4984d853c9aed05d007a3"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.0/scryer-linux-x86_64-portable.tar.gz"
      sha256 "c37298318e54861bb6fd43038cbd3b797742ad0afd5de239ba4f713824868b1e"
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
