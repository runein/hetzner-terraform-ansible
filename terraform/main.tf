resource "hcloud_ssh_key" "lab" {
  name       = "terraform-lab"
  public_key = file(pathexpand("~/.ssh/hetzner_lab.pub"))
}
resource "hcloud_server" "node" {
  count       = 3
  name        = "lab-node-${count.index + 1}"
  image       = "ubuntu-24.04"
  server_type = "cpx12"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.lab.id]
}
resource "local_file" "inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content = templatefile("${path.module}/inventory.tmpl", {
    ips = hcloud_server.node[*].ipv4_address
  })
}