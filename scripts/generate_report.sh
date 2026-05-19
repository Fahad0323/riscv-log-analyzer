cat << 'EOF' > scripts/generate_report.sh
#!/bin/bash

echo "=== Generating Final CSV Report ==="

# Output folder create karein agar nahi bana hua
mkdir -p output

# CSV file ki pehli header line write karein
echo "File Name,Total Tests,Passed,Failed,Skipped" > output/summary.csv

# Simple Module 1 Loop saari log files par
for file in test_data/*.log; do
    if [ -f "$file" ]; then
        # Just file ka naam alag karein
        filename=$(basename "$file")
        
        # Grep -c se simple lines count karein
        total=$(grep -c "TEST START:" "$file")
        passed=$(grep -c "TEST PASS:" "$file")
        failed=$(grep -c "TEST FAIL:" "$file")
        skipped=$(grep -c "TEST SKIP:" "$file")
        
        # Data ko CSV mein append (>> ) karein
        echo "$filename,$total,$passed,$failed,$skipped" >> output/summary.csv
        echo "Processed: $filename"
    fi
done

echo "Done! Report saved in output/summary.csv"
EOF
