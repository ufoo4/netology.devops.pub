resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 100"
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "k8s-deploy" {
  provisioner "local-exec" {
    command = "ansible-playbook -u centos -b -i ../kubespray/inventory/mycluster/inventory.ini ../kubespray/cluster.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}
