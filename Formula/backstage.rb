require 'formula'

class Backstage < Formula
  homepage 'https://github.com/backstage'
  url 'https://github.com/backstage/backstage-client/releases/download/0.0.7/backstage-client-0.0.7'
  sha256 'b0f5106316e2e89f54eb6514ea85be5180bdff6b93c1d446f28b895931c7c2b0'

  depends_on 'go'

  def install
    mkdir_p "src/github.com/backstage/backstage-client"
    system "bash", "-c", "GOPATH=\"$PWD\" go build -o backstage github.com/backstage/backstage-client/backstage"
    bin.install "backstage"
  end
end
