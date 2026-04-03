class SkregCli < Formula
  desc "A command line tool for manging AI skills which are verified and trusted"
  homepage "https://skreg.ai"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.4.0/skreg-cli-aarch64-apple-darwin.tar.xz"
      sha256 "47c1181db6cd79d3e4b3d1cee28e148b3be59bb0912cd3ca10d302aa885821da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.4.0/skreg-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b47d026df7a721c497ee53f360f31d9a2c25e8d6956161f01bef26bdca7ce537"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.4.0/skreg-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bcedc63545ff394fe4781435676c9c4b9c26708b709beacac52b6a95b0e713c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.4.0/skreg-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1178a16984e31ac3a7c9cba6d3aa839cdf511009d52fc4c19ef60a317c87ae24"
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
