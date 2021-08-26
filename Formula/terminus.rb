class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/2.6.1/terminus.phar"
  license "MIT"
  sha256 "97254f4aa4fb8fc8a900a2e22ab449d95d8ca7387c3916e041a1ea946a49d34b"
  version "2.6.1"

  uses_from_macos "php"

  def install
    bin.install "terminus.phar" => "terminus"
  end

  test do
    system "#{bin}/terminus", "art"
  end
end
