#!/bin/bash

# Best practice: Script ko fail hone par turant rokne ke liye
set -euo pipefail

# ---------------------------------------------------------
# FUNCTION 1: Help aur usage instructions dikhane ke liye
# ---------------------------------------------------------
print_help() {
    echo "Usage: $0 [options] <log_file>"
    echo "Options:"
    echo "  --format [text|csv]  Output format (default: text)"
    echo "  --output <path>      Output file path (default: stdout)"
    echo "  --verbose            Enable verbose output"
    echo "  --help               Print usage information"
}

# Default settings (Variables)
FORMAT="text"
OUTPUT_FILE=""
VERBOSE=0
LOG_FILE=""

# Command-line arguments ko parse karne ke liye 'while' aur 'case' ka use
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)
            print_help
            exit 0
            ;;
        --format)
            FORMAT="$2"
            shift 2 # Processed 2 arguments
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=1
            shift 1
            ;;
        -*)
            echo "Error: Invalid option '$1'"
            print_help
            exit 1 # Error exit code
            ;;
        *)
            LOG_FILE="$1"
            shift 1
            ;;
    esac
done

# ERROR HANDLING: Agar log file ka naam miss ho gaya hai
if [[ -z "$LOG_FILE" ]]; then
    echo "Error: Missing log file argument."
    print_help
    exit 1
fi

# ERROR HANDLING: Agar file system mein exist nahi karti
if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: Log file '$LOG_FILE' not found."
    exit 1
fi

# ---------------------------------------------------------
# FUNCTION 2: Asal analysis ka kaam yahan hota hai
# ---------------------------------------------------------
analyze_log() {
    local file="$1"

    if [[ "$VERBOSE" -eq 1 ]]; then
        echo "[VERBOSE] Analyzing simulation log: $file"
    fi

    # 1. Total aur baqi counts nikalna (grep aur wc ka use)
    # || true lagaya hai taake error na aaye agar koi line na mile (set -e ki wajah se)
    local total_tests=$(grep -c "TEST START:" "$file" || true)
    local pass_count=$(grep -c "TEST PASS:" "$file" || true)
    local fail_count=$(grep -c "TEST FAIL:" "$file" || true)
    local skip_count=$(grep -c "TEST SKIP:" "$file" || true)

    if [[ "$total_tests" -eq 0 ]]; then
        echo "Error: No valid tests found in the log file."
        exit 1
    fi

    # 2. Pass rate calculate karna (awk use kiya hai floats ke liye)
    local pass_rate=$(awk -v p="$pass_count" -v t="$total_tests" 'BEGIN { printf "%.2f", (p/t)*100 }')

    # 3. Fail hone wale tests ke naam nikalna (awk se column extract karna)
    local fail_list=$(grep "TEST FAIL:" "$file" | awk '{print $5}' || true)

    # 4. Execution times extract karna (sed se brackets aur 's' hatana)
    # Example format: (0.82s) -> 0.82
    local times=$(grep -E "TEST PASS:|TEST FAIL:" "$file" | awk '{print $NF}' | sed 's/(//g; s/s)//g' || true)

    # 5. Min, Max, aur Avg calculate karna awk script ke zariye
    local time_stats=$(echo "$times" | awk '
        BEGIN { min=9999; max=0; sum=0; count=0 }
        {
            if ($1 < min) min=$1
            if ($1 > max) max=$1
            sum+=$1
            count++
        }
        END {
            if (count > 0) printf "%.2f %.2f %.2f", min, max, sum/count
            else print "0.00 0.00 0.00"
        }
    ')

    # Time stats ko alag alag variables mein dalna
    local min_time=$(echo "$time_stats" | awk '{print $1}')
    local max_time=$(echo "$time_stats" | awk '{print $2}')
    local avg_time=$(echo "$time_stats" | awk '{print $3}')

    # Output kaha bhejna hai (file ya terminal)
    local dest="/dev/stdout"
    if [[ -n "$OUTPUT_FILE" ]]; then
        dest="$OUTPUT_FILE"
        if [[ "$VERBOSE" -eq 1 ]]; then echo "[VERBOSE] Writing output to $dest"; fi
    fi

    # 6. Formatting (Text vs CSV)
    if [[ "$FORMAT" == "csv" ]]; then
        {
            echo "Metric,Value"
            echo "Total Tests,$total_tests"
            echo "PASS,$pass_count"
            echo "FAIL,$fail_count"
            echo "SKIP,$skip_count"
            echo "Pass Rate (%),$pass_rate"
            echo "Min Time (s),$min_time"
            echo "Max Time (s),$max_time"
            echo "Avg Time (s),$avg_time"
        } > "$dest"
    else
        {
            echo "=== RISC-V Simulation Log Analysis ==="
            echo "Total Tests Run : $total_tests"
            echo "PASS Results    : $pass_count"
            echo "FAIL Results    : $fail_count"
            echo "SKIP Results    : $skip_count"
            echo "Pass Rate       : $pass_rate%"
            echo "--------------------------------------"
            echo "Failing Tests:"
            if [[ -z "$fail_list" ]]; then
                echo "  (None)"
            else
                echo "$fail_list" | sed 's/^/  - /'
            fi
            echo "--------------------------------------"
            echo "Execution Time Statistics:"
            echo "  Min Time : ${min_time}s"
            echo "  Max Time : ${max_time}s"
            echo "  Avg Time : ${avg_time}s"
            echo "======================================"
        } > "$dest"
    fi

    # Requirement: Exit code 0 if pass, 1 if any fail
    if [[ "$fail_count" -gt 0 ]]; then
        return 1
    else
        return 0
    fi
}

# Function Call
analyze_log "$LOG_FILE"
