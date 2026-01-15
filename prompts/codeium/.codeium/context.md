# Codeium Context for Bruno API Client

## Project Overview
Bruno is an innovative API client that stores collections directly in the filesystem using a plain text markup language called "Bru". It's designed as a Git-first, offline-only alternative to Postman.

## Key File Formats

### .bru Files (API Requests)
```bru
meta {
  name: API Request Name
  type: http
  seq: 1
}

post {
  url: {{baseUrl}}/api/endpoint
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
    "key": "value"
  }
}

script:pre-request {
  bru.setVar("timestamp", Date.now());
}

script:post-response {
  if (res.status === 200) {
    bru.setVar("responseId", res.body.id);
  }
}

tests {
  test("Request successful", function() {
    expect(res.status).to.equal(200);
    expect(res.body).to.have.property("id");
  });
}
```

### Environment Files
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

### Collection Metadata (bruno.json)
```json
{
  "version": "1",
  "name": "API Collection",
  "type": "collection"
}
```

## Core Concepts

### Variable Management
- Environment variables: `{{variableName}}`
- Runtime variables: `bru.setVar("key", "value")` and `bru.getVar("key")`
- Secret variables: Listed in `vars:secret` blocks

### Authentication Patterns
```bru
# Bearer Token
auth:bearer {
  token: {{token}}
}

# Basic Auth
auth:basic {
  username: {{username}}
  password: {{password}}
}

# API Key
auth:apikey {
  key: x-api-key
  value: {{apiKey}}
}
```

### Request Body Types
```bru
# JSON Body
body:json {
  {
    "data": "value"
  }
}

# Form Data
body:form-urlencoded {
  key1: value1
  key2: value2
}

# XML Body
body:xml {
  <?xml version="1.0"?>
  <root>
    <element>value</element>
  </root>
}
```

### Testing with Chai.js
```bru
tests {
  test("Status code is 200", function() {
    expect(res.status).to.equal(200);
  });
  
  test("Response has required fields", function() {
    expect(res.body).to.have.property("id");
    expect(res.body.id).to.be.a("number");
  });
  
  test("Response time is acceptable", function() {
    expect(res.responseTime).to.be.below(1000);
  });
}
```

## File Organization
- `bruno.json`: Collection metadata
- `collection.bru`: Collection-level settings
- `environments/`: Environment files (.bru)
- Individual `.bru` files for each request
- Folders can contain `folder.bru` for shared settings

## Development Guidelines
1. Always use .bru format for API requests
2. Use environment variables for reusable values
3. Include comprehensive tests for responses
4. Organize requests logically in folders
5. Use meaningful names and descriptions
6. Keep secrets in vars:secret blocks
7. Consider Git collaboration in file structure
8. Maintain offline-first approach

## Common Patterns
- Pre-request scripts for dynamic data setup
- Post-response scripts for data extraction
- Environment-specific configurations
- Folder-level authentication inheritance
- Comprehensive error handling in scripts

When working with Bruno, prioritize the plain text, Git-collaborative workflow and the unique .bru file format.
