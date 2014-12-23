require 'formula'

class Backstage < Formula
  homepage 'https://github.com/backstage'
  url 'https://github.com/backstage/backstage-client/releases/download/0.0.6/backstage-client-0.0.6'
  sha256 '73286d92fd069d0592fefb283fa916460200bfa700c4db501aab2329bfbc4d72'

  depends_on 'go'

  def install
    mkdir_p "src/github.com/backstage/backstage-client"
    system "bash", "-c", "GOPATH=\"$PWD\" go build -o backstage github.com/backstage/backstage-client/backstage"
    bin.install "backstage"
  end
end
