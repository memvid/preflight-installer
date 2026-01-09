# Memvid Installer

Official installer for Memvid (v1).

## What it does

The installer automatically checks for and installs required dependencies, then installs Memvid globally:

- **git** - Version control system
- **node** (LTS) - JavaScript runtime
- **npm** - Package manager (comes with node)
- **memvid** - Installed globally via `npm install -g memvid`

The installer only installs missing tools (no upgrades in v1).

## Supported Platforms

- **macOS** - Uses Homebrew
- **Linux** - Ubuntu/Debian (uses apt)
- **Windows** - Requires winget (Windows Package Manager)

## Installation

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/memvid/preflight-installer/main/install.sh | bash
```

Or download and run:

```bash
chmod +x install.sh
./install.sh
```

### Windows

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/memvid/preflight-installer/main/install.ps1 | iex
```

Or download and run:

```powershell
.\install.ps1
```

## Security

These scripts are open source and readable. Before running, you can:

1. Review the script contents on GitHub
2. Download and inspect locally
3. Run with appropriate permissions

The installer will:
- Show what will be installed before proceeding
- Ask for confirmation before installing anything
- Use only system package managers (no third-party installers)
- Print clear status messages for each step

## Verification

After installation, verify it worked:

```bash
memvid --version
```

## Troubleshooting

If installation fails:

1. Check that you have the required permissions (sudo on Linux, admin on Windows)
2. Ensure your package manager is up to date
3. On Windows, ensure winget is installed (comes with Windows 11, or install from https://aka.ms/getwinget)
4. Check that npm global bin directory is in your PATH

For issues, please open an issue on GitHub.
