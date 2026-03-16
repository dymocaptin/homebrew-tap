class SkregCli < Formula
  desc "A command line tool for manging AI skills which are verified and trusted"
  homepage "https://skreg.ai"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.4/skreg-cli-aarch64-apple-darwin.tar.xz"
      sha256 "253d97ae389c623f8dff39aa0f19f9bf5167a6907543e19730fab6b052a88a30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.4/skreg-cli-x86_64-apple-darwin.tar.xz"
      sha256 "65c94cb8d5fb368fcba6e8fbf7f024788a14c1cbc579aa55c7d1f3f91d6158e7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.4/skreg-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c8f5568f6daa01c686a5cac2c410ac95e0ddfd704ee3d59e372afa6423216e9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.4/skreg-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "68cd1c41eaf3aa2ce335345a3dd2a6d0b515e3229ca6cf5d0c34b3a39bbe8e2c"
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
