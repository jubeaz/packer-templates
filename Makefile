VARFILE = arch-uefi.pkrvars.hcl
TARGET = virtualbox-iso.archlinux-uefi
init:
	packer init .

validate:
	packer validate -var-file $(VARFILE) .

build:
	packer build -force -on-error=ask -timestamp-ui -var-file $(VARFILE) -only=${TARGET} .

