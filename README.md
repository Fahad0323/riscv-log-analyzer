# RISC-V Simulation Log Analyzer

# Description
This project is an automated Bash  analyze simulation log files for RISC-V processors. It scans log data to count passed, failed, and skipped tests, extracts timing statistics, and generates report for testing pipelines.

# Installation
Ensure you have a Linux/WSL environment with standard tools.

1. Open the repository folder:
   cd riscv-log-analyzer
2. Check tool using the Makefile:
   make setup

# Usage Examples
# Direct Execution:
* Analyze a log file:
  bash scripts/analyze.sh test_data/sample_pass.log
* Generate a summary report:
  bash scripts/analyze.sh --format csv --output output/summary.csv test_data/sample_fail.log

# Makefile Automation:
* Run tests: make test
* Generate summary: make report
* Clean : make clean

# Sample Output
When running 'make test' on a passing log, the tool generates the following report:
```text
--RISC-V Simulation Log Analysis 
Log file: test_data/sample_pass.log
---Results Summary
Total tests: 1
Passed:      1 (100.0%)
Failed:       0 ( 0.0%)
 --- Verdict: PASS --- 
```
