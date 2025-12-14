---
week: 3
topic: Git Branching Strategies
---

## Overview
This week focuses on understanding different Git branching strategies and when to use them. You'll learn Git Flow, GitHub Flow, and trunk-based development, then apply these concepts to real repositories.

---

## Tasks

### 1. Understanding Branching Strategies
Learn the major branching strategies used by development teams worldwide.

#### Learning Resources
**Video Learner?**
- [ ] Watch [Git Flow vs GitHub Flow](https://www.youtube.com/watch?v=gW6dFpTMk8s) (10 mins)
- [ ] Watch [Trunk-Based Development Explained](https://www.youtube.com/watch?v=v4Ijkq6Myfc) (8 mins)

**Prefer Reading?**
- [ ] Read [Git Branching Strategy: A Complete Guide](https://www.datacamp.com/tutorial/git-branching-strategy-guide) - Great overview of all strategies
- [ ] Read [Atlassian Git Flow Guide](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
- [ ] Read [GitHub Flow Documentation](https://docs.github.com/en/get-started/quickstart/github-flow)
- [ ] Read [Trunk-Based Development](https://trunkbaseddevelopment.com/) - Focus on the "Introduction" section
- [ ] Read [The Original Git Flow Post](https://nvie.com/posts/a-successful-git-branching-model/) - Vincent Driessen's classic (and his 2020 reflection on it)

**Key Concepts to Understand:**
- What problem does each strategy solve?
- When would you choose Git Flow over GitHub Flow?
- Why do high-performing teams prefer trunk-based development?
- What are feature flags and how do they enable trunk-based workflows?

---

### 2. Branch Naming Conventions
Master the art of naming branches so your teammates don't hate you.

#### Learning Resources
**Prefer Reading?**
- [ ] Read [Git Branch Naming Conventions](https://medium.com/@abhay.pixolo/naming-conventions-for-git-branches-a-cheatsheet-8549feca2534) - Quick cheatsheet
- [ ] Read [Best Practices for Naming Git Branches](https://tilburgsciencehub.com/topics/automation/version-control/advanced-git/naming-git-branches/)
- [ ] Read [Conventional Branch Spec](https://conventional-branch.github.io/) - If you want to get fancy

#### Practice Goals
- [ ] Write down your team's branch naming convention (or create one if you don't have one)
- [ ] Practice creating branches with proper prefixes: `feature/`, `bugfix/`, `hotfix/`
- [ ] Delete old branches you no longer need in your repositories

**Naming Pattern to Follow:**
```
<type>/<short-description>
```

Examples: `feature/user-auth`, `bugfix/login-crash`, `hotfix/payment-timeout`

---

### 3. Hands-On Practice
Apply what you've learned to a real repository.

#### Practice Goals
- [ ] Open your "git-practice" repository from last week
- [ ] Simulate a GitHub Flow workflow:
  - [ ] Create a `feature/add-about-page` branch
  - [ ] Make changes and commit them
  - [ ] Push the branch to GitHub
  - [ ] Open a Pull Request
  - [ ] Merge the PR and delete the branch
- [ ] Practice protecting your main branch:
  - [ ] Go to Settings > Branches in your repository
  - [ ] Add a branch protection rule for `main`
  - [ ] Require pull requests before merging
  - [ ] Read [GitHub Docs: Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule) if you get stuck


---

## Extra Reading (Optional)
If you want to go deeper:
- [ ] [Trunk-Based Development vs Git Flow](https://www.toptal.com/software/trunk-based-development-git-flow) - Toptal's deep comparison
- [ ] [GitFlow, GitHub Flow, Trunk-Based Development Explained](https://steven-giesel.com/blogPost/ff50f268-c0bf-44d8-a5b8-41554ab50ba8) - Steven Giesel's breakdown
- [ ] [AWS Guide: Git Branching Strategies](https://docs.aws.amazon.com/prescriptive-guidance/latest/choosing-git-branch-approach/git-branching-strategies.html) - Enterprise perspective

---

## Reference
- [[Curriculums/Week-3|Week 3 Curriculum]]
