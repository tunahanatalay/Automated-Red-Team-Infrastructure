/*
resource "digitalocean_firewall" "payload_grab" {
  droplet_ids = [digitalocean_droplet.c2-server-t.id]
  name        = "payload-dropper-rules"
  inbound_rule {
    protocol         = "tcp"
    port_range       = "5555"
    source_addresses = [digitalocean_droplet.payload-server-t.ipv4_address]
  }
}
*/
