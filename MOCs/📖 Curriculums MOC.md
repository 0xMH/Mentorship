# 📖 DevOps Curriculum Library

> Your complete curriculum reference for the Wizards mentorship program

---

## 📚 All Curriculum Weeks

```dataviewjs
const curriculums = dv.pages('"Curriculums"')
  .where(p => p.week !== undefined)
  .sort(p => p.week, 'asc');

if (curriculums.length > 0) {
  const rows = curriculums.map(p => {
    const weekLink = dv.fileLink(p.file.path, false, `Week ${p.week}`);
    const topic = p.topic || "N/A";

    // Count how many wizards have completed this week
    const wizards = ['G', 'A', 'D', 'L'];
    let completedCount = 0;

    for (const wizard of wizards) {
      const wizardWeek = dv.pages(`"Wizards/${wizard}"`)
        .where(w => w.week === p.week && w.file.name === "Tasks");
      if (wizardWeek.length > 0) completedCount++;
    }

    const completionStatus = `${completedCount} / 4 wizards`;

    return [weekLink, topic, completionStatus];
  });

  dv.table(
    ["Week", "Topic", "Completion"],
    rows
  );
} else {
  dv.paragraph("*No curriculum weeks found.*");
}
```

---

## 📊 Curriculum Usage Overview

```dataviewjs
const totalWeeks = dv.pages('"Curriculums"')
  .where(p => p.week !== undefined).length;

const wizards = ['G', 'A', 'D', 'L'];
let totalCompletions = 0;

for (const wizard of wizards) {
  const completed = dv.pages(`"Wizards/${wizard}"`)
    .where(p => p.file.path.includes("Week-") && p.file.name === "Tasks").length;
  totalCompletions += completed;
}

const totalPossible = totalWeeks * wizards.length;
const utilizationRate = totalPossible > 0 ? Math.round((totalCompletions / totalPossible) * 100) : 0;

dv.paragraph(`
**📚 Total Curriculum Weeks:** ${totalWeeks}
**✅ Total Completions:** ${totalCompletions} / ${totalPossible}
**📈 Utilization Rate:** ${utilizationRate}%
`);
```

---

## 🔍 Quick Access by Week

```dataviewjs
const curriculums = dv.pages('"Curriculums"')
  .where(p => p.week !== undefined)
  .sort(p => p.week, 'asc');

for (const curriculum of curriculums) {
  const weekNum = curriculum.week;
  const topic = curriculum.topic || "N/A";

  dv.header(4, `Week ${weekNum}: ${topic}`);

  // Show which wizards have started/completed this week
  const wizards = ['G', 'A', 'D', 'L'];
  const wizardStatus = [];

  for (const wizard of wizards) {
    const wizardWeek = dv.pages(`"Wizards/${wizard}"`)
      .where(w => w.week === weekNum && w.file.name === "Tasks");

    if (wizardWeek.length > 0) {
      const emoji = wizard === 'G' ? '🌱' : wizard === 'A' ? '⚙️' : wizard === 'D' ? '🚀' : '👑';
      wizardStatus.push(`${emoji} ${wizard}`);
    }
  }

  if (wizardStatus.length > 0) {
    dv.paragraph(`**Wizards on this week:** ${wizardStatus.join(', ')}`);
  } else {
    dv.paragraph(`**Wizards on this week:** None yet`);
  }

  dv.paragraph(`📖 [[${curriculum.file.path}|View Curriculum]]`);
  dv.paragraph("---");
}
```

---

## 🔗 Related

- [[MOCs/📚 Wizards MOC|📚 Wizards Dashboard]]
