class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.15.6"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.6/scryer-darwin-arm64-apple-m1.tar.gz"
      sha256 "50925f6bc844525e241ad858d9103d88bfa7e1ebc1bb862bb7906f8816df5c37"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.6/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "c38e0523b7ac6aebe95fc76fab92a46e813b3edcb754fcacab2766b24e021fce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.6/scryer-linux-arm64-portable.tar.gz"
      sha256 "c2a942d173e12f62ba97c0e23c611f7ff4f2ce42d57d9b5ce0b26b39fb6d1a9f"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.6/scryer-linux-x86_64-portable.tar.gz"
      sha256 "9c219b457abea3eb727f532adb5fb9af368d896aa45286b614872ed0025c6610"
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
