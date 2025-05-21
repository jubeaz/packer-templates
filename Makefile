VARFILE = arch-uefi.pkrvars.hcl
TARGET = virtualbox-iso.archlinux-uefi
init:
	packer init .

validate:
	packer validate -var-file $(VARFILE) .

build:
	packer build -force -on-error=ask -timestamp-ui -var-file $(VARFILE) -only=${TARGET} .
	vargant box add <box-name> <path-to-box-file>
vagrant box add jubeaz-efi-archlinux-2025.05.18-x86_64 ./boxes/jubeaz-efi-archlinux-2025.05.18-x86_64.box
