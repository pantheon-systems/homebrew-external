class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/3.0.0/terminus"
  version "3.0.0"
  sha256 "4e7eacf633acce1e4503743b668b29993cebba11895369c897d5be21e839f43a"
  license "MIT"

  depends_on "composer" => :optional

  uses_from_macos "php"

  def install
    bin.install "terminus" => "terminus"
  end

  test do
    system "#{bin}/terminus", "art"
  end
end
