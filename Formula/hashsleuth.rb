class Hashsleuth < Formula
  desc "Multi-threaded hash identification & cracking toolkit (Rust)"
  homepage "https://github.com/BartoszOsiej/cybersec-tools"
  version "1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BartoszOsiej/cybersec-tools/releases/download/v1.0/hashsleuth-aarch64-apple-darwin"
      sha256 "92a2f30dabd5bed3aa68412d9cb30368b984b474765ab23049c69474b5ddc11d"
    else
      url "https://github.com/BartoszOsiej/cybersec-tools/releases/download/v1.0/hashsleuth-x86_64-apple-darwin"
      sha256 "cc1f0949acb6b93b2dfc0fcb4b8d900aa294b8d06da842c52d1a5e58a6433bd7"
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
