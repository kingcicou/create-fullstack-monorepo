#!/usr/bin/env node

// create-fullstack-monorepo
// Zero-dependency CLI to scaffold a fullstack monorepo project.
// Usage:
//   npx create-fullstack-monorepo my-app
//   npm create fullstack-monorepo my-app

import {
  existsSync,
  mkdirSync,
  readdirSync,
  statSync,
  readFileSync,
  writeFileSync,
  rmSync,
} from 'node:fs';
import { resolve, join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createInterface } from 'node:readline/promises';
import { execSync } from 'node:child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// ── ANSI Colors ──────────────────────────────────────────────
const c = {
  reset: '\x1b[0m',
  bold: '\x1b[1m',
  dim: '\x1b[2m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m',
};

// ── Helpers ──────────────────────────────────────────────────
function banner() {
  console.log();
  console.log(`${c.cyan}╔══════════════════════════════════════════╗${c.reset}`);
  console.log(`${c.cyan}║${c.reset}  ${c.bold}FullStack Monorepo Initializer${c.reset}           ${c.cyan}║${c.reset}`);
  console.log(`${c.cyan}║${c.reset}  ${c.dim}github.com/kingcicou/create-fullstack${c.reset}     ${c.cyan}║${c.reset}`);
  console.log(`${c.cyan}╚══════════════════════════════════════════╝${c.reset}`);
  console.log();
}

function log(tag, msg, color = c.green) {
  console.log(`${color}[${tag}]${c.reset} ${msg}`);
}

function die(msg) {
  console.error(`${c.red}[ERROR]${c.reset} ${msg}`);
  process.exit(1);
}

/**
 * Recursively copy a template directory, performing:
 *  - `_xxx` → `.xxx` rename (npm strips dotfiles from packages)
 *  - `PROJECT_NAME` in file/dir names → actual project name
 *  - `{{PROJECT_NAME}}` / `{{PROJECT_NAME_UPPER}}` in content → actual values
 */
function copyTemplate(srcDir, destDir, vars) {
  mkdirSync(destDir, { recursive: true });

  for (const entry of readdirSync(srcDir)) {
    const srcPath = join(srcDir, entry);

    // Rename: _gitignore → .gitignore, _vscode → .vscode
    let destName = entry.startsWith('_') ? '.' + entry.slice(1) : entry;

    // Replace PROJECT_NAME in filename
    destName = destName.replace(/PROJECT_NAME/g, vars.projectName);

    const destPath = join(destDir, destName);

    if (statSync(srcPath).isDirectory()) {
      copyTemplate(srcPath, destPath, vars);
    } else {
      let content = readFileSync(srcPath, 'utf-8');
      content = content
        .replace(/\{\{PROJECT_NAME_UPPER\}\}/g, vars.projectNameUpper)
        .replace(/\{\{PROJECT_NAME\}\}/g, vars.projectName);
      writeFileSync(destPath, content, 'utf-8');
    }
  }
}

function tryGitInit(cwd) {
  try {
    execSync('git --version', { stdio: 'ignore' });
  } catch {
    log('SKIP', 'Git not found, skipping initialization.', c.yellow);
    return;
  }
  try {
    execSync('git init', { cwd, stdio: 'ignore' });
    execSync('git add -A', { cwd, stdio: 'ignore' });
    execSync('git commit -m "feat: initial monorepo structure"', {
      cwd,
      stdio: 'ignore',
    });
    log('GIT', 'Repository initialized with initial commit.');
  } catch {
    log('WARN', 'Git init succeeded but commit failed (check git config).', c.yellow);
  }
}

// ── Main ─────────────────────────────────────────────────────
async function main() {
  banner();

  const args = process.argv.slice(2);

  // Handle --help / -h
  if (args.includes('--help') || args.includes('-h')) {
    console.log('Usage: create-fullstack-monorepo [project-name]');
    console.log();
    console.log('Options:');
    console.log('  --help, -h       Show this help message');
    console.log('  --version, -v    Show version number');
    console.log();
    console.log('Examples:');
    console.log('  npx create-fullstack-monorepo my-app');
    console.log('  npm create fullstack-monorepo my-app');
    process.exit(0);
  }

  // Handle --version / -v
  if (args.includes('--version') || args.includes('-v')) {
    const pkg = JSON.parse(readFileSync(join(__dirname, 'package.json'), 'utf-8'));
    console.log(pkg.version);
    process.exit(0);
  }

  // ── 1. Get project name ────────────────────────────────────
  let projectName = args.find((a) => !a.startsWith('-'));

  if (!projectName) {
    const rl = createInterface({ input: process.stdin, output: process.stdout });
    projectName = (await rl.question(`${c.cyan}?${c.reset} Project name: `)).trim();
    rl.close();
  }

  if (!projectName) {
    die('Project name is required.');
  }

  if (!/^[a-zA-Z0-9_-]+$/.test(projectName)) {
    die('Invalid project name. Use only: letters, numbers, dash (-), underscore (_).');
  }

  // ── 2. Resolve target directory ────────────────────────────
  const targetDir = resolve(process.cwd(), projectName);

  if (existsSync(targetDir)) {
    const rl = createInterface({ input: process.stdin, output: process.stdout });
    const answer = (
      await rl.question(
        `${c.yellow}!${c.reset} Directory "${projectName}" already exists. Overwrite? (y/N) `
      )
    ).trim();
    rl.close();

    if (answer.toLowerCase() !== 'y') {
      console.log('Cancelled.');
      process.exit(0);
    }
    rmSync(targetDir, { recursive: true, force: true });
    log('CLEAN', 'Old directory removed.');
  }

  // ── 3. Copy template ──────────────────────────────────────
  log('CREATE', `Scaffolding project "${projectName}"...`);

  const templateDir = join(__dirname, 'template');
  const vars = {
    projectName,
    projectNameUpper: projectName.toUpperCase(),
  };

  copyTemplate(templateDir, targetDir, vars);
  log('CREATE', 'All files generated.');

  // ── 4. Git init ────────────────────────────────────────────
  tryGitInit(targetDir);

  // ── 5. Done ────────────────────────────────────────────────
  console.log();
  console.log(`${c.cyan}╔══════════════════════════════════════════╗${c.reset}`);
  console.log(`${c.cyan}║${c.reset}  ${c.green}${c.bold}Project created successfully!${c.reset}             ${c.cyan}║${c.reset}`);
  console.log(`${c.cyan}╚══════════════════════════════════════════╝${c.reset}`);
  console.log();
  console.log(`${c.yellow}Next steps:${c.reset}`);
  console.log();
  console.log(`  cd ${projectName}`);
  console.log(`  code ${projectName}.code-workspace`);
  console.log();
}

main().catch((err) => {
  die(err.message);
});
