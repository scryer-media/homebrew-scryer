class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.21.23"
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
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.21.23/scryer-darwin-arm64-portable.tar.gz"
      sha256 "7f8289445c4130e82e0298149c55e6dec7c9dd3d335dd454421bfb39ed5729ca"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.21.23/scryer-darwin-x86_64-portable.tar.gz"
      sha256 "d96da9733a08d5c34706d35899b220092a341372afa6bd9a0b1f3f26e44fbcc9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.21.23/scryer-linux-arm64-portable.tar.gz"
      sha256 "1832bab6bb010777e71905d69c0d07fb4f3da0acf3325a36763beb0864638e5a"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.21.23/scryer-linux-x86_64-portable.tar.gz"
      sha256 "2b52bf65d3a892b722db721d3ec431e52edf787ba2171a2ecb0f258236fc891f"
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
