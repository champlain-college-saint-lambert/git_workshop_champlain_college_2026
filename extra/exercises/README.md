# Git CLI Workshop Exercises

Welcome to the hands-on Git exercises! These exercises are designed to give you practical experience with Git CLI commands and workflows.

## Exercise Categories

### Beginner Exercises
- [Exercise 1: Basic Git Setup](./01-basic-setup/README.md)
- [Exercise 2: Creating Your First Repository](./02-first-repo/README.md)
- [Exercise 3: Basic Add, Commit, Push](./03-basic-workflow/README.md)
- [Exercise 4: Working with Remote Repositories](./04-remotes/README.md)

### Intermediate Exercises
- [Exercise 5: Branching and Merging](./05-branching/README.md)
- [Exercise 6: Resolving Merge Conflicts](./06-conflicts/README.md)
- [Exercise 7: Git Stash and Reset](./07-stash-reset/README.md)
- [Exercise 8: Interactive Rebase](./08-rebase/README.md)

### Advanced Exercises
- [Exercise 9: Git Workflows](./09-workflows/README.md)
- [Exercise 10: Git Hooks and Automation](./10-hooks/README.md)
- [Exercise 11: Advanced Git Operations](./11-advanced/README.md)
- [Exercise 12: Git Best Practices](./12-best-practices/README.md)

## How to Use These Exercises

### Prerequisites
- Git installed on your system
- A GitHub account (for remote exercises)
- Your shell profile loaded (from this workshop)

### Exercise Structure
Each exercise contains:
- **README.md** - Instructions and objectives
- **setup.sh** - Automated setup script (if needed)
- **validate.sh** - Self-check script
- **solution/** - Reference solution

### Getting Started
1. Navigate to an exercise directory
2. Read the README.md for instructions
3. Run setup.sh if present
4. Complete the exercise
5. Run validate.sh to check your work

### Example:
```bash
cd exercises/01-basic-setup
./setup.sh
# Follow instructions in README.md
./validate.sh
```

## Progress Tracking

Track your progress with these commands:

```bash
# See your exercise completion status
./check-progress.sh

# Get hints for current exercise
./get-hint.sh

# Reset an exercise to start over
./reset-exercise.sh <exercise-number>
```

## Getting Help

### During Exercises
- Use `git --help <command>` for command documentation
- Check hints with `./get-hint.sh`
- Review solutions in the `solution/` directories

### Git Workshop Commands
Remember you have these helpful aliases loaded:
```bash
# Quick status and log
gst          # git status
glog         # git log --oneline --graph

# Quick commits
gcom "msg"   # git add . && git commit -m "msg"
gwip         # work in progress commit

# Branch management
gnb name     # create new branch
gco name     # checkout branch
gfinish      # merge to main and cleanup

# Get help
profile_help # show all available commands
```

## Exercise Completion Goals

### Beginner Level (Exercises 1-4)
**Goal**: Understand basic Git operations
- Set up Git configuration
- Create repositories
- Make commits
- Work with remotes

### Intermediate Level (Exercises 5-8)
**Goal**: Master branching and collaboration
- Create and merge branches
- Resolve conflicts
- Use stash and reset
- Rewrite history safely

### Advanced Level (Exercises 9-12)
**Goal**: Professional Git workflows
- Implement Git workflows
- Set up automation
- Master advanced operations
- Follow best practices

## Exercise Notes

### Tips for Success
1. **Read carefully**: Each exercise builds on previous knowledge
2. **Practice**: Don't just read - actually run the commands
3. **Experiment**: Try variations of commands to understand them better
4. **Ask questions**: Use the workshop Discord/discussion forum

### Common Mistakes to Avoid
- Skipping the setup phase
- Not reading error messages carefully
- Rushing through without understanding
- Not using the validation scripts

### Troubleshooting
If you get stuck:
1. Check the hints with `./get-hint.sh`
2. Read the error message carefully
3. Review the solution in `solution/` directory
4. Ask for help from instructors

## Completion Certificate

After completing all exercises, run:
```bash
./generate-certificate.sh
```

This will create a personalized completion certificate with your progress stats!

## Reset Everything

To start completely fresh:
```bash
./reset-all-exercises.sh
```

**Warning**: This will delete all your progress!

---

**Ready to Git started?**

Begin with [Exercise 1: Basic Git Setup](./01-basic-setup/README.md)
