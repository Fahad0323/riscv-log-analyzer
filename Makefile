SCRIPT = scripts/analyze.sh
OUT_DIR = output

.PHONY: all test report clean help setup

all: setup test report

setup:
	which bash
	which grep
	which awk
	which sed
test:
	@echo "Testing PASS"
	bash $(SCRIPT) test_data/sample_pass.log
	@echo "Testing FAIL "
	bash $(SCRIPT) test_data/sample_fail.log
report:
	mkdir -p $(OUT_DIR)
	bash $(SCRIPT) --format csv --output $(OUT_DIR)/summary.csv test_data/sample_sim.log

clean:
	rm -rf $(OUT_DIR)
help:
	@echo "Available Targets:"
	@echo "  make setup  - Check grep, awk, sed installed"
	@echo "  make test   - Run the analyzer on test logs"
	@echo "  make report - Generate summary"
	@echo "  make clean  - Delete output files"
	@echo "  make all    - Run analyzer"
