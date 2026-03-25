class SkregCli < Formula
  desc "A command line tool for manging AI skills which are verified and trusted"
  homepage "https://skreg.ai"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.3.2/skreg-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d82774ab8d025960c1c35682ae81ae5d3558ee91f81933265838d710b2df164d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.3.2/skreg-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d4e6a87dcab1a234953e73dafbf5dfd89e9b99417e79abe434cfc0f22f546840"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.3.2/skreg-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "23ab1891895c35936a8873379f637cfa4330c9b75d94bb7a92ba6ea9b4436917"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.3.2/skreg-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6e28e00266ac07400ff21ffa9aa82629d46af97541bdcd313e80e5faeb52d672"
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
