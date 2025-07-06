BOOTMODE=efi
VARFILE = arch-$(BOOTMODE).pkrvars.hcl
TARGET = virtualbox-iso.archlinux-uefi
VERSION = archlinux-x86_64
BOXNAME = jubeaz-$(BOOTMODE)-$(VERSION)

STRIPPED := $(shell echo $(VERSION) | sed -E 's/-[0-9]{4}\.[0-9]{2}\.[0-9]{2}-/-/')
init:
	packer init .

validate:
	packer validate -var-file $(VARFILE) .
clean:
	rm -rf boxes/*.box
build:
	packer build -force -on-error=ask -timestamp-ui -var "archiso_verion=$(VERSION)" -var-file $(VARFILE) -only=${TARGET} .
deploy: 
	vagrant box add $(BOXNAME) ./boxes/$(BOXNAME).box --force

