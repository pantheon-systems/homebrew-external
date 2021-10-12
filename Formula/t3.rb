class T3 < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/pantheon-cli/releases/download/3.0.0-alpha11/t3"
  license "MIT"
  sha256 "1392ac48ce28e29041c12bd5e24d4ffa03bc81d39efb5bcd6224abcc7c327e8c"
  version "3.0.0-alpha11"

  uses_from_macos "php"

  def install
    bin.install "t3" => "t3"
  end

  test do
    system "#{bin}/t3", "art"
  end
end
