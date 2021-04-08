class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      tag:      "v1.7.2",
      revision: "1f834e229aa722ea1279ec32503a2ea011f24e03"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee541b7827d7991fbac6da2e37ecd063051b8b10011734a7e2bcdc1e2d51ed73"
    sha256 cellar: :any_skip_relocation, big_sur:  "2dd688672157eed5d9f5126b1dd160862926ab698dc91e4ffb5a7fc2deb0b037"
    sha256 cellar: :any_skip_relocation, catalina: "2dd688672157eed5d9f5126b1dd160862926ab698dc91e4ffb5a7fc2deb0b037"
    sha256 cellar: :any_skip_relocation, mojave:   "2dd688672157eed5d9f5126b1dd160862926ab698dc91e4ffb5a7fc2deb0b037"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    zsh_completion.install "contrib/zsh-completion/_packer"
    prefix.install_metafiles
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<~EOS
      {
        "builders": [{
          "type": "amazon-ebs",
          "region": "us-east-1",
          "source_ami": "ami-59a4a230",
          "instance_type": "m3.medium",
          "ssh_username": "ubuntu",
          "ami_name": "homebrew packer test  {{timestamp}}"
        }],
        "provisioners": [{
          "type": "shell",
          "inline": [
            "sleep 30",
            "sudo apt-get update"
          ]
        }]
      }
    EOS
    system "#{bin}/packer", "validate", "-syntax-only", minimal
  end
end
