class SkregWorker < Formula
  desc "The background vetting and signing pipeline for Skreg"
  homepage "https://skreg.ai"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.2/skreg-worker-aarch64-apple-darwin.tar.xz"
      sha256 "dc75972c4e989e2705c050fceafde521a1f4a6b1011fa7ebabf9faa36c824484"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.2/skreg-worker-x86_64-apple-darwin.tar.xz"
      sha256 "f70c30b731329e803df0dff54e9d45024f634580805413632d20a480673559bb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.2/skreg-worker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "02d6227639a3bc115e942a3de681a597e5c2ffbc16e9b50ae5ea0921095c3fe8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dymocaptin/skreg/releases/download/v0.1.2/skreg-worker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6521a036540a7be700b08f358fef08ae0f2cbf44de981cd73bd76773b727f163"
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
    bin.install "skreg-worker" if OS.mac? && Hardware::CPU.arm?
    bin.install "skreg-worker" if OS.mac? && Hardware::CPU.intel?
    bin.install "skreg-worker" if OS.linux? && Hardware::CPU.arm?
    bin.install "skreg-worker" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
