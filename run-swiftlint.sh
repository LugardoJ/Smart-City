#!/bin/bash

# ========== CONFIG ==========
SRCROOT="${SRCROOT:-$(pwd)}"
LOG_BASE="$SRCROOT/Logs"

FULL_DIR="$LOG_BASE/Main"
ERROR_DIR="$LOG_BASE/Errors"
WARNING_DIR="$LOG_BASE/Warnings"

mkdir -p "$FULL_DIR" "$ERROR_DIR" "$WARNING_DIR"

TIMESTAMP=$(date "+%Y-%m-%d_%H-%M")

# Output files
FULL_LOG="${FULL_DIR}/swiftlint-${TIMESTAMP}.log"
ERROR_LOG="${ERROR_DIR}/swiftlint-errors-${TIMESTAMP}.log"
WARNING_LOG="${WARNING_DIR}/swiftlint-warnings-${TIMESTAMP}.log"
SUMMARY_JSON="${LOG_BASE}/summary-latest.json"
TEMP_LOG="${LOG_BASE}/temp-swiftlint-output.log"

# Add Homebrew paths for Xcode/Terminal compatibility
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# ========== CHECK ==========
if ! command -v swiftlint >/dev/null 2>&1; then
  echo "❌ SwiftLint not installed. Use: brew install swiftlint"
  exit 0
fi

# ========== AUTO-CORRECT ==========
echo "🔧 Running SwiftLint autocorrect..."
swiftlint autocorrect --format

# ========== LINT ==========
echo "🔍 Running SwiftLint..."
swiftlint lint --config "$SRCROOT/.swiftlint.yml" 2>&1 \
  | grep -v "@__swiftmacro_" \
  | grep -v "/var/folders" \
  | grep -v "swift-generated-sources" \
  | tee "$TEMP_LOG"

# ========== OUTPUT ==========
cp "$TEMP_LOG" "$FULL_LOG"
grep " error: " "$TEMP_LOG" > "$ERROR_LOG"
grep " warning: " "$TEMP_LOG" > "$WARNING_LOG"

error_count=$(wc -l < "$ERROR_LOG" | tr -d ' ')
warning_count=$(wc -l < "$WARNING_LOG" | tr -d ' ')

# ========== JSON SUMMARY ==========
cat > "$SUMMARY_JSON" <<EOF
{
  "timestamp": "$TIMESTAMP",
  "errors": $error_count,
  "warnings": $warning_count,
  "log_files": {
    "full": "Main/$(basename "$FULL_LOG")",
    "errors": "Errors/$(basename "$ERROR_LOG")",
    "warnings": "Warnings/$(basename "$WARNING_LOG")"
  }
}
EOF

# ========== SUMMARY ==========
echo ""
echo "========================"
echo "✅ SwiftLint Summary"
echo "🟡 Warnings: $warning_count"
echo "🔴 Errors:   $error_count"
echo "📄 Complete Log:     $FULL_LOG"
echo "📄 Errors Log:       $ERROR_LOG"
echo "📄 Warnings Log:     $WARNING_LOG"
echo "📊 Summary JSON:     $SUMMARY_JSON"
echo "========================"

# Cleanup
rm "$TEMP_LOG"
