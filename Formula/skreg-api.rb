class SkregApi < Formula
  desc "The api which supports Skreg skills and package management"
  homepage "https://skreg.ai"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.2/skreg-api-aarch64-apple-darwin.tar.xz"
      sha256 "a05c7d168f8431d32211969ae82e40e5af2496042b9eee53742617cbbae08ab2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.2/skreg-api-x86_64-apple-darwin.tar.xz"
      sha256 "942fd6045345f955d9cba74b68f05ab001ed3e2df7baca5b08e990285b146fa3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.2/skreg-api-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3be7eff16cf0d5ef35149747fcd63e9e8a15d08fe96386cb19292b2313b94a44"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.2/skreg-api-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "15c27f5a5f15c2178df0258095cbbc8ceff9b6a8e0490fcb9f827f471cb06c34"
    end
  end
  license "Apache 2.0"

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
    bin.install "skreg-api" if OS.mac? && Hardware::CPU.arm?
    bin.install "skreg-api" if OS.mac? && Hardware::CPU.intel?
    bin.install "skreg-api" if OS.linux? && Hardware::CPU.arm?
    bin.install "skreg-api" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
