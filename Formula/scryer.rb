class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.22.5"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.5/scryer-darwin-arm64-portable.tar.gz"
      sha256 "50a6093d09363b2ef15472aa1c8f5b74985f665b43c168842e4ad1fb8a475ad9"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.5/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "cd2039f2978f716d3f09dff1aaed855fd2c98c3964c4deae8b0155eeefc09067"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.5/scryer-linux-arm64-portable.tar.gz"
      sha256 "3094609cea5fd2a05821212f0fb366f2051fb7f0a8ed7192eb550f744402e4d9"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.5/scryer-linux-x86_64-portable.tar.gz"
      sha256 "d1cfc0eeecc036f3b5ebeee0ead96fd71103936b85a8b599e22c3d93245a690a"
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
