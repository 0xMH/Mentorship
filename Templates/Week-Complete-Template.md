<%*
// Auto-detect wizard from the active file when button was clicked
let wizard = "";
const activeFile = app.workspace.getActiveFile();
if (activeFile) {
    const activeFilePath = activeFile.path;
    const wizardMatch = activeFilePath.match(/Wizards\/([A-Z])/);
    if (wizardMatch) {
        wizard = wizardMatch[1];
    }
}

// If still not found, try to detect from any open file in Wizards folder
if (!wizard) {
    const openFiles = app.workspace.getLeavesOfType("markdown");
    for (const leaf of openFiles) {
        const file = leaf.view.file;
        if (file && file.path.includes("Wizards/")) {
            const match = file.path.match(/Wizards\/([A-Z])/);
            if (match) {
                wizard = match[1];
                break;
            }
        }
    }
}

// Last resort: prompt
if (!wizard) {
    wizard = await tp.system.prompt("Wizard letter (D, A, L, or G)");
}

const weekNumber = await tp.system.prompt("Week number");

// Try to read the curriculum file and get the topic
let curriculumContent = "";
let topicName = "";
try {
    const curriculumFile = app.vault.getAbstractFileByPath(`Tasks/Week-${weekNumber}-todos.md`);
    if (curriculumFile) {
        curriculumContent = await app.vault.read(curriculumFile);

        // Extract topic from frontmatter
        const frontmatterMatch = curriculumContent.match(/^---\n([\s\S]*?)\n---/);
        if (frontmatterMatch) {
            const frontmatter = frontmatterMatch[1];
            const topicMatch = frontmatter.match(/topic:\s*(.+)/);
            if (topicMatch) {
                topicName = topicMatch[1].trim();
            }
        }

        // Remove frontmatter from content
        curriculumContent = curriculumContent.replace(/^---\n[\s\S]*?\n---\n\n/, '');
    }
} catch (e) {
    topicName = await tp.system.prompt("Topic name (e.g., DevOps Foundations, Docker & Containers)");
}

if (!topicName) {
    topicName = await tp.system.prompt("Topic name (e.g., DevOps Foundations, Docker & Containers)");
}

// Create the Tasks file
const tasksContent = `---
wizard: ${wizard}
week: ${weekNumber}
topic: ${topicName}
status: not-started
type: tasks
---

# Week ${weekNumber}: ${topicName} - Wizard ${wizard}

\`\`\`meta-bind-button
label: 📝 My Notes & Reflection
icon: ""
style: primary
actions:
  - type: open
    link: "Wizards/${wizard}/Week-${weekNumber}/Notes"
\`\`\`

${curriculumContent || `## Overview


---

## Tasks

### 1.
- [ ]

**Key Topics to Focus On:**
-

---

### 2.

#### Learning Resources
**Video Learner?**
- [ ]

**Prefer Reading?**
- [ ]

#### Practice Goals
- [ ]

---

### 3.

- [ ]

#### Learning Resources
**Video Learner?**
- [ ]

**Prefer Reading?**
- [ ]

---`}

## Reference
- [[Wizards/${wizard}/Week-${weekNumber}/Notes|My Notes & Reflection]]
- [[Curriculums/Week-${weekNumber}|Week ${weekNumber} Curriculum]]
- [[Wizards/${wizard}/🧙‍♂️🪄 Grimoire|My Grimoire]]
`;

// Create the Notes file
const notesContent = `---
wizard: ${wizard}
week: ${weekNumber}
topic: ${topicName}
type: notes
---

# Week ${weekNumber} Notes - Wizard ${wizard}
## ${topicName}

> 💡 Use this space however works best for you - take notes, paste code, add screenshots, organize by topic, or journal your learning journey!

---

## Your Notes

<!-- This is your space - organize it however you like! -->



---

## 💬 Discussion Points for Next Session

**Questions for Mentor:**
1.
2.
3.

**Topics I Want to Discuss:**
-

---

[[Wizards/${wizard}/Week-${weekNumber}/Tasks|← Back to Week ${weekNumber} Tasks]] | [[Wizards/${wizard}/🧙‍♂️🪄 Grimoire|My Grimoire]]
`;

// Create the week folder
const weekFolder = `Wizards/${wizard}/Week-${weekNumber}`;
try {
    await app.vault.createFolder(weekFolder);
} catch (e) {
    // Folder might already exist, that's okay
}

// Create Tasks file
const tasksPath = `${weekFolder}/Tasks.md`;
await app.vault.create(tasksPath, tasksContent);

// Create Notes file
const notesPath = `${weekFolder}/Notes.md`;
await app.vault.create(notesPath, notesContent);

// Open the Tasks file
const tasksFile = app.vault.getAbstractFileByPath(tasksPath);
await app.workspace.getLeaf().openFile(tasksFile);
-%>
