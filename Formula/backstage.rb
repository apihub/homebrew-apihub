require 'formula'

class Backstage < Formula
  homepage 'https://github.com/backstage'
  url 'https://github.com/backstage/backstage-client/releases/download/0.0.8/backstage-client-0.0.8'
  sha256 '3b0415c232ecfc1ae467cff043a895e05af6967002490aca8ac758e6f5fc6c29'

  depends_on 'go'

  def install
    mkdir_p "src/github.com/backstage/backstage-client"
    system "bash", "-c", "GOPATH=\"$PWD\" go build -o backstage github.com/backstage/backstage-client/backstage"
    bin.install "backstage"
  end
end
