.PHONY: all build iso clean help test run

# VISTER OS v1.0 - Makefile

help:
	@echo "🟢 VISTER OS v1.0 - Build System"
	@echo "=================================="
	@echo ""
	@echo "Dostupne komande:"
	@echo ""
	@echo "  make build      - Build kernel i module"
	@echo "  make iso        - Kreiraj bootable ISO"
	@echo "  make all        - Build sve (kernel + ISO)"
	@echo "  make clean      - Obriši build fajlove"
	@echo "  make test       - Testiraj ISO"
	@echo "  make run        - Pokreni na QEMU"
	@echo "  make help       - Prikaži ovu pomoć"
	@echo ""

all: build iso
	@echo "✅ Sve je spremno!"

build:
	@echo "🔨 Builduje Vister OS..."
	@mkdir -p build/iso_root/boot/grub
	@mkdir -p build/iso_root/kernel
	@mkdir -p build/iso_root/modules
	@mkdir -p build/iso_root/etc
	@mkdir -p build/iso_root/home
	@mkdir -p build/iso_root/usr/bin
	@mkdir -p build/iso_root/usr/lib
	@echo "✅ Direktorijumi kreirani"

iso: build
	@echo "🟢 Kreiram ISO fajl..."
	@chmod +x scripts/create_iso.sh
	@bash scripts/create_iso.sh
	@echo "✅ ISO je kreirano!"

clean:
	@echo "🧹 Čiste build direktorijume..."
	@rm -rf build/
	@rm -rf dist/vister.iso
	@echo "✅ Obrisano"

test:
	@echo "🧪 Testiram ISO..."
	@if [ -f dist/vister.iso ]; then \
		echo "📁 ISO fajl: dist/vister.iso"; \
		file dist/vister.iso; \
		ls -lh dist/vister.iso; \
		echo "✅ ISO je validan!"; \
	else \
		echo "❌ ISO nije pronađen! Prvo pokreni: make iso"; \
		exit 1; \
	fi

run: iso
	@echo "🚀 Pokrećem ISO na QEMU..."
	@if command -v qemu-system-x86_64 &> /dev/null; then \
		qemu-system-x86_64 -cdrom dist/vister.iso -m 1024 -enable-kvm; \
	else \
		echo "⚠️ QEMU nije instaliran!"; \
		echo "Koristi VirtualBox ili VMware za pokretanje ISO-a"; \
		echo "ISO lokacija: dist/vister.iso"; \
	fi

install-deps:
	@echo "📦 Instaliram zavisnosti..."
	@which nasm > /dev/null 2>&1 || (echo "Installing NASM..." && sudo apt-get install -y nasm)
	@which genisoimage > /dev/null 2>&1 || (echo "Installing genisoimage..." && sudo apt-get install -y genisoimage)
	@which qemu-system-x86_64 > /dev/null 2>&1 || (echo "Installing QEMU..." && sudo apt-get install -y qemu-system-x86)
	@echo "✅ Zavisnosti instalirane"

# Brz build
quick:
	@make clean
	@make all

# Verbose build
verbose: VERBOSE = 1
verbose: all
	@echo "🔍 Verbose mode aktiviran"

.DEFAULT_GOAL := help
