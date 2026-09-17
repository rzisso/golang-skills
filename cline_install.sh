#!/bin/bash

# Installation
# DO: chmod +x cline_install.sh
# THEN: ./cline_install.sh

# ==============================================================================
# Configuration Paths
# ==============================================================================
# This script dynamically handles paths relative to where it is running, 
# making it completely portable.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/skills"
ROUTING_FILE="$SCRIPT_DIR/rules/golang-routing.md"

CLINE_SKILLS_DIR="$HOME/.cline/skills"
CLINE_RULES_DIR="$HOME/.cline/rules"

# Exact tokens from your routing matrix
VALID_TOKENS=(
    "golang-design-patterns" "golang-naming" "golang-code-style" "golang-error-handling"
    "golang-safety" "golang-concurrency" "golang-context" "golang-structs-interfaces" "golang-google-wire"
    "golang-database" "golang-security" "golang-grpc" "golang-testing" "golang-graphql" "golang-stay-updated"
    "golang-spf13-cobra" "golang-cli" "golang-spf13-viper" "golang-stretchr-testify"
    "golang-performance" "golang-benchmark" "golang-troubleshooting" "golang-observability" "golang-data-structures"
    "golang-lint" "golang-refactoring" "golang-project-layout" "golang-documentation" "golang-uber-fx" "golang-uber-dig" "golang-swagger"
    "golang-continuous-integration" "golang-popular-libraries" "golang-pkg-go-dev"
    "golang-dependency-management" "golang-gopls" "golang-modernize" "golang-samber-lo" "golang-samber-hot" "golang-samber-mo" "golang-samber-ro"
    "golang-samber-oops" "golang-samber-slog" "golang-samber-do" "golang-dependency-injection" "golang-how-to"
)

# ==============================================================================
# Step 1: Install Global Routing Rule (.md)
# ==============================================================================
echo "📦 Step 1: Deploying global Go skill-routing matrix..."
echo "──────────────────────────────────────────────"

if [ -f "$ROUTING_FILE" ]; then
    mkdir -p "$CLINE_RULES_DIR"
    cp "$ROUTING_FILE" "$CLINE_RULES_DIR/"
    echo "✅ Global Rules Installed: 'golang-routing.md' -> $CLINE_RULES_DIR/"
else
    echo "❌ Error: Could not find 'golang-routing.md' in your repository root ($SCRIPT_DIR)."
    echo "   Please make sure the file exists alongside this script."
    exit 1
fi

echo ""

# ==============================================================================
# Step 2: Extract & Flatten Nested Skill Subdirectories
# ==============================================================================
echo "🔍 Step 2: Scanning and flattening nested structures in: $SRC_DIR"
echo "🚀 Destination Target: $CLINE_SKILLS_DIR"
echo "──────────────────────────────────────────────"

if [ ! -d "$SRC_DIR" ]; then
    echo "❌ Error: Skills path does not exist: $SRC_DIR"
    exit 1
fi

# Ensure the global Cline skills target directory exists
mkdir -p "$CLINE_SKILLS_DIR"

# Find every instance of SKILL.md in the subfolders
find "$SRC_DIR" -type f -name "SKILL.md" | while read -r skill_file; do
    # Identify the folder housing the SKILL.md file
    parent_dir=$(dirname "$skill_file")
    folder_name=$(basename "$parent_dir")

    # Match check against our accepted routing array
    is_valid=false
    for token in "${VALID_TOKENS[@]}"; do
        if [[ "$folder_name" == "$token" ]]; then
            is_valid=true
            break
        fi
    done

    if [ "$is_valid" = true ]; then
        echo "✅ Valid Skill Found: Deploying '$folder_name'..."
        # Copy the directory and its SKILL.md cleanly into the flat global path
        cp -r "$parent_dir" "$CLINE_SKILLS_DIR/"
    else
        echo "⚠️  Skipping Folder: '$folder_name' does not match a token in the routing matrix."
    fi
done

echo "──────────────────────────────────────────────"
echo "🎉 Global deployment complete! Your toolkit is fully operational."
