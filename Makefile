SRC = src
BUILD = build

.PHONY: all compile zip dist clean run

all: run

$(BUILD):
	@mkdir -p $@

compile: | $(BUILD)
	@dosemu -quiet -K $(SRC)/ -E "command.com /c build.bat" 
	@mv $(SRC)/*.exe $(BUILD)/ 2>/dev/null || true

run: compile
	@dosbox-x -fastlaunch -nolog -exit $(BUILD)/pixels.exe

clean:
	@rm -rf $(BUILD)
