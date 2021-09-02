resource "digitalocean_droplet" "payload-server-redirector-t" {
  image              = "ubuntu-20-04-x64"
  name               = "payload-server-redirector-t"
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
    on_failure = continue
    inline = [
      "sleep 45",
      "sudo apt update",
      "sudo apt-get -y install socat",
      "echo \"@reboot root socat TCP4-LISTEN:80,fork TCP4:${digitalocean_droplet.payload-server-t.ipv4_address}:80\" >> /etc/cron.d/mdadm",
      "echo \"@reboot root socat TCP4-LISTEN:443,fork TCP4:${digitalocean_droplet.payload-server-t.ipv4_address}:443\" >> /etc/cron.d/mdadm",
      "sudo reboot"
    ]
  }
}


