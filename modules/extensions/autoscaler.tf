# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  cluster_autoscaler_yaml_template = templatefile("${path.module}/resources/clusterautoscaler.template.yaml",
    {
      autoscaling_nodepools = var.autoscaling_nodepools
    }
  )
}

resource "null_resource" "deploy_cluster_autoscaler" {
  connection {
    host        = var.operator_private_ip
    private_key = local.ssh_private_key
    timeout     = "40m"
    type        = "ssh"
    user        = "opc"

    bastion_host        = var.bastion_public_ip
    bastion_user        = "opc"
    bastion_private_key = local.ssh_private_key
  }

  provisioner "file" {
    content     = local.cluster_autoscaler_yaml_template
    destination = "/home/opc/cluster-autoscaler.yaml"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "rm -f \"$HOME/cluster-autoscaler.yaml\"",
  #     "if [ -f \"$HOME/cluster-autoscaler.yaml\" ]; then kubectl apply -f \"$HOME/cluster-autoscaler.yaml\"; rm -f \"$HOME/cluster-autoscaler.yaml\";fi",
  #   ]
  # }

  count = local.post_provisioning_ops == true && var.enable_cluster_autoscaler == true ? 1 : 0
}