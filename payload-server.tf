resource "digitalocean_droplet" "payload-server-t" {
  image              = "ubuntu-20-04-x64"
  name               = "payload-server-t"
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
      "sudo apt -y install apache2",
      "rm -r /var/www/html/*"
    ]
  }
}

resource "null_resource" "payload-provisioner" {
  depends_on = [
    digitalocean_droplet.c2-server-t
  ]

  connection {
    host        = digitalocean_droplet.payload-server-t.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.ssh-private-key)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 45",
      "cd /var/www/html/",
      "wget -r http://${digitalocean_droplet.c2-server-t.ipv4_address}:5555/",
      "cd *5555*",
      "mv ./* ../",
      "cd ../",
      "rm -rf *5555*"
    ]
  }

}


