# GitHub Copilot Setup for Bruno

[GitHub Copilot](https://github.com/features/copilot) automatically discovers and uses instruction files to provide better code suggestions for your Bruno projects.

## 🚀 Quick Setup

### Automatic Installation
```bash
cd your-bruno-project
curl -fsSL https://raw.githubusercontent.com/bruno-collections/ai-assistant-prompts/main/install.sh | bash
```

### Manual Installation
1. Create the `.github` directory if it doesn't exist:
```bash
mkdir -p .github
```

2. Download the Copilot instructions:

**YAML format (default, Bruno v3.1+):**
```bash
curl -fsSL https://raw.githubusercontent.com/bruno-collections/ai-assistant-prompts/main/prompts/copilot/.github/copilot-instructions.md -o .github/copilot-instructions.md
```

**Bru format (legacy):**
```bash
curl -fsSL https://raw.githubusercontent.com/bruno-collections/ai-assistant-prompts/main/prompts/copilot/.github/copilot-instructions-bru.md -o .github/copilot-instructions.md
```

3. Restart your editor to load the new instructions

## ✨ Features

### Bruno-Aware Suggestions
- **YAML Syntax**: Copilot understands Bruno's YAML (OpenCollection) file structure
- **Bru Syntax**: Also supports legacy `.bru` file format
- **Variable Patterns**: Suggests proper `{{variableName}}` usage
- **Authentication**: Knows Bruno's auth patterns
- **Testing**: Suggests Chai.js assertions for Bruno tests

### What Copilot Will Suggest
- ✅ Valid YAML or .bru file syntax and structure
- ✅ Proper info/meta blocks with name, type, seq
- ✅ Environment variable usage
- ✅ Authentication patterns
- ✅ Pre-request and post-response scripts
- ✅ Comprehensive test assertions

## 🎯 Usage Examples

### Creating Request Files
When you start typing in a `.yml` request file, Copilot will suggest:

```yaml
info:
  name: Get User Profile
  type: http
  seq: 1

http:
  method: GET
  url: "{{baseUrl}}/users/{{userId}}"
  auth:
    type: bearer
    token: "{{token}}"
```

### Environment Variables
In environment files, Copilot suggests:

```yaml
variables:
  - name: baseUrl
    value: https://api.example.com
  - name: apiVersion
    value: v1
  - name: apiKey
    value: ""
    secret: true
```

### Test Assertions
When writing tests, Copilot suggests:

```yaml
runtime:
  scripts:
    - type: tests
      code: |-
        test("Status is 200", function() {
          expect(res.status).to.equal(200);
        });

        test("Response has data", function() {
          expect(res.body).to.have.property("data");
        });
```

## 🔧 Supported Editors

### VS Code
1. Install the [GitHub Copilot extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
2. Place the instruction file in `.github/copilot-instructions.md`
3. Copilot automatically reads the instructions

### JetBrains IDEs
1. Install the [GitHub Copilot plugin](https://plugins.jetbrains.com/plugin/17718-github-copilot)
2. Ensure the instruction file is in `.github/copilot-instructions.md`
3. Restart the IDE

### Neovim
1. Install [copilot.vim](https://github.com/github/copilot.vim) or [copilot.lua](https://github.com/zbirenbaum/copilot.lua)
2. The instruction file will be automatically discovered

## 💡 Getting Better Suggestions

### File Context
Copilot works better when you:
- Name files descriptively: `Create User.yml`, `Get Profile.yml`
- Include comments explaining the API purpose
- Use consistent variable naming

### Prompt Engineering
Start typing what you want:
```yaml
# Type this to get suggestions for a POST request
info:
  name: Create New User
  type: http
```

### Sequential Development
Build requests step by step:
1. Start with meta block
2. Add request method and URL
3. Include headers
4. Add authentication
5. Include body (if needed)
6. Add tests

## 🐛 Troubleshooting

### Copilot Not Using Instructions
1. **Check File Location**: Ensure file is at `.github/copilot-instructions.md`
2. **Restart Editor**: Close and reopen your editor
3. **Verify Copilot Status**: Check that Copilot is active and authenticated

### Poor Suggestions
1. **Add Context**: Include more descriptive comments
2. **Use Bruno Terminology**: Mention "Bruno", ".yml", "environment variables"
3. **Reference Existing Files**: Keep similar requests open for context

### Missing Bruno Features
1. **Update Instructions**: Ensure you have the latest instruction file
2. **Provide Examples**: Include example `.yml` files in your project
3. **Use Specific Names**: Name files with Bruno-specific patterns

## 🔄 Team Collaboration

### Repository Setup
Commit the instruction file to your repository:

```bash
git add .github/copilot-instructions.md
git commit -m "Add GitHub Copilot instructions for Bruno"
git push
```

### Team Benefits
- **Consistent Suggestions**: All team members get Bruno-aware suggestions
- **Faster Onboarding**: New team members get immediate context
- **Best Practices**: Copilot suggests Bruno best practices

## 📊 Measuring Effectiveness

### Good Indicators
- ✅ Copilot suggests YAML syntax for Bruno requests
- ✅ Variable suggestions use `{{variableName}}` format
- ✅ Test suggestions use Chai.js assertions
- ✅ Authentication patterns match Bruno's auth structure

### Improvement Areas
- ❌ Suggestions use JSON format for requests
- ❌ Missing environment variable patterns
- ❌ Generic test assertions instead of Bruno-specific

## 🔗 Related Resources

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Bruno Documentation](https://docs.usebruno.com)
- [Copilot Best Practices](https://github.blog/2023-06-20-how-to-write-better-prompts-for-github-copilot/)

## 📝 Example Workflow

1. **Create New .yml File**: Start with a descriptive filename
2. **Begin with Info**: Type `info:` and let Copilot suggest structure
3. **Add Request Details**: Include method, URL, and headers
4. **Include Authentication**: Add appropriate auth configuration
5. **Write Tests**: Add comprehensive test coverage
6. **Refine Variables**: Use environment variables for reusable values

With proper instruction files in place, GitHub Copilot becomes an effective assistant for Bruno development, understanding the unique patterns and best practices of the Bruno ecosystem.
