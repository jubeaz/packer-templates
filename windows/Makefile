HEADLESS=false
VERSION=windows-2025
TEMPLATE_NAME=jubeaz
init:
	packer init .
	packer plugins install github.com/hashicorp/vagrant
	
qemu-bios-windows-2022:
	$(MAKE) build HYPERVISOR=qemu \
			VERSION=windows-2022 \
			BOXNAME=qemu-jubeaz-bios-windows-2022 \
			BUILD_T_VARFILE=windows-qemu-bios-windows-2022.pkrvars.hcl \
			OS_V_VARFILE=windows-2022.pkrvars.hcl \
			IS_CORE=false \
			TARGET=qemu.windows-2022-bios
#	$(MAKE) deploy BOXNAME=qemu-jubeaz-bios-windows-2022

qemu-uefi-windows-2022:
	$(MAKE) build HYPERVISOR=qemu \
			VERSION=windows-2022 \
			BOXNAME=qemu-jubeaz-uefi-windows-2022 \
			BUILD_T_VARFILE=windows-qemu-uefi-windows-2022.pkrvars.hcl \
			OS_V_VARFILE=windows-2022.pkrvars.hcl \
			IS_CORE=false \
			TARGET=qemu.windows-2022-uefi
#	$(MAKE) deploy BOXNAME=qemu-jubeaz-uefi-windows-2022

qemu-bios-windows-2025:
	$(MAKE) build HYPERVISOR=qemu \
			VERSION=windows-2025 \
			BOXNAME=qemu-jubeaz-bios-windows-2025 \
			BUILD_T_VARFILE=windows-qemu-bios-windows-2025.pkrvars.hcl \
			OS_V_VARFILE=windows-2025.pkrvars.hcl \
			IS_CORE=false \
			TARGET=qemu.windows-2025-bios
#	$(MAKE) deploy BOXNAME=qemu-jubeaz-bios-windows-2025

qemu-uefi-windows-2025:
	$(MAKE) build HYPERVISOR=qemu \
			VERSION=windows-2025 \
			BOXNAME=qemu-jubeaz-uefi-windows-2025 \
			BUILD_T_VARFILE=windows-qemu-uefi-windows-2025.pkrvars.hcl \
			OS_V_VARFILE=windows-2025.pkrvars.hcl \
			IS_CORE=false \
			TARGET=qemu.windows-2025-uefi
	$(MAKE) deploy BOXNAME=qemu-jubeaz-uefi-windows-2025

qemu-uefi-windows-2025-core:
	$(MAKE) build HYPERVISOR=qemu \
			VERSION=windows-2025 \
			BOXNAME=qemu-jubeaz-uefi-windows-2025-core \
			BUILD_T_VARFILE=windows-qemu-uefi-windows-2025.pkrvars.hcl \
			OS_V_VARFILE=windows-2025.pkrvars.hcl \
			IS_CORE=true \
			TARGET=qemu.windows-2025-uefi
#	$(MAKE) deploy BOXNAME=qemu-jubeaz-uefi-windows-2025

download:
	 curl -L -o binaries/virtio-win-guest-tools.exe https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.271-1/virtio-win-guest-tools.exe
	 mkdir -p ./ovmf/tmp
	 # https://packages.debian.org/sid/all/ovmf/download
	 curl -L -o ./ovmf/tmp/ovmf_2025.02-9_all.deb http://ftp.fr.debian.org/debian/pool/main/e/edk2/ovmf_2025.02-9_all.deb
	 ar xv ./ovmf/tmp/ovmf_2025.02-9_all.deb --output=./ovmf/tmp
	 tar --use-compress-program=unzstd -xvf ovmf/tmp/data.tar.xz  -C ./ovmf
	 rm -rf ./ovmf/tmp
validate:
	packer validate \
		-var "hypervisor=$(HYPERVISOR)" \
		-var "headless=$(HEADLESS)" \
		-var "verion=$(VERSION)" \
		-var "is_core=$(IS_CORE)" \
		-var "template_name=$(TEMPLATE_NAME)" \
		-var-fil $(BUILD_T_VARFILE) \
		-var-file $(OS_V_VARFILE) \
		.
clean:
	rm -rf boxes/*.box
build:
	packer build -force -on-error=ask -timestamp-ui \
		-var "headless=$(HEADLESS)" \
		-var "vm_name=$(BOXNAME)" \
		-var "hypervisor=$(HYPERVISOR)" \
		-var "verion=$(VERSION)" \
		-var "is_core=$(IS_CORE)" \
		-var "template_name=$(TEMPLATE_NAME)" \
		-var-file $(BUILD_T_VARFILE) \
		-var-file $(OS_V_VARFILE) \
		-only=${TARGET} .
deploy: 
	vagrant box add $(BOXNAME) ./boxes/$(BOXNAME).box --force

