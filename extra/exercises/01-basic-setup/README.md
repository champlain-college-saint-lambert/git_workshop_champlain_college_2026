# Exercise 1: Basic Git Setup

**Objective**: Configure Git for the first time and verify your setup.
- All configuration v- Local config file**: `.git/config` (in repository)

## Next Stepsfied

## Key ConceptsTime**: 10-15 minutes

**Difficulty**: Beginner

## What You'll Learn

- How to configure Git with your identity
- Essential Git configuration options
- How to verify your Git setup
- Basic Git command structure

## Tasks

### Task 1: Set Your Identity

Git needs to know who you are for commit attribution.

```bash
# Set your name (replace with your actual name)
git config --global user.name "Your Full Name"

# Set your email (replace with your actual email)
git config --global user.email "your.email@example.com"
```

### Task 2: Configure Essential Settings

```bash
# Set the default branch name to 'main'
git config --global init.defaultBranch main

# Set your preferred editor (VS Code)
git config --global core.editor "code --wait"

# Enable colored output
git config --global color.ui auto

# Set up automatic line ending conversion
git config --global core.autocrlf input  # For Mac/Linux
# git config --global core.autocrlf true   # For Windows
```

### Task 3: Verify Your Configuration

```bash
# View all your Git configuration
git config --list

# View just the user settings
git config --global --get user.name
git config --global --get user.email

# View Git version
git --version
```

### Task 4: Set Up Some Useful Aliases

```bash
# Status shortcut
git config --global alias.st status

# Checkout shortcut
git config --global alias.co checkout

# Branch shortcut
git config --global alias.br branch

# Commit shortcut
git config --global alias.ci commit

# Enhanced log
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

## Validation

Run the validation script to check your work:

```bash
./validate.sh
```

Or manually verify by checking:

1. Your name is set: `git config --global --get user.name`
2. Your email is set: `git config --global --get user.email`
3. Default branch is main: `git config --global --get init.defaultBranch`
4. Aliases work: `git st` should show "fatal: not a git repository" (expected in non-repo)

## Success Criteria

- [ ] Git user name configured
- [ ] Git user email configured
- [ ] Default branch set to 'main'
- [ ] Editor set to VS Code
- [ ] Color output enabled
- [ ] Basic aliases created
- [ ] All configuration verified

## 💡 Key Concepts

### Global vs Local Configuration

- `--global`: Applies to all repositories for your user
- `--local`: Applies only to the current repository
- No flag: Same as `--local`

### Configuration Priority

Git checks configuration in this order:
1. Local repository (`.git/config`)
2. Global user (`~/.gitconfig`)
3. System-wide (`/etc/gitconfig`)

### Common Configuration Locations

- **Global config file**: `~/.gitconfig`
- **Local config file**: `.git/config` (in repository)

## Next Steps

Once you've completed this exercise:
1. Proceed to [Exercise 2: Creating Your First Repository](../02-first-repo/README.md)
2. Keep your configuration handy - you'll use it throughout the workshop

## Additional Resources

- [Git Configuration Documentation](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)
- [Git Aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases)

---

**Congratulations!** You've configured Git for the first time. This setup will be used for all your future Git work.
