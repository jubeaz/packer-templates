HEADLESS=false
VERSION=windows-2022
TEMPLATE_NAME=jubeaz
init:
	packer init .
	packer plugins install github.com/hashicorp/vagrant
	
qemu-bios-windows-2022:
	$(MAKE) build HYPERVISOR=qemu  BOXNAME=qemu-jubeaz-bios-$(VERSION) VARFILE=windows-qemu-bios-windows-2022.pkrvars.hcl TARGET=qemu.windows-2022-bios
	$(MAKE) deploy BOXNAME=qemu-jubeaz-bios-$(VERSION)

validate:
	packer validate -var "hypervisor=$(HYPERVISOR)" -var "headless=$(HEADLESS)" -var "verion=$(VERSION)" -var "template_name=$(TEMPLATE_NAME)" -var-file $(VARFILE) .
clean:
	rm -rf boxes/*.box
build:
	packer build -force -on-error=ask -timestamp-ui -var "headless=$(HEADLESS)" -var "vm_name=$(BOXNAME)" -var "hypervisor=$(HYPERVISOR)" -var "verion=$(VERSION)" -var "template_name=$(TEMPLATE_NAME)" -var-file $(VARFILE) -only=${TARGET} .
deploy: 
	vagrant box add $(BOXNAME) ./boxes/$(BOXNAME).box --force

