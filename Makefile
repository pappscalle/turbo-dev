SRC = src
BUILD = build

DOSEMU2 := $(shell command -v dosemu2 2>/dev/null)
DOSEMU_CMD = $(if $(DOSEMU2), dosemu -quiet -K $(SRC)/ -E "command.com /c build.bat", dosemu -quiet src/build.bat -dumb)

.PHONY: all compile zip dist clean run

all: run

$(BUILD):
	@mkdir -p $@

compile: | $(BUILD)
	@$(DOSEMU_CMD)
	@mv $(SRC)/*.exe $(BUILD)/ 2>/dev/null || true

run: compile
	@dosbox-x -fastlaunch -nolog -exit $(BUILD)/pixels.exe

clean:
	@rm -rf $(BUILD)
