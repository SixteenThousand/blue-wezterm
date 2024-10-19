IGNORE="--ignore=Makefile"
install:
	stow -S . -t $(HOME) $(IGNORE)
uninstall:
	stow -D . -t $(HOME) $(IGNORE)
