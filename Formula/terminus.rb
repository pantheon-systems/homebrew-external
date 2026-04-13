class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/4.2.0/terminus.phar"
  sha256 "05feb98d0c78abbd33857e53f4e33a7551b2f55bcbe8cc5613f8bfdb71e3a0ff"
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
