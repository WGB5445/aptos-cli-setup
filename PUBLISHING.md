# Publishing Guide

This guide explains how to publish this repository as a GitHub Action.

## Current Status

✅ **Ready to publish!** The repository structure is already compatible with GitHub Actions.

## Publishing Options

### Option 1: Direct Repository Usage (Recommended)

Users can use your action directly without publishing to the marketplace:

```yaml
- name: Setup Aptos CLI
  uses: your-username/aptos-cli-setup@main
```

**Steps:**
1. Push your code to GitHub
2. Update the README.md to replace `WGB5445` with your actual GitHub username
3. That's it! Users can start using it immediately

### Option 2: GitHub Marketplace (Optional)

To publish to the GitHub Marketplace for better discoverability:

**Prerequisites:**
- Repository must be public
- Repository must have a valid license
- Repository must have a detailed README

**Steps:**
1. Go to your repository on GitHub
2. Click "Settings" tab
3. Scroll down to "Features" section
4. Check "Allow GitHub Actions to be created by GitHub Marketplace"
5. Click "Save"
6. Go to "Actions" tab
7. Click "Publish to Marketplace"
8. Fill in the required information:
   - Action name: "Setup Aptos CLI"
   - Description: "Download and install Aptos CLI on CI environments"
   - Category: "Development"
   - Icon: Upload an appropriate icon
   - Screenshots: Add usage examples
   - Release notes: Describe the action

## Repository Structure

Your repository already has the correct structure:

```
aptos-cli-setup/
├── action.yml          # Action definition
├── README.md           # Documentation
├── LICENSE             # MIT License
├── .github/
│   └── workflows/
│       ├── test.yml    # Test workflow
│       └── example.yml # Example usage
├── test-local.sh       # Local testing
└── validate-action.sh  # Validation script
```

## Usage Examples

### Basic Usage
```yaml
- name: Setup Aptos CLI
  uses: WGB5445/aptos-cli-setup@main
```

### With Specific Version
```yaml
- name: Setup Aptos CLI
  uses: WGB5445/aptos-cli-setup@main
  with:
    version: "7.6.0"
```

### With Specific Branch/Tag
```yaml
- name: Setup Aptos CLI
  uses: WGB5445/aptos-cli-setup@v1.0.0  # Use a specific tag
```

## Versioning Strategy

### For Direct Usage
- Users can use `@main` for the latest version
- Users can use `@v1.0.0` for specific versions (after you create tags)

### For Marketplace
- Create releases with semantic versioning (v1.0.0, v1.1.0, etc.)
- Each release should have a corresponding tag

## Testing Before Publishing

1. **Local Testing:**
   ```bash
   ./test-local.sh
   ./validate-action.sh
   ```

2. **GitHub Actions Testing:**
   - Push to GitHub
   - Check that the test workflow runs successfully
   - Test on different platforms (Linux, macOS, Windows)

3. **Integration Testing:**
   - Create a test repository
   - Use your action in a workflow
   - Verify it works as expected

## Maintenance

### Regular Updates
- Monitor Aptos CLI releases
- Update the default version in README when needed
- Test with new Aptos CLI versions

### Issue Management
- Respond to issues promptly
- Provide clear documentation
- Consider adding more examples

## Security Considerations

- The action downloads from official Aptos releases
- No custom code execution beyond CLI installation
- Uses official GitHub Actions runners
- MIT license allows commercial use

## Next Steps

1. ✅ Replace `WGB5445` in README.md with your actual GitHub username (already done)
2. Push to GitHub
3. Test the action in a real workflow
4. Consider publishing to Marketplace for better discoverability
5. Share with the Aptos community!

## Support

If you need help:
- Check the [GitHub Actions documentation](https://docs.github.com/en/actions)
- Review the [GitHub Marketplace guidelines](https://docs.github.com/en/actions/creating-actions/publishing-actions-in-github-marketplace)
- Open an issue in this repository 