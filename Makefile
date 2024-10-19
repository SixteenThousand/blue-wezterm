IGNORE="--ignore=Makefile"
install:
	stow -S . -t $(HOME)/.config $(IGNORE)
uninstall:
	stow -D . -t $(HOME)/.config $(IGNORE)
