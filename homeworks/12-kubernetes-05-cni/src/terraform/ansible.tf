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

resource "null_resource" "preinstall" {
  provisioner "local-exec" {
    command = "ansible-playbook -u centos -b -i ../kubespray/inventory/mycluster/inventory.ini ../app/preinstall.yml"
  } 

  depends_on = [
    null_resource.k8s-deploy
  ]
}

resource "null_resource" "app-deploy" {
  provisioner "local-exec" {
    command = "ansible-playbook -u centos -i ../kubespray/inventory/mycluster/inventory.ini ../app/app-deploy.yml"
  } 

  depends_on = [
    null_resource.preinstall
  ]
}