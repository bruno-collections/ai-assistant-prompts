# Contributing to Bruno AI Assistant Prompts

Thank you for your interest in contributing to the Bruno AI Assistant Prompts repository! This project helps the Bruno community work more effectively with AI coding assistants.

## 🎯 How to Contribute

### Types of Contributions Welcome
- **New AI Assistant Support**: Add prompts for additional AI assistants
- **Prompt Improvements**: Enhance existing prompts with better context or examples
- **Documentation**: Improve setup guides and usage instructions
- **Examples**: Add practical examples and use cases
- **Bug Fixes**: Fix issues with existing prompts or documentation
- **Testing**: Test prompts with different AI assistants and report results

## 🚀 Getting Started

### 1. Fork and Clone
```bash
git clone https://github.com/YOUR_USERNAME/bruno-ai-assistant-prompts.git
cd bruno-ai-assistant-prompts
```

### 2. Create a Branch
```bash
git checkout -b feature/add-new-ai-assistant
# or
git checkout -b fix/improve-cursor-prompts
```

### 3. Make Your Changes
Follow the existing structure and patterns in the repository.

## 📁 Repository Structure

```
bruno-ai-assistant-prompts/
├── prompts/                    # AI assistant prompt files
│   ├── cursor/                 # Cursor AI (.cursorrules)
│   ├── copilot/               # GitHub Copilot
│   ├── vscode/                # VS Code AI extensions
│   ├── general/               # Claude, ChatGPT, etc.
│   ├── continue/              # Continue extension
│   └── codeium/               # Codeium
├── examples/                   # Example Bruno projects
├── docs/                      # Documentation for each AI assistant
├── scripts/                   # Installation and setup scripts
└── templates/                 # Template files
```

## ✅ Adding a New AI Assistant

### 1. Create Directory Structure
```bash
mkdir -p prompts/your-ai-assistant
mkdir -p docs
```

### 2. Create Prompt Files
Follow the pattern of existing assistants:
- Include Bruno-specific context
- Provide .bru file format examples
- Explain key concepts (variables, authentication, testing)
- Include best practices

### 3. Create Documentation
Create `docs/your-ai-assistant.md` with:
- Setup instructions
- Configuration details
- Usage examples
- Troubleshooting tips

### 4. Update Main README
Add your AI assistant to the supported list in `README.md`.

## 📝 Prompt File Guidelines

### Essential Content
Every prompt file should include:

1. **Bruno Overview**: What Bruno is and its philosophy
2. **Bru File Format**: Complete syntax examples
3. **Key Concepts**: Variables, authentication, testing
4. **File Structure**: How Bruno projects are organized
5. **Best Practices**: Git-first, offline-only approach
6. **Common Patterns**: Typical development workflows

### Example Structure
```markdown
# AI Assistant Instructions for Bruno

## About Bruno
[Brief overview]

## Bru File Format
[Complete .bru file example]

## Key Concepts
[Variables, auth, testing, etc.]

## Best Practices
[Development guidelines]
```

### Quality Standards
- **Accurate**: All examples should be valid Bruno syntax
- **Complete**: Cover all major Bruno features
- **Clear**: Easy to understand for developers
- **Consistent**: Follow the same structure as other prompts
- **Tested**: Verify prompts work with the target AI assistant

## 🧪 Testing Your Contributions

### Before Submitting
1. **Test with Real Projects**: Use your prompts with actual Bruno collections
2. **Verify AI Assistant Integration**: Ensure the AI assistant reads and uses your prompts
3. **Check Examples**: Make sure all code examples are valid
4. **Review Documentation**: Ensure setup instructions are clear and complete

### Testing Checklist
- [ ] Prompt file follows repository structure
- [ ] AI assistant correctly understands Bruno concepts
- [ ] Generated .bru files have valid syntax
- [ ] Documentation is clear and complete
- [ ] Examples work as expected
- [ ] No broken links or references

## 📋 Pull Request Process

### 1. Prepare Your PR
- Ensure your branch is up to date with main
- Test your changes thoroughly
- Update documentation as needed
- Follow the existing code style

### 2. Create Pull Request
- Use a descriptive title
- Explain what you've added or changed
- Include testing details
- Reference any related issues

### 3. PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New AI assistant support
- [ ] Prompt improvement
- [ ] Documentation update
- [ ] Bug fix
- [ ] Example addition

## Testing
- [ ] Tested with target AI assistant
- [ ] Verified .bru file generation
- [ ] Checked documentation accuracy
- [ ] Tested installation process

## Screenshots/Examples
[If applicable, include examples of the AI assistant using your prompts]
```

## 🎨 Style Guidelines

### File Naming
- Use lowercase with hyphens: `ai-assistant-name`
- Be descriptive: `github-copilot` not `copilot`
- Match the official AI assistant name

### Documentation Style
- Use clear, concise language
- Include practical examples
- Provide step-by-step instructions
- Use consistent formatting

### Code Examples
- Use realistic API scenarios
- Include proper error handling
- Show best practices
- Keep examples focused and relevant

## 🐛 Reporting Issues

### Bug Reports
When reporting bugs, include:
- AI assistant name and version
- Bruno version (if applicable)
- Steps to reproduce
- Expected vs actual behavior
- Error messages or screenshots

### Feature Requests
For new features, describe:
- Which AI assistant you'd like supported
- Why it would be valuable
- Any specific requirements or constraints

## 🤝 Community Guidelines

### Be Respectful
- Use inclusive language
- Be patient with new contributors
- Provide constructive feedback
- Help others learn and improve

### Collaborate Effectively
- Communicate clearly in issues and PRs
- Ask questions when unsure
- Share knowledge and best practices
- Credit others for their contributions

## 📚 Resources

### Bruno Resources
- [Bruno Main Repository](https://github.com/usebruno/bruno)
- [Bruno Documentation](https://docs.usebruno.com)
- [Bruno Collections](https://github.com/bruno-collections)

### AI Assistant Documentation
- [Cursor AI](https://cursor.sh/docs)
- [GitHub Copilot](https://docs.github.com/en/copilot)
- [Continue](https://continue.dev/docs)
- [Codeium](https://codeium.com/docs)

## 🏆 Recognition

Contributors will be:
- Listed in the repository contributors
- Mentioned in release notes for significant contributions
- Credited in documentation they help create

Thank you for helping make Bruno more accessible to the AI-assisted development community! 🚀
