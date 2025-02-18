class Terminus < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/terminus/releases/download/3.6.1/terminus.phar"
  sha256 "9cefcb8d5f0953334173d837cef943a8b88afec17fae4327c15271bfc9c3dc50"
  license "MIT"

  depends_on "composer" => :optional
  depends_on "php@8.3"

  def install
    libexec.install "terminus.phar"

    (bin/"terminus").write <<~PHP
      #!#{Formula["php@8.3"].opt_bin}/php
      <?php require '#{libexec}/terminus.phar';
    PHP
  end

  test do
    system "#{bin}/terminus", "art"
  end
end
