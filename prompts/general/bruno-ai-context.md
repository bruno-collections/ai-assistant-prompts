# Bruno API Client - AI Assistant Context

## What is Bruno?
Bruno is an innovative API client that revolutionizes API testing and development by storing collections directly in the filesystem using a plain text markup language called "Bru". It's designed as a Git-first, offline-only alternative to Postman and similar tools.

## Core Philosophy
- **Offline-First**: No cloud sync, everything stored locally
- **Git-Collaborative**: Collections are designed for version control
- **Plain Text**: Human-readable .bru files for easy collaboration
- **File-Based**: No databases, everything in the filesystem

## Architecture
Bruno is a monorepo with multiple specialized packages:

### Main Packages
- **bruno-app**: React frontend application (UI components, Redux state)
- **bruno-electron**: Electron main process and IPC handlers
- **bruno-cli**: Command-line interface for automation and CI/CD
- **bruno-lang**: Bru language parser using Ohm.js grammar
- **bruno-filestore**: File system operations and format conversion
- **bruno-requests**: HTTP/GraphQL/gRPC/WebSocket request execution
- **bruno-schema**: Yup-based validation schemas
- **bruno-js**: JavaScript runtime environment for scripts

### Technologies Used
- **Frontend**: React, Redux Toolkit, Styled Components, CodeMirror
- **Backend**: Electron, Node.js, Axios
- **Build System**: Rsbuild (modern Webpack alternative)
- **Testing**: Jest, Testing Library
- **Languages**: Primarily JavaScript with some TypeScript

## Bru File Format
The heart of Bruno is the .bru file format - a custom markup language for API requests:

```bru
meta {
  name: Create User
  type: http
  seq: 1
  tags: [user-management, post-request]
}

post {
  url: {{baseUrl}}/api/users
  body: json
  auth: bearer
}

headers {
  content-type: application/json
  accept: application/json
  x-api-version: {{apiVersion}}
}

auth:bearer {
  token: {{authToken}}
}

body:json {
  {
    "name": "{{userName}}",
    "email": "{{userEmail}}",
    "role": "user"
  }
}

script:pre-request {
  // JavaScript executed before request
  const timestamp = Date.now();
  bru.setVar("requestId", `req_${timestamp}`);
  
  // Validate required variables
  if (!bru.getVar("userName")) {
    throw new Error("userName is required");
  }
}

script:post-response {
  // JavaScript executed after response
  if (res.status === 201) {
    bru.setVar("newUserId", res.body.id);
    bru.setVar("userCreated", true);
  }
}

tests {
  test("User created successfully", function() {
    expect(res.status).to.equal(201);
    expect(res.body).to.have.property("id");
    expect(res.body.name).to.equal(bru.getVar("userName"));
  });
  
  test("Response time is acceptable", function() {
    expect(res.responseTime).to.be.below(2000);
  });
}

vars:pre-request {
  userName: John Doe
  userEmail: john@example.com
}

vars:post-response {
  userId: {{res.body.id}}
  createdAt: {{res.body.created_at}}
}
```

## File Structure
A typical Bruno collection has this structure:
```
my-api-collection/
├── bruno.json              # Collection metadata
├── collection.bru          # Collection-level settings
├── environments/
│   ├── dev.bru            # Development environment
│   ├── staging.bru        # Staging environment
│   └── prod.bru           # Production environment
├── users/
│   ├── folder.bru         # Folder-level settings
│   ├── get-user.bru       # Individual request
│   ├── create-user.bru    # Individual request
│   └── update-user.bru    # Individual request
└── auth/
    ├── login.bru
    └── refresh-token.bru
```

## Environment Files
Environment files define variables and secrets:

```bru
vars {
  baseUrl: https://api.example.com
  apiVersion: v1
  timeout: 5000
  retries: 3
}

vars:secret [
  apiKey,
  clientSecret,
  refreshToken
]
```

## Collection Configuration (bruno.json)
```json
{
  "version": "1",
  "name": "My API Collection",
  "type": "collection",
  "proxy": {
    "enabled": false,
    "protocol": "http",
    "hostname": "localhost",
    "port": 8080
  },
  "scripts": {
    "moduleWhitelist": ["crypto", "buffer", "form-data"],
    "filesystemAccess": {
      "allow": true
    }
  },
  "clientCertificates": {
    "enabled": false,
    "certs": []
  }
}
```

## Key Concepts for AI Assistance

### Variable System
- **Environment Variables**: `{{variableName}}` - defined in environment files
- **Runtime Variables**: Set/get with `bru.setVar()` and `bru.getVar()`
- **Secret Variables**: Stored separately, not in version control
- **Collection Variables**: Shared across all requests in collection
- **Folder Variables**: Shared within a folder
- **Request Variables**: Specific to individual requests

### Authentication Types
- Bearer Token: `auth:bearer { token: {{token}} }`
- Basic Auth: `auth:basic { username: user, password: pass }`
- API Key: `auth:apikey { key: x-api-key, value: {{apiKey}} }`
- OAuth2: Complex flow with multiple configuration options
- AWS Signature: For AWS API requests
- Digest Auth: For digest authentication

### Request Types Supported
- **HTTP**: Standard REST API requests
- **GraphQL**: Queries, mutations, subscriptions
- **gRPC**: Protocol buffer based requests
- **WebSocket**: Real-time communication

### Testing Framework
Uses Chai.js for assertions:
```javascript
test("Response validation", function() {
  expect(res.status).to.equal(200);
  expect(res.body).to.be.an("object");
  expect(res.body).to.have.property("data");
  expect(res.headers["content-type"]).to.include("application/json");
});
```

## Best Practices When Working with Bruno
1. **Always use .bru format** - Never suggest JSON for request definitions
2. **Embrace the file-based approach** - Each request is a separate file
3. **Use environment variables** for reusable values across environments
4. **Write comprehensive tests** for API responses
5. **Organize logically** with folders and meaningful names
6. **Include error handling** in pre/post-request scripts
7. **Document with meaningful names** and descriptions
8. **Keep secrets secure** using the vars:secret mechanism
9. **Consider Git workflow** when structuring collections
10. **Test across environments** using different environment files

## Common Use Cases
- API development and testing
- API documentation with examples
- Automated testing in CI/CD pipelines
- Team collaboration on API collections
- Converting from Postman/Insomnia collections
- Integration testing for microservices
- API monitoring and health checks

When helping with Bruno-related tasks, always prioritize the plain text, Git-collaborative approach and maintain the offline-first philosophy that makes Bruno unique.
