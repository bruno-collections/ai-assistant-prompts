# Bruno AI Assistant Prompts

> 🤖 Official AI coding assistant prompts and configurations for working with Bruno API Client

[![Bruno](https://img.shields.io/badge/Bruno-API%20Client-orange)](https://usebruno.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Community](https://img.shields.io/badge/Community-bruno--collections-blue)](https://github.com/bruno-collections)

This repository provides comprehensive prompt files and configurations to help AI coding assistants understand and work effectively with [Bruno API Client](https://github.com/usebruno/bruno) projects.

## 🚀 Quick Start

### One-Command Setup
```bash
# Copy all prompts to your Bruno project
curl -fsSL https://raw.githubusercontent.com/bruno-collections/bruno-ai-assistant-prompts/main/install.sh | bash
```

### Manual Installation
1. Choose your AI assistant from the [prompts/](./prompts/) directory
2. Copy the appropriate files to your Bruno project
3. Follow the setup instructions for your specific AI assistant

## 🤖 Supported AI Assistants

| AI Assistant | File | Auto-Discovery | Setup Required |
|--------------|------|----------------|----------------|
| [Cursor AI](./docs/cursor.md) | `.cursorrules` | ✅ Automatic | No |
| [GitHub Copilot](./docs/copilot.md) | `.github/copilot-instructions.md` | ✅ Automatic | No |
| [VS Code Extensions](./docs/vscode.md) | `.vscode/ai-instructions.md` | ✅ Most extensions | Minimal |
| [Claude/ChatGPT](./docs/general.md) | `bruno-ai-context.md` | ❌ Manual | Copy & paste |
| [Continue](./docs/continue.md) | `.continue/config.json` | ✅ Automatic | Minimal |
| [Codeium](./docs/codeium.md) | `.codeium/context.md` | ✅ Automatic | No |

## 📁 Repository Structure

```
bruno-ai-assistant-prompts/
├── prompts/                    # AI assistant prompt files
│   ├── cursor/                 # Cursor AI (.cursorrules)
│   ├── copilot/               # GitHub Copilot
│   ├── vscode/                # VS Code AI extensions
│   ├── general/               # Claude, ChatGPT, etc.
│   └── continue/              # Continue extension
├── examples/                   # Example Bruno projects with prompts
│   ├── rest-api/              # REST API collection example
│   ├── graphql/               # GraphQL collection example
│   └── microservices/         # Microservices collection example
├── docs/                      # Documentation for each AI assistant
├── scripts/                   # Installation and setup scripts
└── templates/                 # Template files for new projects
```

## 🎯 What These Prompts Provide

### Bruno-Specific Knowledge
- **Bru File Format**: Complete syntax and structure understanding
- **Architecture**: Monorepo structure and package responsibilities
- **Best Practices**: Git-first, offline-only development patterns
- **File Organization**: Collection structure and environment management

### Practical Assistance
- **Request Creation**: Generate .bru files with proper syntax
- **Environment Setup**: Create environment files with variables and secrets
- **Testing**: Write comprehensive test assertions
- **Authentication**: Implement various auth methods
- **Scripting**: Pre-request and post-response JavaScript

### Code Quality
- **Consistent Formatting**: Maintain Bruno's plain-text philosophy
- **Error Handling**: Robust error handling in scripts
- **Documentation**: Meaningful names and descriptions
- **Security**: Proper secret management

## 📖 Quick Examples

### Creating a New API Request
```bru
meta {
  name: Create User
  type: http
  seq: 1
}

post {
  url: {{baseUrl}}/api/users
  body: json
  auth: bearer
}

headers {
  content-type: application/json
}

auth:bearer {
  token: {{authToken}}
}

body:json {
  {
    "name": "{{userName}}",
    "email": "{{userEmail}}"
  }
}

tests {
  test("User created successfully", function() {
    expect(res.status).to.equal(201);
    expect(res.body).to.have.property("id");
  });
}
```

### Environment Configuration
```bru
vars {
  baseUrl: https://api.example.com
  apiVersion: v1
}

vars:secret [
  authToken,
  apiKey
]
```

## 🛠️ Installation Methods

### Method 1: Automated Script
```bash
cd your-bruno-project
curl -fsSL https://raw.githubusercontent.com/bruno-collections/bruno-ai-assistant-prompts/main/install.sh | bash
```

### Method 2: Manual Copy
1. Download the prompts for your AI assistant
2. Copy to your Bruno project root
3. Restart your editor

### Method 3: Git Submodule
```bash
git submodule add https://github.com/bruno-collections/bruno-ai-assistant-prompts.git .bruno-ai
ln -s .bruno-ai/prompts/cursor/.cursorrules .cursorrules
```

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

### Quick Contribution
1. Fork this repository
2. Add/improve prompt files
3. Test with real Bruno projects
4. Submit a pull request

## 📚 Documentation

- [Cursor AI Setup](./docs/cursor.md)
- [GitHub Copilot Setup](./docs/copilot.md)
- [VS Code Extensions Setup](./docs/vscode.md)
- [General AI Assistants](./docs/general.md)
- [Troubleshooting Guide](./docs/troubleshooting.md)

## 🌟 Community

- [Bruno Collections](https://github.com/bruno-collections)
- [Bruno Main Repository](https://github.com/usebruno/bruno)
- [Bruno Documentation](https://docs.usebruno.com)
- [Bruno Discord](https://discord.com/invite/KgcZUncAjX)

## 📄 License

MIT License - see [LICENSE](./LICENSE) for details.

---

Made with ❤️ by the Bruno community
