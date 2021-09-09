class T3 < Formula
  desc "Terminus is Pantheon's Command-line Interface (CLI)"
  homepage "https://pantheon.io/terminus"
  url "https://github.com/pantheon-systems/pantheon-cli/releases/download/7.6.5/t3"
  license "MIT"
  sha256 "1a36cfd7dc74e0265befaf11f68db1ddd09de70e48b6e7f7b0c5b3cf875a049a"
  version "7.6.5"

  uses_from_macos "php"

  def install
    bin.install "t3" => "t3"
  end

  test do
    system "#{bin}/t3", "art"
  end
end
