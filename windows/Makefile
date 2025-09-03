HEADLESS=false
VERSION=windows-2022
TEMPLATE_NAME=jubeaz
init:
	packer init .
	packer plugins install github.com/hashicorp/vagrant
	
qemu-bios-windows-2022:
	$(MAKE) build HYPERVISOR=qemu  BOXNAME=qemu-jubeaz-bios-$(VERSION) VARFILE=windows-qemu-bios-windows-2022.pkrvars.hcl TARGET=qemu.windows-2022-bios
	$(MAKE) deploy BOXNAME=qemu-jubeaz-bios-$(VERSION)

qemu-uefi-windows-2022:
	$(MAKE) build HYPERVISOR=qemu  BOXNAME=qemu-jubeaz-uefi-$(VERSION) VARFILE=windows-qemu-uefi-windows-2022.pkrvars.hcl TARGET=qemu.windows-2022-uefi
	$(MAKE) deploy BOXNAME=qemu-jubeaz-uefi-$(VERSION)

download:
	 curl -L -o binaries/virtio-win-guest-tools.exe https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.271-1/virtio-win-guest-tools.exe
	 mkdir -p ./ovmf/tmp
	 curl -L -o ./ovmf/tmp/ovmf_2024.02-2_all.deb https://ua.archive.ubuntu.com/ubuntu-archive/ubuntu/pool/main/e/edk2/ovmf_2024.02-2_all.deb
	 ar xv ./ovmf/tmp/ovmf_2024.02-2_all.deb --output=./ovmf/tmp
	 tar --use-compress-program=unzstd -xvf ovmf/tmp/data.tar.zst -C ./ovmf
	 rm -rf ./ovmf/tmp
validate:
	packer validate -var "hypervisor=$(HYPERVISOR)" -var "headless=$(HEADLESS)" -var "verion=$(VERSION)" -var "template_name=$(TEMPLATE_NAME)" -var-file $(VARFILE) .
clean:
	rm -rf boxes/*.box
build:
	packer build -force -on-error=ask -timestamp-ui -var "headless=$(HEADLESS)" -var "vm_name=$(BOXNAME)" -var "hypervisor=$(HYPERVISOR)" -var "verion=$(VERSION)" -var "template_name=$(TEMPLATE_NAME)" -var-file $(VARFILE) -only=${TARGET} .
deploy: 
	vagrant box add $(BOXNAME) ./boxes/$(BOXNAME).box --force

