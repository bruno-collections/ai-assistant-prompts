# GitHub Copilot Instructions for Bruno API Client

## About Bruno
Bruno is an innovative API client that stores collections directly in the filesystem using a plain text markup language called "Bru". It's designed as a Git-first, offline-only alternative to Postman.

## Core Concepts for Copilot

### Bru File Format
When suggesting code for `.bru` files, use this structure:
```bru
meta {
  name: Request Name
  type: http
  seq: 1
}

get {
  url: {{baseUrl}}/endpoint
  body: none
  auth: none
}

headers {
  content-type: application/json
}

body:json {
  {
    "key": "value"
  }
}

script:pre-request {
  bru.setVar("timestamp", Date.now());
}

tests {
  test("Status is 200", function() {
    expect(res.status).to.equal(200);
  });
}
```

### Key Packages
- `bruno-app`: React frontend
- `bruno-electron`: Electron main process
- `bruno-cli`: Command-line interface
- `bruno-lang`: Bru language parser
- `bruno-filestore`: File operations
- `bruno-requests`: Request execution

### Variable Syntax
- Environment variables: `{{variableName}}`
- Setting variables: `bru.setVar("name", "value")`
- Getting variables: `bru.getVar("name")`

### Environment Files
```bru
vars {
  baseUrl: https://api.example.com
  apiKey: your-key-here
}

vars:secret [
  secretToken,
  password
]
```

### Common Patterns
1. **Request Structure**: Always include meta block with name, type, seq
2. **Authentication**: Use auth block or authorization header
3. **Testing**: Use Chai.js assertions in tests block
4. **Scripts**: Pre-request for setup, post-response for data extraction
5. **Variables**: Use environment variables for reusable values

### File Organization
- `collection.bru`: Collection-level settings
- `bruno.json`: Collection metadata
- `environments/`: Environment files
- Individual `.bru` files for requests
- Folders can have `folder.bru` for shared settings

### Development Guidelines
- Always use .bru format, never JSON for requests
- Maintain offline-first approach
- Consider Git collaboration in file structure
- Use modular package architecture
- Test with real API scenarios

### JavaScript Runtime (Scripts)
Available objects in pre-request and post-response scripts:
- `bru`: Variable management and utilities
- `req`: Request object (in post-response)
- `res`: Response object (in post-response)
- Standard JavaScript APIs
- Chai.js for assertions in tests

### Request Types Supported
- HTTP requests (GET, POST, PUT, DELETE, etc.)
- GraphQL queries and mutations
- gRPC calls
- WebSocket connections

When generating Bruno-related code, prioritize the .bru file format and Git-collaborative workflow.
