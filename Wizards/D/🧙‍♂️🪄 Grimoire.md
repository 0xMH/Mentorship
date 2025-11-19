---
wizard: D
wizard_name: "Wizard D"
wizard_motto: "Deploy with Confidence, Debug with Wisdom"
started_date:
favorite_topics: []
---

# 🧙‍♂️ Wizard D's Grimoire

> *"Deploy with Confidence, Debug with Wisdom"*
>
> Welcome back, Wizard D! Ready to deploy some magic today?

```meta-bind-button
label: ➕ Create New Week
icon: ""
style: primary
actions:
  - type: templaterCreateNote
    templateFile: Templates/Week-Complete-Template.md
    openNote: true
```

---

## 📊 Your Learning Journey at a Glance

```dataviewjs
const studentWeeks = dv.pages('"Wizards/D"')
  .where(p => p.file.path.includes("Week-") && p.file.name === "Tasks");

const completed = studentWeeks.length;
const curriculumWeeks = dv.pages('"Curriculums"')
  .where(p => p.file.name.includes("Week-"));
const total = curriculumWeeks.length;
const progress = total > 0 ? Math.round((completed / total) * 100) : 0;

// Calculate streak (weeks in sequence)
const weekNumbers = studentWeeks.map(p => p.week).sort((a, b) => a - b);
let currentStreak = 0;
for (let i = 0; i < weekNumbers.length; i++) {
  if (i === 0 || weekNumbers[i] === weekNumbers[i-1] + 1) {
    currentStreak++;
  } else {
    currentStreak = 1;
  }
}

dv.header(4, "🎯 Your Stats");
dv.paragraph(`
**📚 Weeks Completed:** ${completed} / ${total}
**⚡ Progress:** ${progress}%
**🔥 Current Streak:** ${currentStreak} week(s)
**🌟 Level:** ${completed < 4 ? 'Apprentice' : completed < 8 ? 'Adept' : completed < 12 ? 'Master' : 'Grand Master'}
`);
```

---

## 🔥 Current Week (In Progress)

```dataviewjs
const currentWeek = dv.pages('"Wizards/D"')
  .where(p => p.file.path.includes("Week-") && p.file.name === "Tasks")
  .sort(p => p.week, 'desc')
  .limit(1);

if (currentWeek.length > 0) {
  const weekNum = currentWeek[0].week;
  const topic = currentWeek[0].topic;
  const tasksLink = dv.fileLink(currentWeek[0].file.path, false, "📝 Tasks");
  const notesPath = currentWeek[0].file.path.replace("Tasks.md", "Notes.md");
  const notesLink = dv.fileLink(notesPath, false, "💭 Notes");

  dv.table(
    ["Week #", "Topic", "Links"],
    [[weekNum, topic, tasksLink + " | " + notesLink]]
  );
} else {
  dv.paragraph("No weeks created yet.");
}
```

---

## All Weeks

```dataviewjs
const allWeeks = dv.pages('"Wizards/D"')
  .where(p => p.file.path.includes("Week-") && p.file.name === "Tasks")
  .sort(p => p.week, 'asc');

const rows = allWeeks.map(p => {
  const tasksLink = dv.fileLink(p.file.path, false, "📝 Tasks");
  const notesPath = p.file.path.replace("Tasks.md", "Notes.md");
  const notesLink = dv.fileLink(notesPath, false, "💭 Notes");

  return [p.week, p.topic, tasksLink + " | " + notesLink];
});

dv.table(
  ["Week #", "Topic", "Links"],
  rows
);
```

---

## 💡 My Learning Insights

> Capture your breakthrough moments and key learnings

```dataview
TABLE WITHOUT ID
  week as "Week",
  topic as "Topic",
  file.link as "Notes"
FROM "Wizards/D"
WHERE type = "notes" AND file.mtime >= date(today) - dur(7 days)
SORT file.mtime DESC
```

---

## Recent Activity

```dataview
TABLE
  week as "Week #",
  topic as "Topic",
  file.mtime as "Last Modified"
FROM "Wizards/D"
WHERE contains(file.path, "Week-") AND file.name = "Tasks"
SORT file.mtime DESC
LIMIT 3
```

---

> *"Every deployment is a lesson. Stay curious, Wizard D!"*
