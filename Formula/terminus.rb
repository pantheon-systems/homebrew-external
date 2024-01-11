class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/3.3.2/terminus.phar"
  sha256 "383359ff74675fcd22b058e4ad5861b03970357913e1624a97fb3885ee365812"
  license "MIT"

  depends_on "composer" => :optional

  uses_from_macos "php"

  def install
    bin.install "terminus.phar" => "terminus"
  end

  test do
    system "#{bin}/terminus", "art"
  end
end
