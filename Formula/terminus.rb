class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/3.0.9/terminus.phar"
  version "3.0.9"
  sha256 "ac4e1d55f48b95beca2e536d875f5aa935d8de6b79fa5e8861a5103860e19a9b"
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
