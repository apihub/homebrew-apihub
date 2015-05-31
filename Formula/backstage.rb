require 'formula'

class Backstage < Formula
  homepage 'https://github.com/backstage'
  url 'https://github.com/backstage/backstage-client/releases/download/0.0.9/backstage-client-0.0.9'
  sha256 '10f03d1fa058bbe5d388d6a91bf148d4707664b49e5fd2caa22c1d59e37718cf'

  depends_on 'go'

  def install
    mkdir_p "src/github.com/backstage/backstage-client"
    system "bash", "-c", "GOPATH=\"$PWD\" go build -o backstage github.com/backstage/backstage-client/backstage"
    bin.install "backstage"
    bash_completion.install "src/github.com/backstage/backstage-client/commands/autocomplete/bash_autocomplete" => "backstage"
    zsh_completion.install "src/github.com/backstage/backstage-client/commands/autocomplete/zsh_autocomplete" => "backstage"
  end
end
