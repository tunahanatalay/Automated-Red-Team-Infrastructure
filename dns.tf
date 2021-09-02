resource "digitalocean_record" "mail-server-a0" {
  domain = var.mail-relay-server-domain
  name   = "@"
  value  = digitalocean_droplet.mail-relay-server.ipv4_address
  type   = "A"
  ttl    = 1800
}

# mail relay A
resource "digitalocean_record" "mail-server-a1" {
  domain = var.mail-relay-server-domain
  name   = "mail"
  value  = digitalocean_droplet.mail-relay-server.ipv4_address
  type   = "A"
  ttl    = 1800
}

# mail relay MX
resource "digitalocean_record" "mail-server-mx" {
  domain   = var.mail-relay-server-domain
  name     = "@"
  value    = "mail.${var.mail-relay-server-domain}."
  type     = "MX"
  priority = 10
  ttl      = 1800
}

# mail relay TXT SPF
resource "digitalocean_record" "mail-server-spf0" {
  domain = var.mail-relay-server-domain
  name   = "@"
  value  = "v=spf1 a ~all"
  type   = "TXT"
  ttl    = 1800
}

# mail relay TXT SPF
resource "digitalocean_record" "mail-server-spf1" {
  domain = var.mail-relay-server-domain
  name   = "mail"
  value  = "v=spf1 a ~all"
  type   = "TXT"
  ttl    = 1800
}

# mail relay TXT DKIM placeholder
/*
resource "digitalocean_record" "mail-server-dkim" {
    domain = var.mail-relay-server-domain
    name   = "dkim._domainkey"
    value  = "Change this..."
    type   = "TXT"
    ttl    = 3600
}
*/

# mail relay TXT DMARC
resource "digitalocean_record" "mail-server-dmarc" {
  domain = var.mail-relay-server-domain
  name   = "_dmarc"
  value  = "v=DMARC1; p=reject; rua=mailto:dmarc@${var.mail-relay-server-domain}; ruf=mailto:dmarc@${var.mail-relay-server-domain}"
  type   = "TXT"
  ttl    = 1800
}
