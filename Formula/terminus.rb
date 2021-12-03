class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/3.0.0-rc1/terminus"
  version "3.0.0-rc1"
  sha256 "704f22e1ee4c7bb327fc13b79a9568244807662d269e2228472c8f52281496d9"
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
