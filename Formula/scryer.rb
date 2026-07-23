class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.17.1"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.1/scryer-darwin-arm64-portable.tar.gz"
      sha256 "28d5b3aae99c011bf02993e9bd1e9487e5f99fae722fe16f2e354be60bc7b805"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.1/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "1f84f720759ba174418b8a8012a38f65ac5956cf1497bc5168c6f69371ab16a6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.1/scryer-linux-arm64-portable.tar.gz"
      sha256 "58e8ba16f0842331f4c7af193532fad505afede76ad9703fbf87585bf24432b5"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.17.1/scryer-linux-x86_64-portable.tar.gz"
      sha256 "ab94685f2639fab3d83face3ce1698e98927f2198475820ea2ea9bf91df5058f"
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
