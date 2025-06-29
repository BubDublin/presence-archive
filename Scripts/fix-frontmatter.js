

const fs = require("fs");
const path = require("path");
const matter = require("gray-matter");

const targetDir = path.join(__dirname, "..", "site");

function fixYamlFrontmatter(filePath) {
  const content = fs.readFileSync(filePath, "utf8");
  let newContent = content;
  try {
    const parsed = matter(content);
    const fixedYaml = matter.stringify(parsed.content.trim(), parsed.data);
    newContent = fixedYaml;
  } catch (err) {
    console.warn(`⚠️ Could not parse YAML in: ${filePath}`);
    console.warn(err.message);
  }

  fs.writeFileSync(filePath, newContent);
  console.log(`✅ Fixed: ${filePath}`);
}

function processDir(dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      processDir(fullPath);
    } else if (entry.isFile() && entry.name.endsWith(".md")) {
      fixYamlFrontmatter(fullPath);
    }
  }
}

processDir(targetDir);