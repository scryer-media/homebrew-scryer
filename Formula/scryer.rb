class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.22.1"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.1/scryer-darwin-arm64-portable.tar.gz"
      sha256 "0f7f50fe9c6bcc7fcecf31fef5f61f6b9225f66d01007e7d9f02efae1e0adcfa"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.1/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "4c1f5229107c07028bb0e25e2573491205726dc6f82a71f5a52bbc4d2c1666b6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.1/scryer-linux-arm64-portable.tar.gz"
      sha256 "748ccf45a979fea5d4a34d9b1c03fc5b0182b78dc87e27f021ce50a9969bfeb7"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.1/scryer-linux-x86_64-portable.tar.gz"
      sha256 "47a5e158eaa024d7471e6eeb8bf412f73b73c4d00e7892e2440fbadccc6be2d8"
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
