.PHONY: default install install/desktop install/dev install/_current help

DESKTOP_DIR := desktop
DEV_DIR := dev
SCRIPTS_DIR := scripts
CONFIG_SDIR := config


ifndef HOME
$(error HOME is not set)
endif

ifndef XDG_CONFIG_HOME
$(error XDG_CONFIG_HOME is not set)
endif


default: help

### Install default (desktop)
install: install/desktop


### Install configs for desktop
install/desktop: export DOTFILES_DIR := $(DESKTOP_DIR)
install/desktop:
	@$(MAKE) install/_current

### Install configs for dev
install/dev: export DOTFILES_DIR := $(DEV_DIR)
install/dev:
	@$(MAKE) install/_current


install/_current:
	@for var in `ls -A $(DOTFILES_DIR) | grep "^\."`; do \
		src=$(abspath $(DOTFILES_DIR)/$$var); \
		dist=$$HOME/$$var; \
		if ! [ $$src -ef $$dist ]; then \
			ln -vsfn $$src $$dist ;\
		fi \
	done

	@if ! [ -d $(XDG_CONFIG_HOME) ]; then mkdir -v $(XDG_CONFIG_HOME); fi

	@if [ -d $(DOTFILES_DIR)/$(CONFIG_SDIR) ]; then \
		for var in `ls -A $(DOTFILES_DIR)/$(CONFIG_SDIR)`; do \
			src=$(abspath $(DOTFILES_DIR)/$(CONFIG_SDIR)/$$var); \
			dist=$$XDG_CONFIG_HOME/$$var; \
			if [ -d $$dist ] && ! [ -L $$dist ]; then \
				echo "$$dist is not a symlink pointing to a directory." ;\
			else \
				if ! [ $$src -ef $$dist ]; then \
					ln -vsfn $$src $$dist  ;\
				fi \
			fi \
		done \
	fi

### Help
help:
	@printf "Targets:\n"
	@awk '/^[a-zA-Z\-_0-9%:\\]+/ { \
		helpMessage = match(lastLine, /^###(.*)/); \
		if (helpMessage) { \
			helpCommand = $$1; \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			gsub("\\\\", "", helpCommand); \
			gsub(":+$$", "", helpCommand); \
			printf "  \x1b[32;01m%-26s\x1b[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u
