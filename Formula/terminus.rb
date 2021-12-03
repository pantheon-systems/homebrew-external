class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/3.0.0-rc1/terminus"
  version "3.0.0-rc1"
  sha256 "2740630b9279a88916fce23ad013748f10ccefc075b63a6c2919707601473873"
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
