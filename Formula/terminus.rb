class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/4.2.1-rc.1/terminus.phar"
  version "4.2.1-rc.1"
  sha256 "a49484dc03ce843a122fbac858c94d89ea443b8c5c8f08f205dffa62bf54239f"
  license "MIT"

  depends_on "composer"

  depends_on "php"

  def install
    bin.install "terminus.phar" => "terminus"
  end

  test do
    system "#{bin}/terminus", "art"
  end
end
