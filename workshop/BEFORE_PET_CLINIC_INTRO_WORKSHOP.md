# Student Lab: Pet Clinic Workshop & Branching Setup

## Part 0: Workspace Setup & Submission Template

### 1. Create Your Personal Base Branch

To avoid interfering with branch protection rules or other students, start from `main` and create your own isolated base
branch.

```bash
git checkout main
git pull origin main
git checkout -b <your_student_id>_base_branch main
```

> Note: Specifying main at the end of `git checkout -b` is optional when you are already on the main branch, it defaults
> to the current commit.

### 2. Create Your Submission Template

Copy the `submission.md` file to your personal base branch. This file can be found in workshop/002/2130821 Dylan
Brassard