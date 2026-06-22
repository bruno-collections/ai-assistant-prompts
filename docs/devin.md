# Devin Setup for Bruno

[Devin](https://devin.ai) is an autonomous AI software engineer by Cognition that can understand entire codebases, create development plans, write and edit code, run tests, and debug issues end-to-end. Devin works with Bruno through **skills files** (`.agents/skills/`), and in Cloud mode also through **Knowledge notes** and **Playbooks**.

## Devin Local (Desktop & CLI)

### Setup

1. Install Devin Desktop from [devin.ai](https://devin.ai) or install the Devin CLI.

2. Create the skills directory in your Bruno project:
```bash
mkdir -p .agents/skills
```

3. Copy the Bruno skills files:
```bash
# YAML/OpenCollection format (Bruno v3.1+)
curl -fsSL https://raw.githubusercontent.com/bruno-collections/ai-assistant-prompts/main/prompts/devin/.agents/skills/bruno.md -o .agents/skills/bruno.md

# Legacy Bru format (optional)
curl -fsSL https://raw.githubusercontent.com/bruno-collections/ai-assistant-prompts/main/prompts/devin/.agents/skills/bruno-bru.md -o .agents/skills/bruno-bru.md
```

4. Commit the skills files to your repository:
```bash
git add .agents/skills/
git commit -m "Add Devin skills files for Bruno development"
```

### How It Works

Devin Local automatically discovers `.agents/skills/` files when you open a project. The skills files give Devin context about:

- Bruno's file formats (YAML/OpenCollection and legacy Bru)
- Collection directory structure and conventions
- JavaScript scripting API (`req`, `res`, `bru` objects)
- Testing patterns with Chai.js assertions
- Authentication, environment, and secret management
- Bruno CLI usage for CI/CD

### Usage

**Devin Desktop**: Open your project folder. Devin reads the skills files and applies Bruno context to all interactions.

**Devin CLI**: Run from your project root:
```bash
devin "Create a Bruno collection for my REST API with tests for each endpoint"
```

## Devin Cloud

Devin Cloud runs in a remote VM with full shell, browser, and tool access. It supports three layers of Bruno configuration.

### 1. Skills Files (per-repository)

Same setup as Devin Local — create `.agents/skills/bruno.md` in your project. Devin Cloud reads these automatically.

For Cloud-specific guidance, also add:
```bash
curl -fsSL https://raw.githubusercontent.com/bruno-collections/ai-assistant-prompts/main/prompts/devin/.agents/skills/bruno-cloud.md -o .agents/skills/bruno-cloud.md
```

### 2. Knowledge Notes (cross-repository)

Knowledge notes are persistent context that Devin Cloud retrieves automatically based on relevance. Create them in the [Devin web interface](https://app.devin.ai) under **Settings > Knowledge**.

Recommended Knowledge notes for Bruno teams:

| Note | Trigger | Content |
|------|---------|---------|
| Bruno Format Standards | When working with Bruno collections | YAML vs Bru format preference, opencollection.yml requirements |
| API Testing Standards | When writing API tests | Required assertions, coverage expectations, naming conventions |
| Environment Conventions | When managing Bruno environments | Environment naming, secret handling, variable patterns |
| CI/CD Pipeline Standards | When setting up CI/CD for API tests | Bruno CLI configuration, reporter options, pipeline structure |

### 3. Playbooks (reusable workflows)

Playbooks are step-by-step procedures for recurring tasks. Create them in the [Devin web interface](https://app.devin.ai) under **Settings > Playbooks**.

Recommended Playbooks:

- **Generate Bruno Collection** — Scaffold a collection from backend source code
- **Migrate from Postman** — Convert Postman exports to Bruno format
- **Add Test Coverage** — Analyze existing requests and add comprehensive tests
- **Set Up CI/CD** — Create pipeline configs for Bruno CLI test execution

## Comparison: Local vs Cloud

| Feature | Devin Local | Devin Cloud |
|---------|-------------|-------------|
| Skills files (`.agents/skills/`) | Yes | Yes |
| Knowledge notes | No | Yes |
| Playbooks | No | Yes |
| Direct filesystem access | Yes | Yes (remote VM) |
| Bruno CLI execution | Via local install | Via remote VM |
| Browser access | No | Yes |
| Best for | Interactive development, quick edits | Autonomous tasks, CI/CD setup, migrations |

## Troubleshooting

### Skills Files Not Detected
1. Ensure files are at `.agents/skills/` relative to the project root
2. Check that files use `.md` extension
3. Restart Devin or re-open the project

### Knowledge Notes Not Applied (Cloud)
1. Verify the note's trigger matches the task context
2. Check that the note is active in Settings > Knowledge
3. Try making the trigger more specific to Bruno-related tasks

### Bruno CLI Not Available (Cloud)
Devin Cloud can install Bruno CLI on-demand:
```bash
npm install -g @usebruno/cli
```
Add this to your Devin environment blueprint for automatic availability.

## Related Resources

- [Devin Documentation](https://docs.devin.ai)
- [Bruno Documentation](https://docs.usebruno.com)
- [Bruno CLI Reference](https://docs.usebruno.com/bru-cli/overview)
- [OpenCollection Specification](https://spec.opencollection.com/)
