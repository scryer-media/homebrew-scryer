class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.17.2"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.2/scryer-darwin-arm64-portable.tar.gz"
      sha256 "4543bb6ba2555a09089e760db271c1e775b2da1fa8104a4b6d7427bfa88bb8e7"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.2/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "e53d8fbbf996de301290da89487e23c5333b80079af3b0aabdf1375fb6c7d0b8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.2/scryer-linux-arm64-portable.tar.gz"
      sha256 "7e07508323eec10c588e41a98cb28264ad4ae384189c7b4fe34ad88d107407b9"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.2/scryer-linux-x86_64-portable.tar.gz"
      sha256 "f9a2f271e275b670626d0238776069bdde8c858413fd12558601f3db5902bdfc"
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
