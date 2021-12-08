class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/3.0.1/terminus.phar"
  version "3.0.0"
  sha256 "b3a444bcb5870cb9352f7708aa4e4212b4113ec6662b13cd123a6b0f2f958f40"
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
