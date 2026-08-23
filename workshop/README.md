# Student Lab: Git Workshop & Conflict Resolution

Welcome to the interactive Git lab. In this exercise, you will practice reverting local commits and intentionally cause and resolve merge conflicts safely without impacting the `main` branch. 

**Grading Note:** You will document your work in a Markdown file with screenshots so your instructor can easily review your progress.

---

## Part 0: Workspace Setup & Submission Template

### 1. Create Your Personal Base Branch

To avoid interfering with branch protection rules or other students, create your own isolated base branch.

```bash
git checkout -b <your_student_id>_base_branch main

```

### 2. Create Your Personal Grading Folder

Identify your section folder (`001/` for Christine's section, `002/` for Bahman's section).
Inside that folder, create a directory formatted as `<student_id>_<first_name>_<last_name>`.
*Example:* `001/2131595_nicholas_martoccia`

### 3. Create Your Submission File

Inside your personal folder, create a file named `submission.md`. Copy and paste the following template into it. You will fill this out as you complete the lab.

```

# Git Lab Submission

**Name:** [Your Name]
**Student ID:** [Your ID]

## Exercise 1: Local Revert

**Screenshot of leaked secret in Git log:**


**Screenshot of clean Git log after soft reset:**


## Exercise 2: Merge Resolution

**Screenshot of merge commit graph:**


## Exercise 3: Rebase Resolution

**Original Feature Commit Hash:** `[Paste old 7-character hash here]`
**New Feature Commit Hash:** `[Paste new 7-character hash here]`

**Screenshot of rebased commit graph:**


## Exercise 4: Pull Request

**Screenshot of your opened Pull Request:**

```

---

## Part 1: The "Oops" Moment (Local Revert)

**1. Make a Mistake**
Inside your personal folder, create a file called `config.env`. Add a dummy secret: `API_KEY=SUPER_SECRET_123`.
Stage and commit the file.

```bash
git add config.env
git commit -m "Add API config"

```

**2. Audit and Screenshot**
Run `git log --oneline`. Take a screenshot showing your secret commit in the history. Save it as `leaked_secret.png` in your folder.

**3. The Rescue**
Run a soft reset to undo the commit without losing your file changes.

```bash
git reset --soft HEAD~1

```

Open `config.env`, change the text to `API_KEY=YOUR_KEY_HERE`, and commit again.

```bash
git add config.env
git commit -m "Add safe API config"

```

**4. Final Audit**
Run `git log --oneline` again. Take a screenshot showing the clean history and save it as `clean_history.png`.

---

## Part 2: Resolving a Conflict via Merge

**1. Create the Feature Branch**

```bash
git checkout -b <your_student_id>_feature_merge <your_student_id>_base_branch

```

Create a file named `merge_conflict.txt` in your personal folder. Add the text: `This is my feature merge update.`
Save and commit it:

```bash
git add .
git commit -m "Add feature update for merge"

```

**2. Create the Competing Branch**
Return to your base branch, then create a second branch.

```bash
git checkout <your_student_id>_base_branch
git checkout -b <your_student_id>_competing_merge <your_student_id>_base_branch

```

Create the *exact same file* (`merge_conflict.txt`) in your folder. Add conflicting text: `This is my competing merge update.`
Save and commit it:

```bash
git add .
git commit -m "Add competing update for merge"

```

**3. Trigger and Resolve the Merge**
You are currently on the `competing_merge` branch. Merge your feature branch *into* it.

```bash
git merge <your_student_id>_feature_merge

```

Git will pause due to a conflict. Open `merge_conflict.txt`, delete the `<<<<<<<` and `>>>>>>>` markers, combine the text into a single resolved sentence, and complete the merge.

```bash
git add .
git commit -m "Resolved merge conflict between feature and competing branches"

```

**4. Document Your Work**
Run `git log --oneline --graph`. Take a screenshot of the diamond-shaped graph and save it as `merge_graph.png`.

---

## Part 3: Resolving a Conflict via Rebase

**1. Create the Feature Branch**
Return to your base branch and create a new feature branch.

```bash
git checkout <your_student_id>_base_branch
git checkout -b <your_student_id>_feature_rebase <your_student_id>_base_branch

```

Create `rebase_conflict.txt`. Add the text: `Feature rebase update.` Save and commit.

```bash
git add .
git commit -m "Add feature update for rebase"

```

**Important:** Run `git log --oneline` and copy the 7-character hash of this commit. Paste it into your `submission.md` file!

**2. Create the Competing Branch**
Return to your base branch, then create the competing branch.

```bash
git checkout <your_student_id>_base_branch
git checkout -b <your_student_id>_competing_rebase <your_student_id>_base_branch

```

Create `rebase_conflict.txt` with conflicting text: `Competing rebase update.` Save and commit.

```bash
git add .
git commit -m "Add competing update for rebase"

```

**3. Trigger and Resolve the Rebase**
Switch back to your feature branch and rebase it onto your competing branch.

```bash
git checkout <your_student_id>_feature_rebase
git rebase <your_student_id>_competing_rebase

```

Git will pause. Open `rebase_conflict.txt`, resolve the markers, save, and continue.

```bash
git add .
git rebase --continue

```

**4. Document Your Work**
Run `git log --oneline --graph`. Take a screenshot of the straight-line graph and save it as `rebase_graph.png`.
Look at the new hash for your feature commit and paste it into `submission.md`.

---

## Part 4: Submission & Pull Request

It is time to wrap up your work and submit it for grading by opening a Pull Request (PR) against the main repository.

**1. Consolidate Your Work**
Merge your completed feature branches back into your isolated base branch.

```bash
git checkout <your_student_id>_base_branch
git merge <your_student_id>_competing_merge
git merge <your_student_id>_feature_rebase

```

**2. Double-Check Your Folder**
Ensure your personal folder (e.g., `001/2131595_nicholas_martoccia/`) contains:

* `config.env`
* `merge_conflict.txt`
* `rebase_conflict.txt`
* Your `.png` screenshots
* Your filled-out `submission.md`

**3. Push to Remote**
Push your completed base branch up to the remote repository.

```bash
git push -u origin <your_student_id>_base_branch

```

**4. Open the Pull Request (PR)**

1. Go to the repository URL in your web browser.
2. You should see a prompt saying your branch had recent pushes. Click **"Compare & pull request"**. (Alternatively, go to the **Pull Requests** tab and click **New pull request**).
3. Set the **base** branch to `main` and the **compare** branch to `<your_student_id>_base_branch`.
4. Set the PR Title to: `Submission: [Your First & Last Name] - [Your Student ID]`.
5. Click **Create pull request**.
6. Take a final screenshot of your successfully opened Pull Request page, name it `pull_request.png`, and upload it to your PR or add it to your folder.

```

*(Note: I added spaces between the backticks in the nested `markdown` block under step 3 so it wouldn't break the code block formatting here. When you paste this into your file, simply remove those spaces so it reads as standard triple backticks!)*

```