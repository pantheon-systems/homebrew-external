class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/4.3.0/terminus.phar"
  sha256 "2c6520fb049beb5f7fa2b046b4f9ffa24dd151fad4f0f01b0826c6ca35476949"
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
