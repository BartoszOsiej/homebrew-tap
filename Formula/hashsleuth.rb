class Hashsleuth < Formula
  desc "Multi-threaded hash identification & cracking toolkit (Rust)"
  homepage "https://github.com/BartoszOsiej/cybersec-tools"
  version "0.4.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BartoszOsiej/cybersec-tools/releases/download/v0.4.5/hashsleuth-aarch64-apple-darwin"
      sha256 "f6784cc1e6219eaabc00219130dc9e4656aafd770d62d11c32dd0b5706147ff3"
    else
      url "https://github.com/BartoszOsiej/cybersec-tools/releases/download/v0.4.5/hashsleuth-x86_64-apple-darwin"
      sha256 "6fc825ca5a62ab6f9dd1a5f4bca8f2c2ca9c581d734458043f5acccafacb2312"
    end
  end

  def install
    if Hardware::CPU.arm?
      binary "hashsleuth-aarch64-apple-darwin"
    else
      binary "hashsleuth-x86_64-apple-darwin"
    end
  end

  test do
    system "#{bin}/hashsleuth", "--help"
  end
end
