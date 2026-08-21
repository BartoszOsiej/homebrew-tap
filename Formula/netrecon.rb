class Netrecon < Formula
  desc "Fast network reconnaissance - host discovery & port scanning (Rust)"
  homepage "https://github.com/BartoszOsiej/cybersec-tools"
  version "0.4.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BartoszOsiej/cybersec-tools/releases/download/v0.4.5/netrecon-aarch64-apple-darwin"
      sha256 "6a197cbb494eef32d94f2b2c95a223bc99312867c08a47e2b59b00ac97e5c4eb"
    else
      url "https://github.com/BartoszOsiej/cybersec-tools/releases/download/v0.4.5/netrecon-x86_64-apple-darwin"
      sha256 "ac6f2c60a4104253a5798e94e32732e729dd0d5ffe9da0a4dc24bbcf99f0fbcf"
    end
  end

  def install
    if Hardware::CPU.arm?
      binary "netrecon-aarch64-apple-darwin"
    else
      binary "netrecon-x86_64-apple-darwin"
    end
  end

  test do
    system "#{bin}/netrecon", "--help"
  end
end
