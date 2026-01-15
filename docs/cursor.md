# Cursor AI Setup for Bruno

[Cursor](https://cursor.sh) is an AI-powered code editor that automatically reads `.cursorrules` files to understand your project context.

## 🚀 Quick Setup

### Automatic Installation
```bash
cd your-bruno-project
curl -fsSL https://raw.githubusercontent.com/bruno-collections/bruno-ai-assistant-prompts/main/install.sh | bash
```

### Manual Installation
1. Copy the `.cursorrules` file to your Bruno project root:
```bash
curl -fsSL https://raw.githubusercontent.com/bruno-collections/bruno-ai-assistant-prompts/main/prompts/cursor/.cursorrules -o .cursorrules
```

2. Restart Cursor to load the new rules

## ✨ Features

### Bruno-Specific Understanding
- **Bru File Format**: Complete syntax understanding
- **Architecture Knowledge**: Monorepo structure and package responsibilities
- **Best Practices**: Git-first, offline-only development patterns
- **File Organization**: Collection structure and environment management

### What Cursor Will Help With
- ✅ Generate valid .bru files with proper syntax
- ✅ Create environment files with variables and secrets
- ✅ Write pre-request and post-response scripts
- ✅ Add comprehensive test assertions
- ✅ Suggest proper authentication patterns
- ✅ Maintain Bruno's plain-text philosophy

## 🎯 Usage Examples

### Creating a New API Request
**Prompt**: "Create a new .bru file for a POST request to create a user"

**Expected Output**:
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

### Environment Setup
**Prompt**: "Create a development environment file"

**Expected Output**:
```bru
vars {
  baseUrl: https://api.dev.example.com
  apiVersion: v1
  timeout: 5000
}

vars:secret [
  authToken,
  apiKey
]
```

### Adding Tests
**Prompt**: "Add comprehensive tests for this API request"

**Expected Output**:
```bru
tests {
  test("Response status is successful", function() {
    expect(res.status).to.be.oneOf([200, 201]);
  });
  
  test("Response time is acceptable", function() {
    expect(res.responseTime).to.be.below(2000);
  });
  
  test("Response has required structure", function() {
    expect(res.body).to.be.an("object");
    expect(res.body).to.have.property("data");
  });
}
```

## 🔧 Configuration

### Custom Rules
You can extend the `.cursorrules` file with project-specific rules:

```
# Add to .cursorrules
## Project-Specific Rules
- This project uses OAuth2 authentication
- All requests should include rate limiting headers
- Use semantic versioning for API versions
```

### Team Collaboration
Commit the `.cursorrules` file to your repository so the entire team benefits:

```bash
git add .cursorrules
git commit -m "Add Cursor AI rules for Bruno development"
```

## 🐛 Troubleshooting

### Cursor Not Using Rules
1. **Check File Location**: Ensure `.cursorrules` is in your project root
2. **Restart Cursor**: Close and reopen Cursor to reload rules
3. **Verify Content**: Make sure the file downloaded correctly

### Incorrect Suggestions
1. **Be Specific**: Mention "Bruno .bru format" in your prompts
2. **Provide Context**: Share existing file structure
3. **Reference Examples**: Point to similar requests in your collection

### Rules Not Loading
1. **Check File Permissions**: Ensure the file is readable
2. **Validate Syntax**: Make sure the .cursorrules file is properly formatted
3. **Clear Cache**: Try clearing Cursor's cache and restarting

## 💡 Pro Tips

### Better Prompts
- ✅ "Create a Bruno .bru file for user authentication"
- ❌ "Create an API request"

### Leverage Context
- Reference existing files: "Similar to get-user.bru, create update-user.bru"
- Mention environment: "Use the development environment variables"

### Iterative Development
- Start with basic request structure
- Add authentication and headers
- Include comprehensive tests
- Add error handling scripts

## 🔗 Related Resources

- [Cursor Documentation](https://cursor.sh/docs)
- [Bruno Documentation](https://docs.usebruno.com)
- [Bru Language Specification](https://github.com/usebruno/bruno/tree/main/packages/bruno-lang)

## 📝 Example Workflow

1. **Open Bruno Project**: Open your Bruno collection in Cursor
2. **Create New Request**: Ask Cursor to create a new .bru file
3. **Add Authentication**: Request authentication setup
4. **Include Tests**: Add comprehensive test coverage
5. **Environment Variables**: Set up environment-specific values
6. **Refine and Test**: Iterate based on your API requirements

With the Bruno-specific rules in place, Cursor becomes a powerful assistant for API development, understanding the unique requirements of Bruno's file-based, Git-collaborative approach.
