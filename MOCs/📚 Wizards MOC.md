# 🧙‍♂️ Wizards Mentorship Dashboard

> Your command center for tracking all wizards' progress and performance

---

## 📊 Program Overview

```dataviewjs
const wizards = ['G', 'A', 'D', 'L'];
const wizardNames = {
  'G': 'Wizard G - Growth',
  'A': 'Wizard A - Automation',
  'D': 'Wizard D - Deploy',
  'L': 'Wizard L - Leadership'
};

let totalCompleted = 0;
let totalPossible = 0;

for (const wizard of wizards) {
  const weeks = dv.pages(`"Wizards/${wizard}"`)
    .where(p => p.file.path.includes("Week-") && p.file.name === "Tasks");
  totalCompleted += weeks.length;
}

const curriculumWeeks = dv.pages('"Curriculums"')
  .where(p => p.file.name.includes("Week-"));
totalPossible = wizards.length * curriculumWeeks.length;

const avgProgress = totalPossible > 0 ? Math.round((totalCompleted / totalPossible) * 100) : 0;

dv.paragraph(`
**👥 Total Wizards:** ${wizards.length}
**📚 Total Weeks Completed:** ${totalCompleted} / ${totalPossible}
**⚡ Average Progress:** ${avgProgress}%
**📖 Curriculum Weeks:** ${curriculumWeeks.length}
`);
```

---

## 🎯 Individual Wizard Progress

```dataviewjs
const wizards = [
  {id: 'G', name: 'Wizard G', motto: 'Growth through Practice', emoji: '🌱'},
  {id: 'A', name: 'Wizard A', motto: 'Automation Excellence', emoji: '⚙️'},
  {id: 'D', name: 'Wizard D', motto: 'Deploy with Confidence', emoji: '🚀'},
  {id: 'L', name: 'Wizard L', motto: 'Learn & Lead', emoji: '👑'}
];

const curriculumWeeks = dv.pages('"Curriculums"')
  .where(p => p.file.name.includes("Week-"));
const totalWeeks = curriculumWeeks.length;

for (const wizard of wizards) {
  const weeks = dv.pages(`"Wizards/${wizard.id}"`)
    .where(p => p.file.path.includes("Week-") && p.file.name === "Tasks")
    .sort(p => p.week, 'asc');

  const completed = weeks.length;
  const progress = totalWeeks > 0 ? Math.round((completed / totalWeeks) * 100) : 0;

  // Calculate streak
  const weekNumbers = weeks.map(p => p.week).array().sort((a, b) => a - b);
  let streak = 0;
  for (let i = 0; i < weekNumbers.length; i++) {
    if (i === 0 || weekNumbers[i] === weekNumbers[i-1] + 1) {
      streak++;
    } else {
      streak = 1;
    }
  }

  // Get current week
  const currentWeek = weeks.sort(p => p.week, 'desc').limit(1);
  const currentWeekNum = currentWeek.length > 0 ? currentWeek[0].week : 'N/A';
  const currentTopic = currentWeek.length > 0 ? currentWeek[0].topic : 'Not started';

  // Determine level
  let level = 'Apprentice';
  if (completed >= 12) level = 'Grand Master';
  else if (completed >= 8) level = 'Master';
  else if (completed >= 4) level = 'Adept';

  // Progress bar
  const barLength = 20;
  const filled = Math.round((progress / 100) * barLength);
  const progressBar = '█'.repeat(filled) + '░'.repeat(barLength - filled);

  dv.header(3, `${wizard.emoji} ${wizard.name}`);
  dv.paragraph(`*${wizard.motto}*`);
  dv.paragraph(`
**Current Week:** Week ${currentWeekNum} - ${currentTopic}
**Progress:** ${progressBar} ${progress}%
**Completed:** ${completed} / ${totalWeeks} weeks
**Streak:** 🔥 ${streak} week(s)
**Level:** 🌟 ${level}
**Grimoire:** [[Wizards/${wizard.id}/🧙‍♂️🪄 Grimoire|View Grimoire →]]
  `);
  dv.paragraph("---");
}
```

---

## 📅 Weekly Comparison

```dataviewjs
const wizards = ['G', 'A', 'D', 'L'];
const allWeeks = [];

// Collect all unique week numbers
const weekSet = new Set();
for (const wizard of wizards) {
  const weeks = dv.pages(`"Wizards/${wizard}"`)
    .where(p => p.file.path.includes("Week-") && p.file.name === "Tasks");
  weeks.forEach(w => weekSet.add(w.week));
}

const sortedWeeks = Array.from(weekSet).sort((a, b) => a - b);

// Build comparison table
const rows = sortedWeeks.map(weekNum => {
  const row = [weekNum];

  for (const wizard of wizards) {
    const weekExists = dv.pages(`"Wizards/${wizard}"`)
      .where(p => p.file.path.includes("Week-") && p.file.name === "Tasks" && p.week === weekNum);

    if (weekExists.length > 0) {
      row.push("✅");
    } else {
      row.push("⬜");
    }
  }

  return row;
});

dv.table(
  ["Week", "G", "A", "D", "L"],
  rows
);
```

---

## 🗣️ Prepare for Next Session

```dataviewjs
const wizards = ['G', 'A', 'D', 'L'];
const recentNotes = dv.pages('"Wizards"')
  .where(p => p.type === "notes" && p.file.path.includes("Week-"))
  .sort(p => p.file.mtime, 'desc')
  .limit(8);

if (recentNotes.length > 0) {
  dv.header(4, "📋 Recent Notes to Review Before Session");

  const rows = recentNotes.map(note => {
    const notesLink = dv.fileLink(note.file.path, false, "📝 View Notes & Questions");
    const lastUpdated = note.file.mtime.toFormat('yyyy-MM-dd HH:mm');

    return [
      note.wizard,
      `Week ${note.week}`,
      note.topic || "N/A",
      notesLink,
      lastUpdated
    ];
  });

  dv.table(
    ["Wizard", "Week", "Topic", "Notes", "Last Updated"],
    rows
  );
} else {
  dv.paragraph("*No notes available yet.*");
}
```

```dataviewjs
const wizards = ['G', 'A', 'D', 'L'];

for (const wizard of wizards) {
  const latestNote = dv.pages(`"Wizards/${wizard}"`)
    .where(p => p.type === "notes" && p.file.path.includes("Week-"))
    .sort(p => p.week, 'desc')
    .limit(1);

  if (latestNote.length > 0) {
    const note = latestNote[0];
    const weekNum = note.week;
    const topic = note.topic || "N/A";

    dv.header(4, `${wizard === 'G' ? '🌱' : wizard === 'A' ? '⚙️' : wizard === 'D' ? '🚀' : '👑'} Wizard ${wizard} - Week ${weekNum}: ${topic}`);

    // Read the file content to extract discussion points
    const file = app.vault.getAbstractFileByPath(note.file.path);
    if (file) {
      const content = await app.vault.read(file);

      // Extract the Discussion Points section
      const discussionMatch = content.match(/## 💬 Discussion Points for Next Session\s*([\s\S]*?)(?=\n---|\n##|$)/);

      if (discussionMatch && discussionMatch[1].trim()) {
        const discussionContent = discussionMatch[1].trim();

        // Parse and clean up the content
        let output = "";

        // Extract questions
        const questionsMatch = discussionContent.match(/\*\*Questions for Mentor:\*\*\s*([\s\S]*?)(?=\*\*Topics|$)/);
        if (questionsMatch) {
          const questions = questionsMatch[1].trim();
          // Remove empty numbered lines
          const questionLines = questions.split('\n').filter(line => {
            // Keep line only if it has content after the number (not just "1." or "2.")
            return line.match(/^\d+\.\s+\S+/);
          });

          if (questionLines.length > 0) {
            output += "**Questions for Mentor:**\n" + questionLines.join('\n') + "\n\n";
          }
        }

        // Extract topics
        const topicsMatch = discussionContent.match(/\*\*Topics I Want to Discuss:\*\*\s*([\s\S]*?)$/);
        if (topicsMatch) {
          const topics = topicsMatch[1].trim();
          // Check if there's actual content (not just a dash)
          if (topics && topics !== '-' && topics.match(/\w+/)) {
            output += "**Topics I Want to Discuss:**\n" + topics;
          }
        }

        if (output.trim()) {
          dv.paragraph(output.trim());
        } else {
          dv.paragraph("*No questions submitted yet for this week.*");
        }
      } else {
        dv.paragraph("*No discussion points section found.*");
      }
    }

    dv.paragraph(`📝 [[${note.file.path}|View Full Notes]] | Last updated: ${note.file.mtime.toFormat('yyyy-MM-dd HH:mm')}`);
    dv.paragraph("---");

  } else {
    dv.header(4, `Wizard ${wizard}`);
    dv.paragraph("*No notes available yet.*");
    dv.paragraph("---");
  }
}
```

---

## 📈 Recent Activity

```dataview
TABLE
  wizard as "Wizard",
  week as "Week",
  topic as "Topic",
  file.mtime as "Last Updated"
FROM "Wizards"
WHERE contains(file.path, "Week-") AND file.name = "Tasks"
SORT file.mtime DESC
LIMIT 8
```
