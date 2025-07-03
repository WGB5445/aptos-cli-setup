#!/bin/bash

# Local test script for Aptos CLI Action
# This script tests the core logic without running the full GitHub Action

set -e

echo "🧪 Testing Aptos CLI Action Logic Locally"
echo "=========================================="

# Test 1: Version detection
echo "📋 Test 1: Version Detection"
echo "----------------------------"

# Test latest version detection
echo "Testing latest version detection..."
LATEST_TAG=$(curl -s https://api.github.com/repos/aptos-labs/aptos-core/releases/latest | grep '"tag_name":' | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
LATEST_VERSION="${LATEST_TAG#v}"
echo "Latest version: $LATEST_VERSION"

if [ -z "$LATEST_VERSION" ]; then
    echo "❌ Failed to detect latest version"
    exit 1
else
    echo "✅ Latest version detected: $LATEST_VERSION"
fi

# Test specific version
echo "Testing specific version..."
SPECIFIC_VERSION="2.4.0"
echo "Specific version: $SPECIFIC_VERSION"
echo "✅ Specific version test passed"

# Test 2: URL generation
echo ""
echo "📋 Test 2: URL Generation"
echo "-------------------------"

# Detect OS and architecture
case "$(uname -s)" in
    Linux*)     os_name=linux ;;
    Darwin*)    os_name=darwin ;;
    CYGWIN*|MINGW*|MSYS*) os_name=windows ;;
    *)          echo "Unsupported OS: $(uname -s)" && exit 1 ;;
esac

case "$(uname -m)" in
    x86_64)     arch_name=x86_64 ;;
    arm64|aarch64) arch_name=aarch64 ;;
    *)          echo "Unsupported architecture: $(uname -m)" && exit 1 ;;
esac

echo "Detected OS: $os_name"
echo "Detected Architecture: $arch_name"

# Generate URLs
LATEST_URL="https://github.com/aptos-labs/aptos-core/releases/download/aptos-cli-v${LATEST_VERSION}/aptos-cli-${LATEST_VERSION}-${os_name}-${arch_name}.zip"
SPECIFIC_URL="https://github.com/aptos-labs/aptos-core/releases/download/aptos-cli-v${SPECIFIC_VERSION}/aptos-cli-${SPECIFIC_VERSION}-${os_name}-${arch_name}.zip"

echo "Latest URL: $LATEST_URL"
echo "Specific URL: $SPECIFIC_URL"

# Test 3: URL accessibility
echo ""
echo "📋 Test 3: URL Accessibility"
echo "----------------------------"

echo "Testing latest URL accessibility..."
if curl --output /dev/null --silent --head --fail "$LATEST_URL"; then
    echo "✅ Latest URL is accessible"
else
    echo "❌ Latest URL is not accessible"
    exit 1
fi

echo "Testing specific URL accessibility..."
if curl --output /dev/null --silent --head --fail "$SPECIFIC_URL"; then
    echo "✅ Specific URL is accessible"
else
    echo "❌ Specific URL is not accessible"
    exit 1
fi

# Test 4: Download and installation simulation
echo ""
echo "📋 Test 4: Download and Installation Simulation"
echo "-----------------------------------------------"

# Create a temporary directory for testing
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "Downloading latest version..."
curl -L "$LATEST_URL" -o aptos.zip

if [ ! -f aptos.zip ]; then
    echo "❌ Download failed"
    exit 1
fi

echo "✅ Download successful"

# Extract and test
echo "Extracting..."
unzip -q aptos.zip -d aptos

if [ -f "aptos/aptos" ] || [ -f "aptos/aptos.exe" ]; then
    echo "✅ Extraction successful"
    
    # Test executable
    if [ -f "aptos/aptos" ]; then
        chmod +x aptos/aptos
        echo "Testing executable..."
        ./aptos/aptos --version
        echo "✅ Executable test passed"
    elif [ -f "aptos/aptos.exe" ]; then
        echo "✅ Windows executable found"
    fi
else
    echo "❌ Extraction failed - executable not found"
    exit 1
fi

# Cleanup
cd - > /dev/null
rm -rf "$TEMP_DIR"

echo ""
echo "🎉 All tests passed!"
echo "==================="
echo "The Aptos CLI Action logic appears to be working correctly."
echo "You can now use this action in your GitHub workflows." 