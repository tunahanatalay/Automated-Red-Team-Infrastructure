resource "digitalocean_droplet" "mail-server" {
  image              = "ubuntu-20-04-x64"
  name               = "mail-server-t"
  region             = "fra1"
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys           = [var.ssh-key-fingerprint]
  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.ssh-private-key)
    timeout     = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 45",
      "sudo apt update",
      "sudo apt -y install ssmtp",
      "sudo tee /etc/ssmtp/ssmtp.conf <<EOF",
      "${local.ssmtp-config}",
      "EOF",
      "sudo echo ${local.mail-alias} >> /etc/ssmtp/revaliases",
      "chfn -f 'Tunahan Atalay' root",
      "mkdir /opt/gophish/ && cd /opt/gophish/",
      "wget ${var.gophish-download-link}",
      "sudo apt -y install zip",
      "unzip *.zip",
      "chmod +x gophish"
    ]
  }

  provisioner "file" {
    source      = "./data/config.json"
    destination = "/opt/gophish/config.json"
  }

}
