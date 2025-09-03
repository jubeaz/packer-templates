HEADLESS=true
VERSION=archlinux-x86_64
TEMPLATE_NAME=jubeaz
init:
	packer init .
	packer plugins install github.com/hashicorp/vagrant

qemu-uefi:
	$(MAKE) build HYPERVISOR=qemu  BOXNAME=qemu-jubeaz-uefi-$(VERSION) VARFILE=arch-qemu-uefi.pkrvars.hcl TARGET=qemu.archlinux-uefi
	$(MAKE) deploy BOXNAME=qemu-jubeaz-uefi-$(VERSION)

qemu-bios:
	$(MAKE) build HYPERVISOR=qemu  BOXNAME=qemu-jubeaz-bios-$(VERSION) VARFILE=arch-qemu-bios.pkrvars.hcl TARGET=qemu.archlinux-bios
	$(MAKE) deploy BOXNAME=qemu-jubeaz-bios-$(VERSION)

virtualbox-bios:
	$(MAKE) build HYPERVISOR=virtualbox  BOXNAME= virtualbox-jubeaz-bios-archlinux-x86_64 VARFILE=arch-virtualbox-bios.pkrvars.hcl TARGET=virtualbox-iso.archlinux-bios
	$(MAKE) deploy BOXNAME=virtualbox-jubeaz-bios-archlinux-x86_64

validate:
	packer validate -var "hypervisor=$(HYPERVISOR)" -var "headless=$(HEADLESS)" -var "archiso_verion=$(VERSION)" -var "template_name=$(TEMPLATE_NAME)" -var-file $(VARFILE) .
clean:
	rm -rf boxes/*.box
build:
	packer build -force -on-error=ask -timestamp-ui -var "headless=$(HEADLESS)" -var "hypervisor=$(HYPERVISOR)" -var "archiso_verion=$(VERSION)" -var "template_name=$(TEMPLATE_NAME)" -var-file $(VARFILE) -only=${TARGET} .
deploy: 
	vagrant box add $(BOXNAME) ./boxes/$(BOXNAME).box --force

