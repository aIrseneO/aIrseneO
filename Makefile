# Simple Makefile for ogit CLI

PREFIX ?= $(HOME)/.local
BINDIR := $(PREFIX)/bin
BASH_COMPLETIONS_DIR := $(HOME)/.local/share/bash-completion
ZSH_COMPLETIONS_DIR := $(HOME)/.zsh/completions
FISH_COMPLETIONS_DIR := $(HOME)/.config/fish/completions
OGIT_SCRIPT ?= $(CURDIR)/ogit.sh
OGIT_BIN := $(BINDIR)/ogit

.PHONY: help install uninstall completion-bash completion-zsh completion-fish

all: install completion-bash

help:
	@echo "Targets:"
	@echo "  make install           # Install ogit to $(OGIT_BIN)"
	@echo "  make uninstall         # Remove installed ogit"
	@echo "  make completion-bash   # Install Bash completion to $(BASH_COMPLETIONS_DIR)/ogit"
	@echo "  make completion-zsh    # Install Zsh completion to $(ZSH_COMPLETIONS_DIR)/_ogit_sh"
	@echo "  make completion-fish   # Install Fish completion to $(FISH_COMPLETIONS_DIR)/ogit.fish"

install:
	@mkdir -p "$(BINDIR)"
	@install -m 0755 "$(OGIT_SCRIPT)" "$(OGIT_BIN)"
	@echo "Installed: $(OGIT_BIN)"
	@echo "If needed, add to PATH: export PATH=\"$(BINDIR):$$PATH\""

uninstall:
	@rm -f "$(OGIT_BIN)"
	@echo "Removed: $(OGIT_BIN)"

completion-bash:
	@[ -x "$(OGIT_BIN)" ] || { echo "Please run 'make install' first"; exit 1; }
	@mkdir -p "$(BASH_COMPLETIONS_DIR)"
	@"$(OGIT_BIN)" install completion > "$(BASH_COMPLETIONS_DIR)/ogit"
	@echo "Bash completion: $(BASH_COMPLETIONS_DIR)/ogit"
	@echo "Source suggestion (once): if [ -f ~/.local/share/bash-completion/ogit ]; then . ~/.local/share/bash-completion/ogit; fi"

completion-zsh:
	@[ -x "$(OGIT_BIN)" ] || { echo "Please run 'make install' first"; exit 1; }
	@mkdir -p "$(ZSH_COMPLETIONS_DIR)"
	@"$(OGIT_BIN)" install completion zsh > "$(ZSH_COMPLETIONS_DIR)/_ogit_sh"
	@echo "Zsh completion: $(ZSH_COMPLETIONS_DIR)/_ogit_sh"
	@echo "Ensure in ~/.zshrc: fpath+=(~/.zsh/completions); autoload -U compinit && compinit"

completion-fish:
	@[ -x "$(OGIT_BIN)" ] || { echo "Please run 'make install' first"; exit 1; }
	@mkdir -p "$(FISH_COMPLETIONS_DIR)"
	@"$(OGIT_BIN)" install completion fish > "$(FISH_COMPLETIONS_DIR)/ogit.fish"
	@echo "Fish completion: $(FISH_COMPLETIONS_DIR)/ogit.fish"