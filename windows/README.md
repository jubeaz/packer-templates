
* Fully up to date (see windows-update provisioner)
* Access mechanisms:
  * winrm, rdp, and ssh enabled by default
  * username / password is "vagrant/vagrant"
* Installed packages
  * Chocolatey
  * QEMU guest additions
  * VirtIO drivers
  * spice-agent

# UEFI
download ubuntu noble ovmf package "ovmf_2024.02-2_all.deb"

extract (`ar xv ovmf_2024.02-2_all.deb && tar --use-compress-program=unzstd -xvf data.tar.zst`)

https://github.com/tompreston/qemu-ovmf-swtpm

# Windows setup and unattend
* [Automate Windows Setup](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/automate-windows-setup?view=windows-11)
* [Windows Setup Command-Line Options](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-setup-command-line-options?view=windows-11#unatten)
* [Configure UEFI/GPT-Based Hard Drive Partitions](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-8.1-and-8/hh824839(v=win.10))
* [Sample: Configure UEFI/GPT-Based Hard Drive Partitions by Using Windows Setup](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-8.1-and-8/hh825702(v=win.10))
* [Configure BIOS/MBR-Based Hard Drive Partitions](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-8.1-and-8/hh825146(v=win.10))
* [Answer files (unattend.xml)](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/)update-windows-settings-and-scripts-create-your-own-answer-file-sxs?view=windows-11
* [Unattended Windows Setup Reference](https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/)
* [Implicit Answer File Search Order](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-setup-automation-overview?view=windows-11#implicit-answer-file-search-order)

# Unattended generator

* https://schneegans.de/windows/unattend-generator/ 
* https://github.com/cschneegans/unattend-generator/

# Windows Update provisioner

[Windows Update provisioner](https://github.com/rgl/packer-plugin-windows-update) provisioner for gracefully handling Windows updates and the reboots they cause
# windows isos
* https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022
* https://www.microsoft.com/en-us/evalcenter/download-windows-server-2025
* https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise

```
# Download url's found at https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022
iso_url                 = "https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"
iso_checksum            = "3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"

# Download url's found at https://www.microsoft.com/en-us/evalcenter/download-windows-server-2025
iso_url                 = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
iso_checksum            = "d0ef4502e350e3c6c53c15b1b3020d38a5ded011bf04998e950720ac8579b23d"

# Download url's found at https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise
iso_url                 = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
iso_checksum            = "755A90D43E826A74B9E1932A34788B898E028272439B777E5593DEE8D53622AE"
```


# Remoting over SSH
* https://learn.microsoft.com/en-us/powershell/scripting/security/remoting/ssh-remoting-in-powershell?view=powershell-7.4

# mouse pb

<input type="tablet" bus="usb">
  <alias name="input2"/>
  <address type="usb" bus="0" port="1"/>
</input>




https://github.com/Orange-Cyberdefense/GOAD/blob/main/packer/vagrant/windows_2022.json
https://wiki.archlinux.org/title/QEMU#Preparing_an_Arch_Linux_guest
https://github.com/StefanScherer/packer-windows
https://github.com/proactivelabs/packer-windows
https://github.com/jakobadam/packer-qemu-templates



https://github.com/chef/bento
