# Bruno API Client — Devin Cloud Context

This file supplements the core Bruno skills (`bruno.md` / `bruno-bru.md`) with guidance specific to **Devin Cloud** sessions. Devin Cloud runs in a remote VM with shell, browser, and full tool access.

## Devin Cloud Capabilities for Bruno

### Knowledge Notes
Devin Cloud automatically retrieves relevant **Knowledge notes** during a session. Teams should create Knowledge notes for:

- **Bruno format preferences** — Whether the team uses YAML (OpenCollection) or legacy Bru format
- **Testing standards** — Required assertions, coverage thresholds, naming conventions
- **Environment naming** — How environments are structured (e.g., `Local.yml`, `Staging.yml`, `Production.yml`)
- **Secret management** — How the team handles API keys, tokens, and credentials in Bruno
- **Collection organization** — Folder structure conventions, request naming patterns

Example Knowledge note:
```
Title: Bruno Collection Standards
Trigger: When working with Bruno collections or API tests

- Use YAML/OpenCollection format (v3.1+)
- Every collection must have opencollection.yml with version 1.0.0
- Environment files use PascalCase names
- All requests must assert status code and response time
- Secrets use secret: true in environment files, never hardcoded
```

### Playbooks
Teams can create **Playbooks** for repeatable Bruno workflows:

- **Generate Bruno collection from source code** — Analyze routes/controllers, scaffold collection with environments and tests
- **Migrate from Postman** — Convert exported Postman collections to Bruno format with proper structure
- **Set up CI/CD for API tests** — Create GitHub Actions / Jenkins / GitLab CI pipeline using Bruno CLI
- **Add tests to existing collection** — Analyze existing requests and add comprehensive test coverage

Example Playbook:
```
Title: Generate Bruno Collection from Backend API

1. Identify all API endpoints from route/controller files
2. Create collection directory with opencollection.yml
3. Generate environment files (Local.yml, Staging.yml, Production.yml)
4. Create request .yml files for each endpoint with:
   - HTTP method and URL using {{baseUrl}}
   - Headers and body from route definitions
   - Auth using {{authToken}} bearer
   - Tests: status code, response structure, response time
5. Add pre-request scripts for auth-dependent endpoints
6. Validate with: bru run --env Local
7. Commit and create PR
```

### Skills Files
This directory (`.agents/skills/`) provides per-repository context. Devin Cloud reads these files automatically when working in the repository. Use skills files for:

- Bruno format reference and API documentation (see `bruno.md`)
- Project-specific collection conventions
- Custom scripting patterns used in this repository

## CI/CD with Devin Cloud
Devin Cloud can run Bruno CLI directly in its VM to validate collections:

```bash
# Install Bruno CLI
npm install -g @usebruno/cli

# Run collection against an environment
bru run --env Local --reporter-html results.html

# Run a specific folder
bru run --env Local "Users"
```

## Workflow: Devin Cloud + Bruno
1. Devin receives a task (e.g., "Add API tests for the users endpoint")
2. Knowledge notes inject team conventions (format, testing standards, naming)
3. Skills files provide Bruno API reference and project structure
4. Devin reads existing source code and Bruno collections
5. Devin generates/modifies collection files following all conventions
6. Devin validates by running `bru run` in the VM
7. Devin commits changes and creates a PR
