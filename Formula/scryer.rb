class Scryer < Formula
  desc "Self-hosted media acquisition and management platform"
  homepage "https://github.com/scryer-media/scryer"
  version "0.14.3"
  license "MIT"

  def install_support_files
    (pkgshare/"config.env.example").write <<~EOS
      # Homebrew-managed Scryer service overrides.
      SCRYER_BIND=127.0.0.1:8686
    EOS

    (libexec/"scryer-service").write <<~SH
      #!/bin/sh
      CONFIG_FILE="#{etc}/scryer/config.env"

      if [ -f "" ]; then
        set -a
        . ""
        set +a
      fi

      exec "#{opt_bin}/scryer" --data-dir "#{var}/scryer" ""
    SH

    chmod 0755, libexec/"scryer-service"
  end

  on_macos do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.3/scryer-darwin-arm64.tar.gz"
      sha256 "a3a4f691892037ca2f54d3b73d8ce3f97f3afd8131dad8ba4e52b205363d3d38"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.3/scryer-darwin-x86_64.tar.gz"
      sha256 "3bb34e7df84b2979bf5355700d298e064e2bfa0fdfc550cf2736e964383d112f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.3/scryer-linux-arm64.tar.gz"
      sha256 "bed07834a6affa7ceda58dce792f35989a7aec4b629bcd2e6432fa2cbd1d2da0"
    end

    on_intel do
      url "https://github.com/scryer-media/scryer/releases/download/scryer-v0.14.3/scryer-linux-x86_64.tar.gz"
      sha256 "7c8eaf53461a4061d538bed491e2bfbf2983743aed42c8b07fc6da8c2681c6b0"
    end
  end

  def install
    bin.install "scryer"
    install_support_files

    config_dir = etc/"scryer"
    config_dir.mkpath
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
