class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/4.2.1/terminus.phar"
  sha256 "5817dd9bc3d6806635982b760d88a0e5f8156373b118d84a2ba4cccb6f13f8a4"
  license "MIT"

  depends_on "composer"

  depends_on "php"

  def install
    bin.install "terminus.phar" => "terminus"
  end

  test do
    system "#{bin}/terminus", "art"
  end
end
