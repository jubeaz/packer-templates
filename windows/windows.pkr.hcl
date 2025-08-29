packer {
  required_version = ">= 1.12.0"
  required_plugins {
    virtualbox = {
      version = "~> 1.1.1"
      source  = "github.com/hashicorp/virtualbox"
    }
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    windows-update = {
      version = "0.17.0"
      source  = "github.com/rgl/windows-update"
    }
    vagrant = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

build {
  sources = ["source.qemu.windows-2022-bios"]
  provisioner "windows-shell" {
    execute_command = "{{ .Vars }} cmd /c C:/Windows/Temp/script.bat"
    remote_path     = "c:/Windows/Temp/script.bat"
    scripts         = ["./scripts/70-install-misc.bat", "./scripts/80-compile-dotnet-assemblies.bat"]
  }

  # Reboot after doing our first stages
  # This is to give the windows-update provisioner a chance
  # As it will seemingly hang on TiWorker.exe siting around idling
  # (This is due to registry changes in the first stage seemignly not having
  # efect until a reboot has happened)
  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
  }

#  provisioner "windows-update" {
#  }
#
#  # Without this step, your images will be ~12-15GB
#  # With this step, roughly ~8-9GB
#  provisioner "windows-shell" {
#    execute_command = "{{ .Vars }} cmd /c C:/Windows/Temp/script.bat"
#    remote_path     = "c:/Windows/Temp/script.bat"
#    scripts         = ["./scripts/90-compact.bat"]
#  }
  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = false
      compression_level   = 9
#      provider_override   = "virtualbox"
      output = "boxes/${var.vm_name}.box"
    }
  }
}