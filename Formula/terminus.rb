class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/3.0.0-beta1/terminus"
  version "3.0.0-beta1"
  sha256 "e723a599e6c819381c3c50fe4917e243f134fd00a5b7b269ad9b79d8200761f9"
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
