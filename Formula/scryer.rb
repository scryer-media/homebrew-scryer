class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.22.3"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.3/scryer-darwin-arm64-portable.tar.gz"
      sha256 "81f6ef1d165d56fd414379a0d833a8431d8c18fc021a1b62cbaea388d68dff59"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.3/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "31509378ea41e866166216cd4cbcc020059cea296a948511f8f07e30ebd846b9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.3/scryer-linux-arm64-portable.tar.gz"
      sha256 "6137c44e423178b97560ae63b8f0c01e45d73161f01cc87f10b7f3fbfc456b0c"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.22.3/scryer-linux-x86_64-portable.tar.gz"
      sha256 "528cb8d15db5329eb6027825f59824561b65a821b0de3b45d90de29930dd81ca"
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
