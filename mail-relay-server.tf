resource "digitalocean_droplet" "mail-relay-server" {
  image              = "ubuntu-20-04-x64"
  name               = "mail.${var.mail-relay-server-domain}"
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

  provisioner "file" {
    content     = templatefile("./scripts/dkim_recorder.py", { do-token = var.do-token, domain-name = var.mail-relay-server-domain })
    destination = "/root/dkim_recorder.py"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 45",
      "sudo apt update",
      "cd /root/",
      "wget ${var.ired-download-link}",
      "tar zxf *.tar.gz",
      "cd iRedMail*",
      "tee ./config <<EOF",
      "${local.iredmail-config}",
      "EOF",
      "AUTO_USE_EXISTING_CONFIG_FILE=y AUTO_INSTALL_WITHOUT_CONFIRM=y AUTO_CLEANUP_REMOVE_SENDMAIL=y AUTO_CLEANUP_REPLACE_FIREWALL_RULES=y AUTO_CLEANUP_RESTART_FIREWALL=y AUTO_CLEANUP_REPLACE_MYSQL_CONFIG=y bash iRedMail.sh",
      "mv iRedMail.tips /root/",
      "cd /root/",
      "pip install requests",
      "python3 dkim_recorder.py -t ${var.do-token} -d ${var.mail-relay-server-domain}",
      "tee /etc/postfix/header_checks <<EOF",
      "${local.header-checks}",
      "EOF",
      "postmap /etc/postfix/header_checks",

    ]
  }

  provisioner "file" {
    source      = "./data/master.cf"
    destination = "/etc/postfix/master.cf"
  }

  provisioner "remote-exec" {
    on_failure = continue
    inline = [
      "postfix reload",
      "sudo reboot"
    ]
  }

}
