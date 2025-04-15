class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/4.0.0-alpha2/terminus.phar"
  version "4.0.0-alpha2"
  sha256 "2dc2e515a93fe929ef3b6847522a79329be6382d060ec602aab25b84c9c65741"
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
