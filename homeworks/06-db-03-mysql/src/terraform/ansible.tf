resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 100"
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "docker" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory ../ansible/docker-deploy.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}

resource "null_resource" "mysql" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory ../ansible/sync-deploy.yml"
  }

  depends_on = [
    null_resource.docker
  ]
}

resource "null_resource" "start" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory ../ansible/start-docker.yml"
  }

  depends_on = [
    null_resource.mysql
  ]
}