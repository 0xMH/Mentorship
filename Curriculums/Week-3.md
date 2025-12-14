---
week: 3
topic: Git Branching Strategies
share_link:
share_updated:
---
# Git Branching: The Art of Not Breaking Everything

> **Your branching strategy isn't about Git. It's about how your team works together.**

Here's the thing about Git branches. Everyone uses them, but most teams never actually _decide_ on a strategy. They just... wing it. And then six months later, you're staring at a repo with 47 stale branches, merge conflicts that make you question your career choices, and a `main` branch that nobody trusts anymore.

Sound familiar?

### Why Branching Strategy Matters

Git gives you branches. Great. But Git doesn't tell you _how_ to use them. That's on you.

**The chaos approach:**
```
main ← random commits from everyone
feature-1 ← abandoned 3 months ago
fix-something ← nobody knows what this fixes
test-branch ← definitely not a test
johns-branch ← John left the company
```

**The strategic approach:**
```
main ← always deployable, protected
develop ← integration branch
feature/user-auth ← clear purpose, short-lived
hotfix/login-crash ← urgent fix, merged quickly
```

The difference? One lets you sleep at night. The other gives you 3 AM Slack messages.

---

## The Big Three Branching Strategies

There's no "perfect" strategy. Only the one that fits your team. Let's break down the most common ones.

### 1. Git Flow

**Best for:** Versioned software, desktop apps, embedded systems, anything you "ship" and install.

Git Flow is the heavyweight champion of branching strategies. It's structured, predictable, and (let's be honest) a bit overkill for most web projects. But it still has its place.

**Important context:** In 2020, Vincent Driessen (the creator of Git Flow) added a note to his original post saying: if your team is doing continuous delivery, use something simpler like GitHub Flow instead.

**The branches:**
- `main` is production code. Tagged releases only.
- `develop` is the integration branch. Features merge here first. (Some teams rename this to `integration` or `next` for clarity.)
- `feature/*` for new features that branch off `develop`.
- `release/*` for prep work before going to production.
- `hotfix/*` for emergency fixes that go straight to `main`.

**The flow:**
```
feature/new-login → develop → release/v1.2 → main
                                    ↓
                              hotfix/crash → main + develop
```

**The good:**
- Clear separation between development and production
- Great for teams that need to support multiple versions simultaneously
- Works well with regulatory requirements and change freezes
- Release branches give you time to stabilize

**The bad:**
- Too many branches to manage
- Merging can become a nightmare (especially with long-lived branches)
- Overkill for continuous deployment
- The `develop` branch can become a dumping ground


**When Git Flow actually makes sense:**
- You're building desktop software or mobile apps with versioned releases
- You need to support multiple versions in production (think routers, IoT devices)
- Your organization has regulatory requirements or scheduled release windows
- You can't control when customers update

**When to skip it:**
- Web apps and SaaS products (use GitHub Flow instead)
- Small teams shipping frequently
- Anything with continuous deployment

**Real talk:** Most teams that adopt Git Flow for web projects end up either abandoning it or simplifying it heavily. If you're deploying multiple times a day, Git Flow will slow you down. It was designed for a world where releases were _events_, not everyday occurrences.

### 2. GitHub Flow

**Best for:** Teams practicing continuous deployment, SaaS products, startups.

GitHub Flow is Git Flow's chill younger sibling. Simple, straightforward, and built for teams that ship fast.

**The branches:**
- `main` is always deployable. Always.
- `feature/*` for everything else.

That's it. Seriously.

**The flow:**
```
main ← feature/add-search ← your work here
  ↑          |
  └── PR ────┘
```

**The rules:**
1. `main` is _always_ deployable
2. Branch off `main` for any change
3. Open a PR when you're ready for review
4. Merge to `main` and deploy immediately

**The good:**
- Dead simple to understand
- Forces you to keep `main` healthy
- Perfect for CI/CD pipelines

**The bad:**
- No staging area for integration testing
- Requires solid automated testing (you _do_ have tests, right?)
- Can be chaotic without PR discipline

**Key insight:** GitHub Flow only works if your team is disciplined about code reviews and automated testing. Without those guardrails, `main` becomes a minefield.

### 3. Trunk-Based Development

**Best for:** High-performing teams, teams with excellent test coverage, Google-scale engineering.

Trunk-based development takes GitHub Flow and cranks it up to eleven. Everyone commits to `main` (the "trunk") directly or through very short-lived branches.

**The philosophy:**
> "If merging is painful, do it more often until it isn't."

**The approach:**
- Branches live for hours, not days
- Feature flags hide incomplete work
- Everyone integrates multiple times per day

**What are feature flags?**
If everyone commits to `main` multiple times a day, but features take days or weeks to build, how do you prevent users from seeing half-finished work? That's where feature flags come in.

Feature flags (also called feature toggles) let you merge incomplete code to `main` without exposing it to users. In it's simplest form, You. can just wrap new features in a simple check:

```
if (featureFlags.newCheckout) {
  showNewCheckout();
} else {
  showOldCheckout();
}
```

You can toggle features on/off in production without deploying new code. This removes the need for long-lived branches entirely. Merge early, merge often, and control visibility separately from deployment.

**The flow:**
```
main ← small commit ← small commit ← small commit
         (yours)       (teammate)      (yours again)
```

**The good:**
- Eliminates merge hell completely
- Forces small, incremental changes
- Catches integration issues immediately

**The bad:**
- Requires mature engineering practices
- Feature flags add complexity
- Not for the faint of heart (or teams without CI)

**Spoiler:** Most teams that _think_ they're doing trunk-based development are actually just committing to `main` without discipline. That's not trunk-based. That's chaos with extra steps.

---

## Choosing Your Strategy

Here's the honest truth. Pick based on your team's reality, not your aspirations.

| Situation | Strategy |
|-----------|----------|
| Scheduled releases, multiple versions | Git Flow |
| Continuous deployment, small team | GitHub Flow |
| Elite team, excellent test coverage | Trunk-Based |
| "We don't really have a strategy" | Start with GitHub Flow |

**The principle:**
> Start simple. Add complexity only when you feel the pain of not having it.

Don't adopt Git Flow because it sounds professional. Don't do trunk-based because Google does it. Pick what works for _your_ team, _today_.

---

## Branch Naming: The Unsung Hero

Bad branch names are like bad variable names. Technically they work, but they make everyone's life harder.

**Bad naming:**
```
fix
test123
johns-stuff
final-final-v2
```

**Good naming:**
```
feature/user-authentication
bugfix/login-redirect-loop
hotfix/payment-timeout
chore/upgrade-dependencies
```

**The pattern:**
```
<type>/<short-description>
```

**Common types:**
- `feature/` for new functionality
- `bugfix/` for fixing broken things
- `hotfix/` for urgent production fixes
- `chore/` for maintenance work
- `docs/` for documentation updates

**Why this matters:**
- You can tell what a branch does at a glance
- Automated tools can categorize branches
- Your future self will thank you

---

## The Golden Rules

No matter which strategy you pick, these rules apply:

1. Protect your main branch. So **no direct** pushes. Ever. Use PRs.
2. Keep branches short-lived since the longer a branch lives, the harder it merges.
3. Delete merged branches as dead branches are confusing branches.
4. Write meaningful commit messages cause "fixed stuff" helps no one.
5. Pull before you push because merge conflicts are easier to handle locally.

---

## What This Week Is Really About

Branching strategies aren't about Git commands. They're about team collaboration. The best strategy is the one your team actually follows.

The goal isn't to pick the "best" strategy. It's to pick one, follow it consistently, and adjust when it stops working.

And remember, a messy Git history is a symptom, not the disease. The real issue is usually communication, not tooling.

---

## Resources

**Branching Strategies:**
- [Git Branching Strategy: A Complete Guide](https://www.datacamp.com/tutorial/git-branching-strategy-guide) - DataCamp's comprehensive overview
- [The Original Git Flow Post](https://nvie.com/posts/a-successful-git-branching-model/) - Vincent Driessen's 2010 classic (read his 2020 note at the top)
- [Atlassian Git Flow Guide](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
- [GitHub Flow Documentation](https://docs.github.com/en/get-started/quickstart/github-flow)
- [Trunk-Based Development](https://trunkbaseddevelopment.com/)

**Comparisons:**
- [Trunk-Based Development vs Git Flow](https://www.toptal.com/software/trunk-based-development-git-flow) - Toptal's in-depth comparison
- [GitFlow, GitHub Flow, Trunk-Based Development](https://steven-giesel.com/blogPost/ff50f268-c0bf-44d8-a5b8-41554ab50ba8) - Side by side breakdown
- [AWS: Git Branching Strategies](https://docs.aws.amazon.com/prescriptive-guidance/latest/choosing-git-branch-approach/git-branching-strategies.html) - Enterprise perspective

**Branch Naming:**
- [Git Branch Naming Conventions Cheatsheet](https://medium.com/@abhay.pixolo/naming-conventions-for-git-branches-a-cheatsheet-8549feca2534)
- [Conventional Branch](https://conventional-branch.github.io/) - A standardized spec

**Branch Protection:**
- [GitHub Docs: Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule)

**Git Fundamentals:**
- [Pro Git Book - Branching](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell)
