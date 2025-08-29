https://github.com/Orange-Cyberdefense/GOAD/blob/main/packer/vagrant/windows_2022.json
https://github.com/proactivelabs/packer-windows/tree/master
https://wiki.archlinux.org/title/QEMU#Preparing_an_Arch_Linux_guest
https://github.com/StefanScherer/packer-windows
https://github.com/proactivelabs/packer-windows
https://github.com/jakobadam/packer-qemu-templates



https://github.com/chef/bento
```
os_name    = "windows"
os_version = "2022"
os_arch    = "x86_64"
is_windows = true
# Download url's found at https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022
iso_url                 = "https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"
iso_checksum            = "3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"

os_name    = "windows"
os_version = "2025"
os_arch    = "x86_64"
is_windows = true
# Download url's found at https://www.microsoft.com/en-us/evalcenter/download-windows-server-2025
iso_url                 = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
iso_checksum            = "d0ef4502e350e3c6c53c15b1b3020d38a5ded011bf04998e950720ac8579b23d"

os_name    = "windows"
os_version = "11"
os_arch    = "x86_64"
is_windows = true
# Download url's found at https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise
iso_url                 = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
iso_checksum            = "755A90D43E826A74B9E1932A34788B898E028272439B777E5593DEE8D53622AE"
parallels_guest_os_type = "win-11"
vbox_guest_os_type      = "Windows11_64"
vmware_guest_os_type    = "windows9srv-64"
```
