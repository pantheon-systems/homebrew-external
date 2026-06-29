class Terminus < Formula
  desc "Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/4.3.2/terminus.phar"
  sha256 "1eb7be556adba66bfb87d197211bf62671031e7294024c5a35dd8348b84f7aab"
  license "MIT"

  depends_on "composer"

  depends_on "php"

  def install
    bin.install "terminus.phar" => "terminus"
  end

  test do
    system bin/"terminus", "art"
  end
end
