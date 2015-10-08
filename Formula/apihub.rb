require 'formula'

class Apihub < Formula
  homepage 'https://github.com/apihub'
  url 'https://github.com/apihub/apihub-cli/releases/download/0.0.10/apihub-cli-0.0.10'
  sha256 '65dd489b084b8f64681f192c01e8dc1e6ae6cd83d7654be582a0b3b85738bb52'

  depends_on 'go'

  def install
    mkdir_p "src/github.com/apihub/apihub-cli"
    system "bash", "-c", "GOPATH=\"$PWD\" go build -o apihub github.com/apihub/apihub-cli/apihub"
    bin.install "apihub"
  end
end