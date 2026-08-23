DEPS_DIR := deps
MINI_DIR := $(DEPS_DIR)/mini.nvim

.PHONY: test deps clean

test: deps
	nvim --headless --noplugin -u scripts/minimal_init.lua -c "lua MiniTest.run()"

deps: $(MINI_DIR)

$(MINI_DIR):
	@mkdir -p $(DEPS_DIR)
	git clone --depth 1 https://github.com/echasnovski/mini.nvim $@

clean:
	rm -rf $(DEPS_DIR)
