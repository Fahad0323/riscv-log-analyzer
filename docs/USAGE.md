# Detailed Command Reference Guide

This document provides an exhaustive reference for the RISC-V Log Analyzer
 tool flags, arguments, and automated workflows.

# Script Flags & Parameters
The core execution command is:
`bash scripts/analyze.sh [FLAGS] <input_log_file>`

# Available Options:
#| Flag / Option | Description | Example Usage |
* <input_log_file> : The relative path to the .log file to parse.
 (Required)| `bash scripts/analyze.sh test_data/empty.log`

* --format csv : Changes the default text report to a comma-separated 
format.| `bash scripts/analyze.sh --format csv test_data/sample_fail.log`
* `--output <file>` | Redirects the output summary into a specified file 
path rather than printing to terminal.
| `bash scripts/analyze.sh --output output/report.csv test_data/sample_fail.log`

# Makefile Automation Commands
* make setup  - Verifies the system environments (bash, grep, awk, sed).
* make test   - Executes the testing script on both passing and failing
 sample logs.
* make report - Automates directory create ('output/') and outputs a
  'summary.csv' dataset.
* make clean  - clean all  data artifacts and resets the active
 workspace.
