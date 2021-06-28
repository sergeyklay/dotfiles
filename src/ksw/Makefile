# based on:
#  - https://github.com/afk-mario/dotfiles/blob/main/bin-src/keyboard_layout_switcher/Makefile
#

BUILD_DIR  = $(HOME)/.local/bin

GOSRC      = $(wildcard *.go)
GOTARGET   = $(GOSRC:%.go=$(BUILD_DIR)/%)

TARGETS    = $(GOTARGET)

.PHONY: all go clean

all: go

go: $(GOTARGET)

$(BUILD_DIR)/%: %.go
	go build -o $@ $<

clean:
	rm -f $(TARGETS)

