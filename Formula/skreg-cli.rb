class SkregCli < Formula
  desc "A command line tool for manging AI skills which are verified and trusted"
  homepage "https://skreg.ai"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.2.0/skreg-cli-aarch64-apple-darwin.tar.xz"
      sha256 "be0f10a0185442d0ee633b3e3f3c8173e63d61c8024e7a5b1fa544fdc2112784"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.2.0/skreg-cli-x86_64-apple-darwin.tar.xz"
      sha256 "34137744f9a8413b9320ec95a0c51cdfe8a8ac283dbdab6dded46f7d6ff9a3f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.2.0/skreg-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8c1bb271a93f707b2a47a900561c1e3899072e998371aca1934079669e33a834"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.2.0/skreg-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "98801794a49e4e5b169cb1dd2278aef31c6369c3c11d9dde3186f62855421a53"
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
