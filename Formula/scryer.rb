class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.15.4"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.4/scryer-darwin-arm64-apple-m1.tar.gz"
      sha256 "c28ccc07ab0788641c6322dcd375a230dc3bcc49b3f4d4ff2cabfd86d8bff82b"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.4/scryer-darwin-x86_64-haswell.tar.gz"
      sha256 "b0c20d0bbba15f5aa98037ae545f4ae4846836aad3c7294469ffba2ef8435627"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.4/scryer-linux-arm64-portable.tar.gz"
      sha256 "7fbbe2975bd2be3b88af228d2366631ceb1a9564f6df6f1c48640072ddb865d8"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.4/scryer-linux-x86_64-portable.tar.gz"
      sha256 "2b760274197b04cc5bce48373282cb394cf990aeb6a0e016a77b63bca0bb6af1"
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
