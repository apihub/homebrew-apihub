require 'formula'

class Apihub < Formula
  homepage 'https://github.com/apihub'
  url 'https://github.com/apihub/apihub-cli/releases/download/0.0.11/apihub-cli-0.0.11'
  sha256 '8cc513984a6c49e773b0b7d1a6167061da00a8c2c21524ddd6a5d680b19471b8'

  depends_on 'go'

  def install
    mkdir_p "src/github.com/apihub/apihub-cli"
    system "bash", "-c", "GOPATH=\"$PWD\" go build -o apihub github.com/apihub/apihub-cli"
    bin.install "apihub"
  end
end
