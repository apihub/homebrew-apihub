require 'formula'

class ApiHub < Formula
  homepage 'https://github.com/apihub'
  url 'https://github.com/apihub/apihub-cli/releases/download/0.0.9/apihub-cli-0.0.9'
  sha256 '10f03d1fa058bbe5d388d6a91bf148d4707664b49e5fd2caa22c1d59e37718cf'

  depends_on 'go'

  def install
    mkdir_p "src/github.com/apihub/apihub-cli"
    system "bash", "-c", "GOPATH=\"$PWD\" go build -o apihub github.com/apihub/apihub-cli/apihub"
    bin.install "apihub"
    bash_completion.install "src/github.com/apihub/apihub-cli/commands/autocomplete/bash_autocomplete" => "apihub"
    zsh_completion.install "src/github.com/apihub/apihub-cli/commands/autocomplete/zsh_autocomplete" => "apihub"
  end
end
