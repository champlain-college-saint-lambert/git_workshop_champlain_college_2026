# Shell Customization Profiles

Your terminal is your workspace, it is common for people to spend a lot of time in their terminal, having a well-configured terminal can make your workflow more efficient and enjoyable. This directory provides pre-configured shell profiles for Bash and Zsh that enhance your terminal experience with features like syntax highlighting, auto-completion, Git integration, and more.

## Quick Installation

### Prerequisites

The installer will automatically detect your system and install required packages:
- **Zsh** (if not present)
- **Git** (if not present) 
- **curl/wget** (for downloading components)
- **Font packages** - Including Powerline fonts, Font Awesome, and FiraCode Nerd Font for proper icon display
- **fontconfig** - Font management system for Linux

Optional components (will be offered during installation):
- **Oh My Zsh** - Enhanced Zsh framework
- **Starship** - Modern cross-shell prompt (auto-configured in developer/poweruser/git-focused profiles)
- **fzf** - Fuzzy finder for enhanced search (auto-configured with advanced styling)
- **bat** - Syntax highlighting for file previews
- **fd** - Fast file finder

### Icon and Font Support

The installer automatically sets up proper font support for terminal icons and symbols. If you see boxes (□) or question marks (?) instead of icons:

1. **Test icon support**: Run `./test-icons.sh` to verify font installation
2. **Configure your terminal**: Set your terminal font to "FiraCode Nerd Font" or another Nerd Font
3. **VS Code users**: Set `Terminal › Integrated: Font Family` to `FiraCode Nerd Font` in settings

### Testing and Verification

- **Icon Display**: Use `./test-icons.sh` to verify that fonts and icons display correctly
- **Profile Functionality**: All profiles include built-in verification - they will show status information when loaded
- **Ctrl+T Functionality**: fzf key bindings (Ctrl+T for files, Ctrl+R for history, Alt+C for directories) are automatically tested during profile loading

### Interactive Installation

```bash
# Clone this repository and navigate to shell-profiles
cd shell-profiles

# Run the interactive installer (detects system and installs prerequisites)
./install.sh

# Or install a specific profile directly
./install.sh git-focused
```

### Automated Installation

```bash
# Install with all optional components (no prompts)
./install.sh git-focused --auto

# Install with minimal dependencies only
./install.sh minimal --minimal-deps

# Get help
./install.sh --help
```

### Windows Users (WSL/Git Bash/MSYS2)

If you're on Windows and get a "bad interpreter" error with `^M` characters:

```bash
# Fix line endings using sed
sed -i 's/\r$//' *.sh profiles/*.sh

# Then run the installer
./install.sh
```

## What's Included

```
shell-profiles/
├── install.sh                 # Interactive installer script
├── test-icons.sh              # Font and icon verification tool
├── profiles/
│   ├── minimal.sh             # Clean, fast profile
│   ├── developer.sh           # Developer-focused setup
│   ├── poweruser.sh           # Feature-rich configuration
│   └── git-focused.sh         # Git workflow optimized
├── themes/
│   ├── starship.toml          # Starship prompt theme
│   ├── oh-my-zsh-custom.zsh   # Oh My Zsh customizations
│   └── bash-colors.sh         # Bash color schemes
├── configs/
│   ├── .gitconfig             # Enhanced Git configuration
│   ├── .vimrc                 # Vim configuration
│   └── .tmux.conf             # Tmux configuration
└── README.md                  # This file
```

## Profile Options

### 1. Minimal Profile (`minimal.sh`)
Perfect for servers and lightweight environments.

**Features:**
- Essential aliases
- Basic Git shortcuts
- Minimal prompt
- Fast startup

**Best for:** Servers, SSH sessions, older hardware

### 2. Developer Profile (`developer.sh`)
Balanced setup for daily development work.

**Features:**
- Git aliases and functions
- Directory navigation shortcuts
- Syntax highlighting
- Auto-completion
- Modern prompt with Git status
- Auto-configures Starship if installed
- Enhanced fzf integration

**Best for:** Day-to-day development, coding projects

### 3. Power User Profile (`poweruser.sh`)
Feature-rich setup with all the bells and whistles.

**Features:**
- Advanced Git workflows
- Fuzzy finding (fzf) with enhanced styling
- Enhanced history search
- Auto-configures Starship if installed
- Custom functions
- Beautiful prompt
- Auto-suggestions

**Best for:** Power users, terminal enthusiasts

### 4. Git-Focused Profile (`git-focused.sh`)
Specialized for Git-heavy workflows.

**Features:**
- Comprehensive Git aliases
- Branch management functions
- Commit helpers
- Merge conflict tools
- Git-aware prompt
- Auto-configures Starship if installed
- Git-aware fzf integration
- Directory bookmarks (~src → ~/Documents/GitHub)

**Best for:** Git power users, DevOps engineers

## Installation Options

### Interactive Installation
```bash
./install.sh
```

The installer will:
1. Detect your shell (Bash/Zsh)
2. Show available profiles
3. Let you choose what to install
4. Backup existing configurations
5. Apply your chosen profile

### Manual Installation

#### For Zsh users:
```bash
# Choose a profile and source it
source profiles/developer.sh

# Add to your .zshrc for permanent installation
echo "source $(pwd)/profiles/developer.sh" >> ~/.zshrc
```

#### For Bash users:
```bash
# Choose a profile and source it
source profiles/developer.sh

# Add to your .bashrc for permanent installation
echo "source $(pwd)/profiles/developer.sh" >> ~/.bashrc
```

## Customization

### Adding Your Own Aliases
Create a `personal.sh` file in the profiles directory:

```bash
# personal.sh
alias myproject="cd ~/projects/my-awesome-project"
alias deploy="git push && ssh server 'cd /app && git pull && restart'"

# Custom Git function
function gcom() {
    git add .
    git commit -m "$1"
    git push
}
```

Then include it in your profile:
```bash
source ~/shell-profiles/profiles/personal.sh
```

### Modifying Themes
Edit the theme files in the `themes/` directory:

- `starship.toml` - Modern cross-shell prompt
- `oh-my-zsh-custom.zsh` - Zsh-specific customizations
- `bash-colors.sh` - Bash color schemes

## Advanced Features

### Git Workflow Functions
```bash
# Quick commit and push
gcp "commit message"

# Create and switch to new branch
gnb feature/new-feature

# Interactive rebase last 3 commits
grb 3

# Show git log with graph
glog
```

### Directory Navigation
```bash
# Quick navigation
..      # cd ..
...     # cd ../..
....    # cd ../../..

# Directory shortcuts
cdp     # cd to projects directory
cdd     # cd to downloads
```

### Search and Find
```bash
# Find files by name
ff filename

# Search in files
gg "search term"

# Interactive file finder (requires fzf)
fzf
```

## Cross-Platform Compatibility

### macOS Considerations
- Uses `brew` for package installation when available
- Configures macOS-specific aliases
- Sets up proper PATH for Homebrew

### Linux Considerations
- Uses appropriate package manager (apt, yum, etc.)
- Configures Linux-specific aliases
- Works with both desktop and server environments

### Automatic Detection
The profiles automatically detect your operating system and adjust accordingly:

```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS specific settings
    alias ls='ls -G'
    export PATH="/opt/homebrew/bin:$PATH"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux specific settings
    alias ls='ls --color=auto'
fi
```

## Startup Configuration

### Automatic Loading
The installer can set up automatic loading by adding source commands to your shell's startup file:

- **Zsh**: `~/.zshrc`
- **Bash**: `~/.bashrc` (Linux) or `~/.bash_profile` (macOS)

### Performance Optimization
- Lazy loading for heavy features
- Conditional loading based on environment
- Fast startup times

### Example Startup Sequence
```bash
# 1. Load core profile
source ~/shell-profiles/profiles/developer.sh

# 2. Load local customizations (if exists)
[[ -f ~/shell-profiles/profiles/personal.sh ]] && source ~/shell-profiles/profiles/personal.sh

# 3. Load machine-specific config (if exists)
[[ -f ~/.local-shell-config ]] && source ~/.local-shell-config
```

## Updating Profiles

### Keeping Profiles Updated
```bash
# Update from repository
git pull origin main

# Re-run installer to apply updates
./install.sh --update
```

### Version Management
Profiles include version information and changelog tracking:

```bash
# Check profile version
profile_version

# Show what's new
profile_changelog
```

## Troubleshooting

### Windows Line Ending Issues

**Problem**: Getting "bad interpreter" errors with `^M` characters when running scripts.

**Solution**:
```bash
# Fix line endings manually
sed -i 's/\r$//' *.sh profiles/*.sh

# Then proceed with installation
./install.sh
```

**Alternative manual fixes**:
```bash
# Using dos2unix (if available)
dos2unix *.sh profiles/*.sh

# Using sed
sed -i 's/\r$//' *.sh profiles/*.sh

# Using tr
for file in *.sh profiles/*.sh; do
    tr -d '\r' < "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done
```

### Shell-Specific Issues

- "command not found: shopt" when sourcing `~/.bashrc` from Zsh:
  - This happens when Bash-only commands are present in a file that Zsh is sourcing. Fix by guarding Bash-specific commands in your `~/.bashrc`:

```bash
if [ -n "$BASH_VERSION" ]; then
  shopt -s checkwinsize
  shopt -s histappend
  shopt -s cdspell
fi
```

- Bash completion parse errors: ensure `/usr/share/bash-completion/bash_completion` is only sourced from Bash (see guard above).

- Profile functions/aliases not present: confirm the right profile is sourced and that the file path in your startup file points to the correct location.

### Uninstall / Remove profile from startup
To remove the profile, edit your `~/.bashrc` or `~/.zshrc` and remove the `source` line the installer added, or restore a backup created by the installer.

### Note on Removed Test Scripts
Previous versions included separate test scripts for Ctrl+T functionality (`test-ctrl-t.sh`, `fix-ctrl-t.sh`, etc.). These have been removed as the functionality is now built directly into the profiles themselves. All testing and verification happens automatically during profile loading.

## Advanced tips
- Use `profiles/minimal.sh` on remote servers where startup speed matters.
- For per-repo or per-project customizations, create `profiles/personal.sh` and source it from the profile you installed (or from `~/.bashrc`/`~/.zshrc`).
- If you share the dotfiles across machines, use the repository absolute path variable:

```bash
REPO_DIR="$HOME/git/my-repo/shell-profiles"
echo "source $REPO_DIR/profiles/developer.sh" >> ~/.bashrc
```

## License

These shell profiles are licensed under the MIT License. Feel free to modify and distribute!


