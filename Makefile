# PlasmaCodexBar - Makefile
# For manual installation or package building

PREFIX ?= /usr
DESTDIR ?=

PLASMOID_DIR = $(DESTDIR)$(PREFIX)/share/plasma/plasmoids/org.kde.plasma.plasmacodexbar
BIN_DIR = $(DESTDIR)$(PREFIX)/bin

.PHONY: all install uninstall user-install user-uninstall

all:
	@echo "PlasmaCodexBar"
	@echo ""
	@echo "Available targets:"
	@echo "  install        - Install system-wide (requires root)"
	@echo "  uninstall      - Remove system-wide installation"
	@echo "  user-install   - Install for current user only"
	@echo "  user-uninstall - Remove user installation"
	@echo ""
	@echo "For packaging:"
	@echo "  make DESTDIR=/tmp/pkg install"

install:
	@echo "Installing PlasmaCodexBar system-wide..."
	install -dm755 $(PLASMOID_DIR)
	cp -r plasmoid/* $(PLASMOID_DIR)/
	install -Dm755 plasmacodexbar-backend $(BIN_DIR)/plasmacodexbar-backend
	@echo "Done. Restart plasmashell to use the widget."

uninstall:
	@echo "Removing PlasmaCodexBar..."
	rm -rf $(PLASMOID_DIR)
	rm -f $(BIN_DIR)/plasmacodexbar-backend
	@echo "Done."

user-install:
	@echo "Installing PlasmaCodexBar for current user..."
	mkdir -p ~/.local/share/plasma/plasmoids/org.kde.plasma.plasmacodexbar
	cp -r plasmoid/* ~/.local/share/plasma/plasmoids/org.kde.plasma.plasmacodexbar/
	mkdir -p ~/.local/bin
	cp plasmacodexbar-backend ~/.local/bin/
	chmod +x ~/.local/bin/plasmacodexbar-backend
	@echo "Done. Restart plasmashell to use the widget."
	@echo "Make sure ~/.local/bin is in your PATH"

user-uninstall:
	@echo "Removing PlasmaCodexBar user installation..."
	rm -rf ~/.local/share/plasma/plasmoids/org.kde.plasma.plasmacodexbar
	rm -f ~/.local/bin/plasmacodexbar-backend
	@echo "Done."
