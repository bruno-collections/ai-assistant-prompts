# Bruno AI Assistant Prompts - Refactoring Summary

## Overview
Refactored all AI assistant prompts to focus on **user-facing features** for people using Bruno to test their own APIs, rather than developers working on Bruno's codebase.

## Key Changes

### 1. Removed Internal Package References
**Before:** Prompts referenced Bruno's internal architecture:
- `bruno-app`, `bruno-electron`, `bruno-cli`
- `bruno-lang`, `bruno-filestore`, `bruno-requests`
- React, Redux, Electron implementation details
- Monorepo structure and build systems

**After:** Focus on what users need:
- .bru file format and syntax
- JavaScript API for scripting
- Testing and assertions
- Environment and variable management

### 2. Added Comprehensive JavaScript API Reference
Added detailed documentation for:

#### Request Object (req)
- URL methods: `getUrl()`, `setUrl()`
- HTTP methods: `getMethod()`, `setMethod()`
- Header methods: `getHeader()`, `setHeader()`, `setHeaders()`
- Body methods: `getBody()`, `setBody()`
- Configuration: `setTimeout()`, `setMaxRedirects()`

#### Response Object (res)
- Properties: `status`, `statusText`, `headers`, `body`, `responseTime`
- Methods: `getStatus()`, `getHeader()`, `getBody()`

#### Bruno Runtime (bru)
- Runtime variables: `setVar()`, `getVar()`
- Environment variables: `setEnvVar()`, `getEnvVar()`
- Process environment: `getProcessEnv()`
- Request chaining: `setNextRequest()`
- Utilities: `sleep()`, `cwd()`, `interpolate()`
- Cookie management: `cookies.jar()`

#### Dynamic Variables
- Identity: `{{$guid}}`, `{{$randomEmail}}`, `{{$randomFirstName}}`, etc.
- Location: `{{$randomCity}}`, `{{$randomCountry}}`
- Numbers: `{{$randomInt}}`, `{{$timestamp}}`
- Job/Company: `{{$randomJobTitle}}`, `{{$randomCompanyName}}`

#### Testing Framework
- Chai.js assertions with examples
- Status code validation
- Response structure validation
- Data type checking
- Response time testing

#### Cookie Management
- Creating cookie jars
- Setting/getting cookies
- Cookie options (domain, path, secure, httpOnly, maxAge)
- Deleting cookies

### 3. Enhanced Best Practices
Added user-focused best practices:
- Using .bru format (never JSON)
- Storing secrets in `vars:secret` blocks
- Using environment variables for changing values
- Writing comprehensive tests
- Leveraging dynamic variables for test data
- Chaining requests for workflows
- Organizing collections for Git collaboration

### 4. Added Practical Examples
Included real-world examples for:
- Request chaining workflows
- Conditional testing
- Data-driven testing
- Pre-request script patterns
- Post-response script patterns
- Cookie management
- Error handling

## Files Updated

### Core Prompts
1. **prompts/cursor/.cursorrules** - Cursor AI rules
2. **prompts/general/bruno-ai-context.md** - General AI assistants (Claude, ChatGPT, etc.)
3. **prompts/vscode/.vscode/ai-instructions.md** - VS Code AI extensions
4. **prompts/copilot/.github/copilot-instructions.md** - GitHub Copilot
5. **prompts/codeium/.codeium/context.md** - Codeium
6. **prompts/continue/.continue/config.json** - Continue extension

### Changes Per File
- Removed 20+ lines of internal package references
- Added 100+ lines of JavaScript API documentation
- Added 50+ lines of practical examples
- Enhanced best practices sections

## Impact

### Before
- Prompts were confusing for API users
- Referenced packages users don't have access to
- Missing critical JavaScript API documentation
- Focused on Bruno development, not Bruno usage

### After
- Clear focus on using Bruno for API testing
- Comprehensive JavaScript API reference
- Practical examples for common use cases
- User-friendly best practices
- Ready for teams testing their own APIs

## Next Steps
Users can now:
1. Install prompts in their API collection projects
2. Get accurate AI assistance for creating .bru files
3. Learn the JavaScript API through AI suggestions
4. Build complex workflows with request chaining
5. Write comprehensive tests with proper assertions
6. Manage environments and secrets effectively

