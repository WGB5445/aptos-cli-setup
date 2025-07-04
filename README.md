# Setup Aptos CLI GitHub Action

A GitHub Action to download and install the Aptos CLI on CI environments (Linux/macOS/Windows, x86_64 & aarch64) and add it to PATH.

## Features

- ✅ **Multi-platform support**: Linux, macOS, and Windows
- ✅ **Multi-architecture support**: x86_64 and aarch64 (ARM64)
- ✅ **Flexible versioning**: Use latest release or specify a specific version
- ✅ **Automatic PATH setup**: CLI is automatically added to PATH for subsequent steps
- ✅ **Installation verification**: Verifies the installation by checking the CLI version
- ✅ **GitHub token required**: Uses GitHub token for API access and movefmt download

## Usage

### Basic Usage (Latest Version)

```yaml
- name: Setup Aptos CLI
  uses: WGB5445/aptos-cli-setup@v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

### Specify a Version

```yaml
- name: Setup Aptos CLI
  uses: WGB5445/aptos-cli-setup@v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    version: "7.5.0"
```

### GitHub Token Required

A GitHub token is required for downloading movefmt:

```yaml
- name: Setup Aptos CLI
  uses: WGB5445/aptos-cli-setup@v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    version: "latest"
```

### Complete Workflow Example

```yaml
name: Test Aptos CLI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        arch: [x64, arm64]
        exclude:
          - os: windows-latest
            arch: arm64  # Windows ARM64 runners are not widely available yet

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Aptos CLI
      uses: WGB5445/aptos-cli-setup@v1
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}

    - name: Test Aptos CLI
      run: |
        aptos --version
        aptos init --help
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `version` | Aptos CLI version (tag). Use 'latest' to automatically fetch the latest release | No | `latest` |
| `install-dir` | Install directory for Aptos CLI (will install to <dir>/bin) | No | `$HOME/.aptoscli` |
| `movefmt-username` | GitHub username for movefmt repository | No | `movebit` |
| `movefmt-repo` | GitHub repository name for movefmt | No | `movefmt` |
| `movefmt-version` | movefmt version to install | No | `1.2.3` |
| `github-token` | GitHub token for API access (required for downloading movefmt) | Yes | - |

## Outputs

This action doesn't produce any outputs, but it:
- Installs the Aptos CLI to `$HOME/.aptos/bin` (Linux/macOS) or `%USERPROFILE%\.aptos\bin` (Windows)
- Adds the installation directory to `PATH` for subsequent steps
- Verifies the installation by running `aptos --version`

## Supported Platforms

| OS | Architecture | Status |
|----|--------------|--------|
| Linux | x86_64 | ✅ Supported |
| Linux | aarch64 | ✅ Supported |
| macOS | x86_64 | ✅ Supported |
| macOS | aarch64 | ✅ Supported |
| Windows | x86_64 | ✅ Supported |
| Windows | aarch64 | ⚠️ Limited support (runners not widely available) |

## Testing

### Local Testing

To test this action locally, you can use [act](https://github.com/nektos/act):

```bash
# Install act
brew install act  # macOS
# or download from https://github.com/nektos/act/releases

# Test the action (replace with your actual repository name)
act -j test
```

### Manual Testing

You can also test the action manually by running the commands locally:

```bash
# Test on macOS/Linux
curl -s https://api.github.com/repos/aptos-labs/aptos-core/releases/latest | grep '"tag_name":' | head -1 | sed -E 's/.*"([^"]+)".*/\1/'

# Download and install manually
curl -L "https://github.com/aptos-labs/aptos-core/releases/download/aptos-cli-v7.5.0/aptos-cli-7.5.0-darwin-x86_64.zip" -o aptos.zip
unzip aptos.zip -d aptos
mkdir -p "$HOME/.aptos/bin"
mv aptos/aptos "$HOME/.aptos/bin/"
export PATH="$HOME/.aptos/bin:$PATH"
aptos --version
```

### GitHub Actions Testing

The repository includes a test workflow (`.github/workflows/test.yml`) that tests the action on multiple platforms and architectures.

## Troubleshooting

### Common Issues

1. **Download fails**: Check if the version exists in the [Aptos releases](https://github.com/aptos-labs/aptos-core/releases)
2. **Unsupported OS/Arch**: The action will fail with a clear error message for unsupported combinations
3. **PATH not set**: The action automatically adds the CLI to PATH, but you can manually add it if needed
4. **GitHub API errors**: The action includes retry logic and better error handling for API rate limits

### GitHub API Issues

If you encounter GitHub API errors, the action now includes:

- **Better error messages**: Clear guidance on what went wrong and how to fix it
- **GitHub token required**: Uses `${{ github.token }}` for API access and movefmt download

**Common causes of API errors:**
- **Missing token**: GitHub token is required for downloading movefmt
- **Rate limiting**: GitHub limits API requests
- **Network issues**: Temporary connectivity problems
- **Repository access**: The repositories might be temporarily unavailable

**Solutions:**
1. **Provide GitHub token**: Always include `github-token: ${{ secrets.GITHUB_TOKEN }}`
2. **Use a specific version**: Instead of `latest`, specify a version like `7.5.0`
3. **Check network**: Ensure your runner has internet access
4. **Check token permissions**: Ensure the token has appropriate permissions

### Debug Mode

To debug issues, you can enable debug logging:

```yaml
- name: Setup Aptos CLI
  uses: WGB5445/aptos-cli-setup@v1
  env:
    ACTIONS_STEP_DEBUG: true
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on multiple platforms
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Related

- [Aptos CLI Documentation](https://aptos.dev/tools/aptos-cli/)
- [Aptos Core Repository](https://github.com/aptos-labs/aptos-core)
- [GitHub Actions Documentation](https://docs.github.com/en/actions) 