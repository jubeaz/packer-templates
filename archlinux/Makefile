VERSION = archlinux-x86_64
TEMPLATE_NAME=jubeaz
HEADLESS=false
#BUILD_NAME=qemu
## BUILD_NAME=virtualbox-iso
#HYPERVISOR=qemu
##HYPERVISOR=virtualbox
#BOOTMODE=bios
##BOOTMODE=uefi
#VARFILE = arch-$(HYPERVISOR)-$(BOOTMODE).pkrvars.hcl
#TARGET = $(BUILD_NAME).archlinux-$(BOOTMODE)
#BOXNAME = $(BUILD_NAME)-$(TEMPLATE_NAME)-$(BOOTMODE)-$(VERSION)

#STRIPPED := $(shell echo $(VERSION) | sed -E 's/-[0-9]{4}\.[0-9]{2}\.[0-9]{2}-/-/')
init:
	packer init .
	packer plugins install github.com/hashicorp/vagrant

qemu-bios:
	$(eval BUILD_NAME := qemu)
	$(eval HYPERVISOR := qemu)
	$(eval BOOTMODE := bios)
	$(eval VARFILE := arch-$(HYPERVISOR)-$(BOOTMODE).pkrvars.hcl)
	$(eval TARGET := $(BUILD_NAME).archlinux-$(BOOTMODE))
	$(eval BOXNAME := $(BUILD_NAME)-$(TEMPLATE_NAME)-$(BOOTMODE)-$(VERSION))
	$(MAKE) build HYPERVISOR=$(HYPERVISOR)  BOXNAME=$(BOXNAME) VARFILE=$(VARFILE) TARGET=$(TARGET)
	$(MAKE) deploy BOXNAME=$(BOXNAME)

virtualbox-bios:
	$(eval BUILD_NAME := virtualbox-iso)
	$(eval HYPERVISOR := virtualbox)
	$(eval BOOTMODE := bios)
	$(eval VARFILE := arch-$(HYPERVISOR)-$(BOOTMODE).pkrvars.hcl)
	$(eval TARGET := $(BUILD_NAME).archlinux-$(BOOTMODE))
	$(eval BOXNAME := $(BUILD_NAME)-$(TEMPLATE_NAME)-$(BOOTMODE)-$(VERSION))
	$(MAKE) build HYPERVISOR=$(HYPERVISOR)  BOXNAME=$(BOXNAME) VARFILE=$(VARFILE) TARGET=$(TARGET)
	$(MAKE) deploy BOXNAME=$(BOXNAME)

validate:
	packer validate -var "hypervisor=$(HYPERVISOR)" -var "headless=$(HEADLESS)" -var "archiso_verion=$(VERSION)" -var "template_name=$(TEMPLATE_NAME)" -var-file $(VARFILE) .
clean:
	rm -rf boxes/*.box
build:
	packer build -force -on-error=ask -timestamp-ui -var "headless=$(HEADLESS)" -var "hypervisor=$(HYPERVISOR)" -var "archiso_verion=$(VERSION)" -var "template_name=$(TEMPLATE_NAME)" -var-file $(VARFILE) -only=${TARGET} .
deploy: 
	vagrant box add $(BOXNAME) ./boxes/$(BOXNAME).box --force

