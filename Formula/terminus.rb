class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/4.2.0-rc.1/terminus.phar"
  version "4.2.0-rc.1"
  sha256 "31520db232116df0dd58be05eb24e2003d783d2d9179a7a4bc007bfe5db85588"
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
