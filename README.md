# Git CLI Workshop - Champlain College 2026

This repository contains everything you need to start working with the Git CLI. There is extra material for students who want to learn more about shell customization and advanced Git workflows.

## Environment Setup Options

Choose **one** of the following options to work on the workshop exercises.

### Option A: Local Environment (macOS, Linux, or Windows with WSL)

If you already have a Unix-like environment configured, you can run the exercises directly on your machine.

**Prerequisites:**

* **macOS / Linux:** Terminal with `git` installed
* **Windows:** [WSL 2](https://www.google.com/search?q=https://learn.microsoft.com/en-us/windows/wsl/install) configured with your preferred Linux distribution (e.g., Ubuntu) and the **WSL extension** for VS Code
* **Editor:** Visual Studio Code

**Getting Started:**

1. **macOS / Linux:** Open this repository folder in VS Code (`code .`) and open the integrated terminal.
2. **Windows (WSL):**
* Open your WSL terminal, navigate to your workspace, and launch VS Code with `code .`
* *Or:* Open VS Code in Windows, press `Ctrl+Shift+P`, select **WSL: Connect to WSL**, and open the cloned folder.


3. Verify your installation by running `git --version` in your terminal.

---

### Option B: Dev Container (Recommended for All Platforms)

If you prefer not to configure a local environment, use the pre-configured development container with all tools pre-installed.

**Prerequisites:**

* Visual Studio Code
* [Docker Desktop](https://www.google.com/search?q=https://www.docker.com/products/docker-desktop/) (running)
* [Dev Containers extension](https://www.google.com/search?q=https://marketplace.visualstudio.com/items%3FitemName%3Dms-vscode-remote.remote-containers) for VS Code

**Getting Started:**

1. Open this repository in VS Code.
2. When prompted, click **Reopen in Container** (or press `Ctrl+Shift+P` / `Cmd+Shift+P` → select **Dev Containers: Reopen in Container**).
3. Wait for the container build to complete on first launch.

---

## Workshop Contents

* [Git CLI Essentials](https://www.google.com/search?q=%23git-cli-essentials)
* [Why CLI Matters](https://www.google.com/search?q=%23why-command-line-interface-matters)
* [Shell Customization Guide](https://www.google.com/search?q=./shell-profiles/README.md)
* [Practice Exercises](https://www.google.com/search?q=./exercises/README.md)

## Git CLI Essentials

### What is Git CLI?

Git CLI (Command Line Interface) is the original and most powerful way to interact with Git. While graphical interfaces exist, the command line provides:

* **Complete Access**: Every Git feature is available
* **Speed**: Faster than GUI operations
* **Automation**: Scriptable for workflows
* **Universality**: Works on any system
* **Professional Standard**: Industry expectation

### Why Command Line Interface Matters

#### 1. **Universal Availability**

CLI works everywhere—servers, containers, remote systems, and any operating system.

#### 2. **Complete Feature Set**

Every Git operation is available through CLI. GUIs often hide advanced features.

#### 3. **Automation & Scripting**

```bash
# Automate repetitive tasks
git add . && git commit -m "Auto-update: $(date)" && git push

```

#### 4. **Performance**

CLI operations are typically faster than their GUI counterparts.

#### 5. **Professional Development**

Most development workflows, CI/CD pipelines, and DevOps tools use CLI.

#### 6. **Troubleshooting**

When things go wrong, CLI provides detailed error messages and recovery options.

## Essential Git Commands

### Configuration

```bash
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch name
git config --global init.defaultBranch main

# Set preferred editor
git config --global core.editor "code --wait"

```

### Repository Basics

```bash
# Initialize a new repository
git init

# Clone an existing repository
git clone <repository-url>

# Check repository status
git status

# View commit history
git log --oneline --graph --decorate

```

### Working with Files

```bash
# Stage files for commit
git add <file>
git add .  # Stage all changes

# Commit changes
git commit -m "Your commit message"

# View changes
git diff           # Unstaged changes
git diff --staged  # Staged changes

```

### Branching and Merging

```bash
# Create and switch to new branch
git checkout -b <branch-name>

# Switch branches
git checkout <branch-name>
git switch <branch-name>  # Modern alternative

# List branches
git branch -a

# Merge branches
git merge <branch-name>

# Delete branch
git branch -d <branch-name>

```

### Remote Operations

```bash
# Add remote repository
git remote add origin <repository-url>

# Push changes
git push origin <branch-name>

# Pull changes
git pull origin <branch-name>

# Fetch changes without merging
git fetch origin

```

### Advanced Operations

```bash
# Interactive rebase
git rebase -i HEAD~3

# Stash changes temporarily
git stash
git stash pop

# Cherry-pick commits
git cherry-pick <commit-hash>

# Reset changes
git reset --soft HEAD~1   # Keep changes staged
git reset --hard HEAD~1   # Discard changes completely

```

## Git Workflow Examples

### Feature Development Workflow

```bash
# 1. Start from main branch
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/user-authentication

# 3. Make changes and commit
git add .
git commit -m "Add user login functionality"

# 4. Push feature branch
git push origin feature/user-authentication

# 5. Create pull request (via GitHub CLI or web)
gh pr create --title "Add user authentication" --body "Implements login/logout"

# 6. After review, merge and cleanup
git checkout main
git pull origin main
git branch -d feature/user-authentication

```

### Hotfix Workflow

```bash
# 1. Create hotfix branch from main
git checkout main
git checkout -b hotfix/security-patch

# 2. Fix issue and commit
git add .
git commit -m "Fix security vulnerability in auth module"

# 3. Push and create urgent PR
git push origin hotfix/security-patch
gh pr create --title "URGENT: Security patch" --body "Fixes CVE-2025-xxx"

```

## Git Configuration Best Practices

### Essential Aliases

```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

```

### Useful Git Settings

```bash
# Enable automatic line ending conversion
git config --global core.autocrlf input  # For Mac/Linux/WSL
git config --global core.autocrlf true   # For native Windows (PowerShell/CMD)

# Enable colored output
git config --global color.ui auto

# Set up default push behavior
git config --global push.default simple

# Enable git rerere (reuse recorded resolution)
git config --global rerere.enabled true

```

## Learning Resources

### Official Documentation

* [Git Official Documentation](https://git-scm.com/doc)
* [Pro Git Book](https://git-scm.com/book) (Free online)

### Interactive Learning

* [Learn Git Branching](https://learngitbranching.js.org/)
* [GitHub Skills](https://skills.github.com/)

### Advanced Topics

* [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
* [Git Workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)

## Shell Customization

This workshop includes shell customization profiles for both Bash and Zsh. Check out the [Shell Profiles Guide](https://www.google.com/search?q=./shell-profiles/README.md) to:

* Install shell themes
* Add aliases and functions
* Set up auto-completion and syntax highlighting
* Configure environments across Linux, macOS, and WSL
