class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/4.0.0-alpha1/terminus.phar"
  version "4.0.0-alpha1"
  sha256 "3d0f26aee4f091b0282e151f15f2ddde6dedb2566a5c6e58f8ddcdeb37d195ab"
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
