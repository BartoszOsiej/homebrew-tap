class Netrecon < Formula
  desc "Fast network reconnaissance - host discovery & port scanning (Rust)"
  homepage "https://github.com/BartoszOsiej/cybersec-tools"
  version "1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BartoszOsiej/cybersec-tools/releases/download/v1.0/netrecon-aarch64-apple-darwin"
      sha256 "907f2d084ce5e34b94c086cad9ef74049ebd4b95145b0c54acabbf273f3f30d4"
    else
      url "https://github.com/BartoszOsiej/cybersec-tools/releases/download/v1.0/netrecon-x86_64-apple-darwin"
      sha256 "2ca98729ee78ff5a9362671fa10949796582f02cc9373aaa37ca8ca2f27115f4"
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
