class Terminus < Formula
  desc "Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/4.3.4/terminus.phar"
  sha256 "5dc7e4b231c731b4d241772d38a94296785827a0d144582b9c3da6b0aaac2388"
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
