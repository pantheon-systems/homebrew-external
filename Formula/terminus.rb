class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/3.1.0/terminus.phar"
  version "3.1.0"
  sha256 "83b4ef92b4ff5b835c91b10b223802fcd4bccbe87297bc9fcf3f883bcd7d4bf8"
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
