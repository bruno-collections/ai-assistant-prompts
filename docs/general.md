# General AI Assistants Setup for Bruno

This guide covers using the Bruno AI context with general AI assistants like Claude, ChatGPT, Gemini, and others that don't have automatic file discovery.

## 🚀 Quick Setup

### Download Context File
```bash
curl -fsSL https://raw.githubusercontent.com/bruno-collections/bruno-ai-assistant-prompts/main/prompts/general/bruno-ai-context.md -o bruno-ai-context.md
```

### Usage
1. Copy the contents of `bruno-ai-context.md`
2. Paste into your AI assistant conversation
3. Add: "Please use this context when helping me with Bruno development"

## 🤖 Supported AI Assistants

### Claude (Anthropic)
- **Best Practice**: Paste context at start of conversation
- **Tip**: Claude excels at understanding complex file formats like .bru
- **Usage**: Great for architectural questions and complex request generation

### ChatGPT (OpenAI)
- **Best Practice**: Include context in system message or first prompt
- **Tip**: Works well for step-by-step guidance and code generation
- **Usage**: Excellent for learning Bruno concepts and troubleshooting

### Gemini (Google)
- **Best Practice**: Provide context early in conversation
- **Tip**: Good at understanding relationships between files
- **Usage**: Helpful for organizing collections and environment setup

### Other AI Assistants
- **Perplexity**: Great for research and finding Bruno-specific solutions
- **Poe**: Works with multiple models, paste context for each new chat
- **Character.AI**: Less suitable for technical development tasks

## 📋 Context Usage Template

### Initial Prompt Template
```
I'm working with Bruno API Client, which uses a unique .bru file format for API requests. Here's the context about Bruno:

[Paste bruno-ai-context.md contents here]

Please use this context when helping me with Bruno development. I need help with [specific task].
```

### Follow-up Prompts
```
Remember that I'm working with Bruno API Client and the .bru file format. Can you help me [specific request]?
```

## 🎯 Common Use Cases

### Creating New Requests
**Prompt**:
```
Using the Bruno .bru format, create a POST request to create a new user with:
- Bearer token authentication
- JSON body with name, email, and role
- Comprehensive tests for success and error cases
```

### Environment Setup
**Prompt**:
```
Create a Bruno environment file for a staging environment with:
- Base URL for staging API
- API version variable
- Secret variables for API key and client secret
```

### Converting from Other Formats
**Prompt**:
```
Convert this Postman collection JSON to Bruno .bru format:
[paste Postman JSON]
```

### Debugging Issues
**Prompt**:
```
I'm having issues with this Bruno .bru file. Can you help identify what's wrong?
[paste .bru file content]
```

## 💡 Best Practices

### Providing Context
1. **Always mention Bruno**: Start with "I'm working with Bruno API Client"
2. **Specify file format**: Mention ".bru file format" explicitly
3. **Include examples**: Share existing .bru files for reference
4. **Mention constraints**: Remind about offline-first philosophy

### Getting Better Results
1. **Be specific**: "Create a Bruno .bru file" vs "Create an API request"
2. **Include requirements**: Authentication, validation, error handling
3. **Reference documentation**: Mention Bruno's Git-collaborative approach
4. **Iterate**: Build requests step by step

### Maintaining Context
1. **Refresh context**: Re-paste context if conversation gets long
2. **Remind about Bruno**: Mention Bruno in follow-up questions
3. **Correct mistakes**: Point out when AI suggests non-Bruno formats

## 🔄 Workflow Examples

### New Project Setup
1. **Share context**: Paste bruno-ai-context.md
2. **Explain project**: Describe your API and requirements
3. **Request structure**: Ask for collection organization
4. **Create environments**: Set up dev/staging/prod environments
5. **Build requests**: Create individual .bru files

### Existing Project Enhancement
1. **Share context**: Include Bruno context
2. **Show current structure**: Share existing .bru files
3. **Explain needs**: What you want to add or improve
4. **Get suggestions**: Ask for specific improvements
5. **Implement changes**: Apply AI suggestions

### Troubleshooting
1. **Provide context**: Include Bruno background
2. **Share problem**: Describe the issue you're facing
3. **Include files**: Share relevant .bru files
4. **Get diagnosis**: Let AI analyze the problem
5. **Apply solution**: Implement suggested fixes

## 🐛 Common Issues

### AI Suggests Wrong Format
**Problem**: AI suggests JSON instead of .bru format
**Solution**: Remind about Bruno and .bru format explicitly

### Missing Bruno Features
**Problem**: AI doesn't understand Bruno-specific concepts
**Solution**: Re-paste the context and emphasize Bruno's unique features

### Generic Suggestions
**Problem**: AI gives generic API client advice
**Solution**: Emphasize Bruno's file-based, Git-collaborative approach

## 📊 Effectiveness Tips

### Measuring Success
- ✅ AI suggests .bru syntax
- ✅ Mentions environment variables with `{{}}` syntax
- ✅ Includes proper meta blocks
- ✅ Suggests Chai.js for testing
- ✅ Considers Git collaboration

### Red Flags
- ❌ Suggests JSON for request definitions
- ❌ Ignores environment variables
- ❌ Recommends database storage
- ❌ Suggests cloud-based solutions

## 🔗 Related Resources

- [Bruno Documentation](https://docs.usebruno.com)
- [Bruno GitHub Repository](https://github.com/usebruno/bruno)
- [Bru Language Specification](https://github.com/usebruno/bruno/tree/main/packages/bruno-lang)

## 📝 Example Conversations

### Creating a Complete Request
```
User: Using Bruno, create a complete user registration endpoint

AI: I'll create a Bruno .bru file for user registration:

meta {
  name: User Registration
  type: http
  seq: 1
}

post {
  url: {{baseUrl}}/api/auth/register
  body: json
  auth: none
}

headers {
  content-type: application/json
}

body:json {
  {
    "email": "{{userEmail}}",
    "password": "{{userPassword}}",
    "firstName": "{{firstName}}",
    "lastName": "{{lastName}}"
  }
}

tests {
  test("Registration successful", function() {
    expect(res.status).to.equal(201);
    expect(res.body).to.have.property("token");
    expect(res.body).to.have.property("user");
  });
}
```

This approach ensures you get Bruno-specific, accurate assistance from any AI assistant, maintaining the unique benefits of Bruno's file-based, Git-collaborative approach.
