resource "digitalocean_droplet" "c2-server-t" {
  image              = "ubuntu-20-04-x64"
  name               = "c2-server-t"
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
      "curl -sSL https://raw.githubusercontent.com/nettitude/PoshC2/master/Install.sh | sudo bash",
      "posh-project -n ${var.poshc2-project-name}",
      "tee /var/poshc2/${var.poshc2-project-name}/config.yml <<EOF",
      "${local.poshc2-config}",
      "EOF",
      "nohup sudo posh-server &",
      "sleep 60",
      "cd /var/poshc2/${var.poshc2-project-name}/payloads/",
      "nohup python3 -m http.server 5555 &",
      "sleep 1"
    ]
  }
}


