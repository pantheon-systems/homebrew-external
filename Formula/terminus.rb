class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/4.1.9/terminus.phar"
  sha256 "8573fbe281e4a6ad50bedbdbd1a77c7b2683217b06abc24d00ac7e25cec0ba57"
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
