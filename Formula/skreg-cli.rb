class SkregCli < Formula
  desc "A command line tool for manging AI skills which are verified and trusted"
  homepage "https://skreg.ai"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.3.0/skreg-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c259f8f7192a2a1c73c003be8c355d41093fa6cfd5e77f19c08add03af90ea45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.3.0/skreg-cli-x86_64-apple-darwin.tar.xz"
      sha256 "27a25880ce7f73c85b628b94a18448a2cf150bf5e83189159dad4b0f0c4a14d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.3.0/skreg-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "62905ff0106a83e76ff4b7e32d8011813b1fd34f4f63e1c276afeb0cc713b5ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.3.0/skreg-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "46af4b763b84d692f4092569ed9d7b0e6f7bf99ded6b66cdc22c9d605e37eb2e"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "skreg" if OS.mac? && Hardware::CPU.arm?
    bin.install "skreg" if OS.mac? && Hardware::CPU.intel?
    bin.install "skreg" if OS.linux? && Hardware::CPU.arm?
    bin.install "skreg" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
