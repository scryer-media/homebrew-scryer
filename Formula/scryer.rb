class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.15.1"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.1/scryer-darwin-arm64-apple-m1.tar.gz"
      sha256 "113584375a7d260896f9d736b26387185123adcf05e3e2d466550690d8a864db"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.1/scryer-darwin-x86_64-haswell.tar.gz"
      sha256 "e2e4eb5e0826187e086e7592cf2b1f9711b33397bb1044d18917bbecb4a05f22"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.1/scryer-linux-arm64-portable.tar.gz"
      sha256 "9d551df1a4bc7ac0a524536dc404ac76f9a810e18df357c3bacd19bbae91affb"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.15.1/scryer-linux-x86_64-portable.tar.gz"
      sha256 "2b37c8c5e4b308c00419e2846f1bd699ca8b738fa7a8e71fad8dd04b49f9e32a"
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
