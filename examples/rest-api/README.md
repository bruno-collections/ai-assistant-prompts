# REST API Example Collection

This example demonstrates how to use Bruno AI Assistant prompts with a typical REST API collection.

## Collection Structure

```
rest-api/
├── bruno.json                 # Collection metadata
├── environments/
│   ├── development.bru        # Development environment
│   └── production.bru         # Production environment
├── users/
│   ├── get-user.bru          # Get user profile
│   └── create-user.bru       # Create new user
└── README.md                 # This file
```

## Features Demonstrated

### 1. Environment Management
- **Development vs Production**: Different base URLs and timeouts
- **Secret Variables**: API keys and tokens stored securely
- **Environment-Specific Settings**: Debug flags and retry counts

### 2. Request Patterns
- **GET Request**: Retrieving user profile with authentication
- **POST Request**: Creating new user with validation
- **Headers**: Standard and custom headers
- **Authentication**: Bearer token authentication

### 3. Scripting Examples
- **Pre-request Scripts**: 
  - Request ID generation
  - Input validation
  - Default value setting
  - Debug logging
- **Post-response Scripts**:
  - Data extraction
  - Error handling
  - Rate limit detection
  - Success logging

### 4. Testing Patterns
- **Status Code Validation**: Checking for expected response codes
- **Data Validation**: Verifying response structure and types
- **Performance Testing**: Response time assertions
- **Header Validation**: Checking required headers
- **Business Logic Testing**: Email format validation

### 5. Variable Usage
- **Environment Variables**: `{{baseUrl}}`, `{{apiKey}}`
- **Request Variables**: User input data
- **Response Variables**: Extracted data for subsequent requests
- **Dynamic Variables**: Generated request IDs and timestamps

## How to Use with AI Assistants

### 1. Copy Prompt Files
Copy the appropriate prompt files from this repository to your Bruno project:

```bash
# For Cursor AI
cp prompts/cursor/.cursorrules /path/to/your/project/

# For GitHub Copilot
cp prompts/copilot/.github/copilot-instructions.md /path/to/your/project/.github/

# For VS Code AI Extensions
cp prompts/vscode/.vscode/ai-instructions.md /path/to/your/project/.vscode/
```

### 2. Ask AI Assistant for Help

#### Creating New Requests
```
"Create a new .bru file for updating a user profile with PUT method"
```

#### Adding Tests
```
"Add comprehensive tests to this .bru file for error handling and validation"
```

#### Environment Setup
```
"Create a staging environment file with appropriate variables"
```

#### Script Enhancement
```
"Add a pre-request script that validates the user ID format"
```

### 3. Expected AI Behavior

With the prompts in place, your AI assistant should:
- ✅ Generate valid .bru file syntax
- ✅ Include proper meta blocks with name, type, and sequence
- ✅ Use environment variables correctly
- ✅ Add comprehensive tests with Chai.js assertions
- ✅ Include error handling in scripts
- ✅ Follow Bruno's best practices
- ✅ Maintain the Git-collaborative, offline-first approach

### 4. Common AI Assistant Requests

#### Request Creation
```
AI: Create a DELETE request for removing a user

Expected Output:
meta {
  name: Delete User
  type: http
  seq: 3
}

delete {
  url: {{baseUrl}}/api/{{apiVersion}}/users/{{userId}}
  body: none
  auth: bearer
}

# ... rest of the .bru file
```

#### Test Addition
```
AI: Add tests for a 404 error response

Expected Output:
tests {
  test("Handles user not found", function() {
    if (res.status === 404) {
      expect(res.body).to.have.property("error");
      expect(res.body.error).to.include("not found");
    }
  });
}
```

## Tips for Better AI Assistance

1. **Be Specific**: Mention you're working with Bruno and .bru files
2. **Provide Context**: Share the existing file structure
3. **Include Requirements**: Specify authentication, validation, or testing needs
4. **Reference Examples**: Point to similar requests in your collection
5. **Mention Environment**: Specify which environment variables to use

## Troubleshooting

### AI Not Using .bru Format
- Ensure prompt files are in the correct location
- Restart your editor to reload configurations
- Explicitly mention "Bruno .bru format" in your requests

### Missing Bruno-Specific Features
- Check that your AI assistant supports the prompt file format
- Update prompt files if Bruno's syntax has changed
- Provide additional context about Bruno's unique features

This example collection serves as a reference for both AI assistants and developers working with Bruno collections.
