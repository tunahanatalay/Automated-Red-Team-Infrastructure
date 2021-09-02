variable "do-token" {
  //Change This
  default = "XXX"
}

variable "ssh-public-key" {
  //Generate ssh key
  default = "XXX"
}

variable "ssh-private-key" {
  //Generate ssh key
  default = "XXX"
}

variable "ssh-key-fingerprint" {
  //Generate ssh key
  default = "XXX"
}

variable "poshc2-project-name" {
  default = "project-zero"
}

variable "mail-relay-server-domain" {
  //Change This
  default = "XXX"
}

variable "ired-download-link" {
  default = "https://github.com/iredmail/iRedMail/archive/1.4.0.tar.gz"
}

variable "gophish-download-link" {
  default = "https://github.com/gophish/gophish/releases/download/v0.11.0/gophish-v0.11.0-linux-64bit.zip"
}

variable "operator-mail-password" {
  //Change This
  default = "XXX"
}


locals {
  poshc2-config   = templatefile("./data/config.yml", { commshost = digitalocean_droplet.c2-server-redirector-t.ipv4_address })
  iredmail-config = templatefile("./data/config", { mail-password = var.operator-mail-password })
  ssmtp-config    = templatefile("./data/ssmtp.conf", { mail-host = var.mail-relay-server-domain, operator-mail = local.operator-mail, mail-password = var.operator-mail-password })
  mail-alias      = "root:${local.operator-mail}:mail.${var.mail-relay-server-domain}:587"
  operator-mail   = "postmaster@${var.mail-relay-server-domain}"
  header-checks   = templatefile("./data/header_checks", {})
}
