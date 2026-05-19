# Variables
SCRIPT = scripts/analyze.sh
REPORT_SCRIPT = scripts/generate_report.sh
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
	@echo "Testing FAIL"
	bash $(SCRIPT) test_data/sample_fail.log

report:
	mkdir -p $(OUT_DIR)
	@echo "Generating CSV Report using generate_report.sh"
	bash $(REPORT_SCRIPT)

clean:
	rm -rf $(OUT_DIR)

help:
	@echo "Available Targets:"
	@echo "  make setup   - Check grep, awk, sed installed"
	@echo "  make test    - Run the analyzer on test logs"
	@echo "  make report  - Generate summary CSV"
	@echo "  make clean   - Delete output files"
	@echo "  make all     - Run setup, test, and report"
