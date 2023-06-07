#workspace directory and properties
resource "aws_workspaces_directory" "os_workspace" {
  directory_id = aws_directory_service_directory.os-cloud-ad.id
  subnet_ids = [aws_subnet.pub_b.id, aws_subnet.pub_a.id]

  tags = {
    Example = true
  }

  self_service_permissions {
    change_compute_type  = true
    increase_volume_size = true
    rebuild_workspace    = true
    restart_workspace    = true
    switch_running_mode  = true
  }

  workspace_access_properties {
    device_type_android    = "ALLOW"
    device_type_chromeos   = "ALLOW"
    device_type_ios        = "DENY"
    device_type_linux      = "ALLOW"
    device_type_osx        = "ALLOW"
    device_type_web        = "ALLOW"
    device_type_windows    = "ALLOW"
    device_type_zeroclient = "DENY"
  }

  workspace_creation_properties {
    #custom_security_group_id            = aws_security_group.example.id
    #default_ou                          = "OU=AWS,DC=Workgroup,DC=Example,DC=com"
    enable_internet_access              = true
    enable_maintenance_mode             = true
    user_enabled_as_local_administrator = true
  }

  depends_on = [
    aws_iam_role.workspaces-temporary
    #aws_iam_role_policy_attachment.workspaces_default_service_access,
    #aws_iam_role_policy_attachment.workspaces_default_self_service_access
  ]
}

resource "aws_subnet" "pub_a" {
  vpc_id            = module.vpc.vpc_id
  availability_zone = "us-east-1a"
  cidr_block        = "192.168.1.0/28"
}

resource "aws_subnet" "pub_b" {
  vpc_id            = module.vpc.vpc_id
  availability_zone = "us-east-1b"
  cidr_block        = "192.168.1.16/28"
}

# KMS Key to encrypt WorkSpaces Disk Volumes. optional

resource "aws_kms_key" "workspaces-kms" {
  description = "osmanworkspace  KMS"
  deletion_window_in_days = 15

}

# workspace linux bundle images

# data "aws_workspaces_bundle" "image_linux" {
#   bundle_id = "wsb-8w32qplfk" # Description": "Ubuntu 22.04 GNOME Desktop Environment with WorkSpaces Streaming Protocol 8 vCPU 32GiB Memory 100GB Storage (English)
# }


# resource "aws_workspaces_workspace" "workspaces_1" {
#   directory_id = aws_directory_service_directory.os-cloud-ad.id
#   bundle_id    = data.aws_workspaces_bundle.image_linux.id
#   user_name    = "Admin"

#   root_volume_encryption_enabled = true
#   user_volume_encryption_enabled = true
#   volume_encryption_key          = "alias/aws/workspaces"

#   workspace_properties {
#     compute_type_name                         = "POWERPRO"
#     user_volume_size_gib                      = 100
#     root_volume_size_gib                      = 175
#     running_mode                              = "AUTO_STOP"
#     running_mode_auto_stop_timeout_in_minutes = 60
#   }

#   tags = {
#     Department = "IT"
#   }
# depends_on = [
#     aws_iam_role.workspaces-temporary,
#     aws_workspaces_directory.os_workspace
#   ]
# }

# Windows workspace image

data "aws_workspaces_bundle" "image_windows" {
  bundle_id = "wsb-8vbljg4r6" # "Description": Standard with Windows 10 (Server 2019 based) (PCoIP)
}


resource "aws_workspaces_workspace" "workspaces_2" {
  directory_id = aws_directory_service_directory.os-cloud-ad.id
  bundle_id    = data.aws_workspaces_bundle.image_windows.id
  user_name    = "Administrator"
    
  

  root_volume_encryption_enabled = true
  user_volume_encryption_enabled = true
  volume_encryption_key          = "alias/aws/workspaces"

  workspace_properties {
    compute_type_name                         = "STANDARD"
    user_volume_size_gib                      = 50
    root_volume_size_gib                      = 80
    running_mode                              = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
  }
  timeouts {
    create = "60m"
  }

  tags = {
    Department = "IT"
  }

  
depends_on = [
    aws_iam_role.workspaces-temporary,
    aws_workspaces_directory.os_workspace
  ]
}

