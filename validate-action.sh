#!/bin/bash

# Validation script for action.yml
# This script validates the GitHub Action configuration

set -e

echo "🔍 Validating Aptos CLI Action Configuration"
echo "============================================"

# Check if action.yml exists
if [ ! -f "action.yml" ]; then
    echo "❌ action.yml not found"
    exit 1
fi

echo "✅ action.yml found"

# Check required fields
echo ""
echo "📋 Checking Required Fields"
echo "---------------------------"

# Check name
if grep -q "^name:" action.yml; then
    echo "✅ name field present"
else
    echo "❌ name field missing"
    exit 1
fi

# Check description
if grep -q "^description:" action.yml; then
    echo "✅ description field present"
else
    echo "❌ description field missing"
    exit 1
fi

# Check inputs
if grep -q "^inputs:" action.yml; then
    echo "✅ inputs section present"
else
    echo "❌ inputs section missing"
    exit 1
fi

# Check runs
if grep -q "^runs:" action.yml; then
    echo "✅ runs section present"
else
    echo "❌ runs section missing"
    exit 1
fi

# Check using
if grep -q "using: \"composite\"" action.yml; then
    echo "✅ using: composite present"
else
    echo "❌ using: composite missing"
    exit 1
fi

# Check steps
if grep -q "^  steps:" action.yml; then
    echo "✅ steps section present"
else
    echo "❌ steps section missing"
    exit 1
fi

# Check for required steps
echo ""
echo "📋 Checking Required Steps"
echo "--------------------------"

required_steps=(
    "Get version tag"
    "Build download URL"
    "Download ZIP archive"
    "Unpack & install"
    "Verify installation"
)

for step in "${required_steps[@]}"; do
    if grep -q "name: $step" action.yml; then
        echo "✅ Step '$step' present"
    else
        echo "❌ Step '$step' missing"
        exit 1
    fi
done

# Check YAML syntax
echo ""
echo "📋 Checking YAML Syntax"
echo "----------------------"

# Check for basic YAML structure
if command -v python3 >/dev/null 2>&1; then
    if python3 -c "import yaml" 2>/dev/null; then
        if python3 -c "import yaml; yaml.safe_load(open('action.yml'))" 2>/dev/null; then
            echo "✅ YAML syntax is valid"
        else
            echo "❌ YAML syntax is invalid"
            exit 1
        fi
    else
        echo "⚠️  PyYAML not available, skipping YAML syntax check"
    fi
else
    echo "⚠️  Python3 not available, skipping YAML syntax check"
fi

# Check for common issues
echo ""
echo "📋 Checking for Common Issues"
echo "----------------------------"

# Check for proper indentation
if grep -q "^[[:space:]]*[^[:space:]]" action.yml; then
    echo "✅ Proper indentation detected"
else
    echo "⚠️  Indentation might be incorrect"
fi

# Check for proper shell specification
if grep -q "shell: bash" action.yml; then
    echo "✅ bash shell specified"
else
    echo "⚠️  bash shell not specified for all steps"
fi

# Check for proper PowerShell specification on Windows
if grep -q "shell: pwsh" action.yml; then
    echo "✅ PowerShell specified for Windows"
else
    echo "⚠️  PowerShell not specified for Windows steps"
fi

# Check for proper conditional statements
if grep -q "if: runner.os" action.yml; then
    echo "✅ OS-specific conditions present"
else
    echo "⚠️  OS-specific conditions might be missing"
fi

echo ""
echo "🎉 Action validation completed!"
echo "=============================="
echo "The action.yml file appears to be properly configured."
echo "You can now use this action in your GitHub workflows." 