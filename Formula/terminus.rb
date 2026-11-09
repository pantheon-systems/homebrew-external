class Terminus < Formula
  desc "Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/4.3.5/terminus.phar"
  sha256 "b5653c9e08329ab087d4b772a98e7a733e9a5b28f9101096d860e25fba91c8d2"
  license "MIT"

  depends_on "composer"

  depends_on "php"

  def install
    bin.install "terminus.phar" => "terminus"
  end

  test do
    system bin/"terminus", "art"
  end
end
