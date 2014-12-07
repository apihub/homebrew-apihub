require 'formula'

class Backstage < Formula
  homepage 'https://github.com/backstage'
  url 'https://github.com/backstage/backstage-client/archive/0.0.1.tar.gz'
  sha1 'd16f7d228b4ddf5ddd1bd976543b754b9766f5bc'

  depends_on 'go'

  def install
    system "bash", "-c", "GOPATH=\"$PWD\" go build -o backstage github.com/backstage/backstage-client/backstage"
    bin.install "backstage"
  end
end
