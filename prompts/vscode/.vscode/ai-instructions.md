# VS Code AI Instructions for Bruno API Client

## Project Context
Bruno is an innovative API client that revolutionizes API testing by using a plain text markup language (.bru files) stored directly in the filesystem. It's designed as a Git-first, offline-only alternative to Postman.

## Architecture Overview
- **Monorepo Structure**: Multiple packages with specific responsibilities
- **Electron Desktop App**: Cross-platform GUI application
- **CLI Tool**: Command-line interface for automation
- **Custom Language**: Bru markup language for API definitions
- **File-Based Storage**: No databases, everything in plain text files

## Key File Types

### .bru Files (API Requests)
```bru
meta {
  name: Get User Profile
  type: http
  seq: 1
}

get {
  url: {{baseUrl}}/users/{{userId}}
  body: none
  auth: inherit
}

headers {
  accept: application/json
  user-agent: Bruno/1.0
}

script:pre-request {
  // Set dynamic values
  bru.setVar("timestamp", Date.now());
  bru.setVar("userId", "123");
}

script:post-response {
  // Extract response data
  if (res.status === 200) {
    bru.setVar("userName", res.body.name);
  }
}

tests {
  test("User profile retrieved successfully", function() {
    expect(res.status).to.equal(200);
    expect(res.body).to.have.property("name");
    expect(res.body).to.have.property("email");
  });
}
```

### Environment Files
```bru
vars {
  baseUrl: https://api.example.com
  apiVersion: v1
  timeout: 5000
}

vars:secret [
  apiKey,
  clientSecret,
  refreshToken
]
```

### Collection Configuration (bruno.json)
```json
{
  "version": "1",
  "name": "My API Collection",
  "type": "collection",
  "proxy": {
    "enabled": false
  },
  "scripts": {
    "moduleWhitelist": ["crypto", "buffer"]
  }
}
```

## Package Structure
- `bruno-app/`: React frontend application
- `bruno-electron/`: Electron main process and IPC
- `bruno-cli/`: Command-line interface
- `bruno-lang/`: Bru language parser (Ohm.js grammar)
- `bruno-filestore/`: File system operations
- `bruno-requests/`: HTTP/GraphQL/gRPC/WebSocket execution
- `bruno-schema/`: Yup validation schemas
- `bruno-js/`: JavaScript runtime for scripts

## Development Patterns

### Variable Management
- Environment variables: `{{variableName}}`
- Runtime variables: `bru.setVar("key", "value")`
- Secret variables: Stored separately, not in version control

### Authentication
```bru
auth {
  mode: bearer
  token: {{authToken}}
}

# Or in headers
headers {
  authorization: Bearer {{token}}
}
```

### Request Body Types
```bru
# JSON
body:json {
  {
    "name": "John Doe",
    "email": "john@example.com"
  }
}

# Form data
body:form-urlencoded {
  username: john
  password: secret
}

# XML
body:xml {
  <?xml version="1.0"?>
  <user>
    <name>John</name>
  </user>
}
```

### Testing Patterns
```bru
tests {
  test("Response time is acceptable", function() {
    expect(res.responseTime).to.be.below(1000);
  });
  
  test("Response has required fields", function() {
    expect(res.body).to.have.property("id");
    expect(res.body.id).to.be.a("number");
  });
}
```

## Best Practices for AI Assistance
1. **Always use .bru format** for API requests, never JSON
2. **Maintain Git-friendly structure** - human-readable plain text
3. **Use environment variables** for reusable values
4. **Include proper error handling** in scripts
5. **Write meaningful tests** for API responses
6. **Organize requests logically** in folders
7. **Use descriptive names** for requests and variables
8. **Keep secrets separate** using vars:secret blocks

## Common Tasks
- Creating new API requests in .bru format
- Setting up environment configurations
- Writing pre-request and post-response scripts
- Adding comprehensive test assertions
- Organizing collections with proper folder structure
- Converting from other API client formats (Postman, Insomnia)

When working with Bruno, prioritize the plain text, Git-collaborative approach and always consider the offline-first philosophy.
