class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/3.0.0-alpha9/terminus"
  license "MIT"
  sha256 "0a8d7031231a22f2e57c77d21b114a562b292fdb2d502ae2fc60ea3e45e66a8a"
  version "3.0.0-alpha9"

  uses_from_macos "php"

  def install
    bin.install "terminus" => "terminus"
  end

  test do
    system "#{bin}/terminus", "art"
  end
end
