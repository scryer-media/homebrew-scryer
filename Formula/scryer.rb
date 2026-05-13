class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.14.4"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.4/scryer-darwin-arm64.tar.gz"
      sha256 "25f5a9fc7759991a9f6afa8b690da86ffec34f7ca1c09391aae191e25b530ab9"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.4/scryer-darwin-x86_64.tar.gz"
      sha256 "5fb3693110d10aa3e191ee7e39c6a4a5bd3f0b9cad8fbac5f933c5f6924b6d4d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.4/scryer-linux-arm64.tar.gz"
      sha256 "1dcb43d28bf4e8705318067591c556c63bf4f290afdd7791ddec3ca2c13d211d"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.4/scryer-linux-x86_64.tar.gz"
      sha256 "33b32523f8a67f49e12b495f9953cd1a66ebe25e77283a43db80652bf229326f"
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
