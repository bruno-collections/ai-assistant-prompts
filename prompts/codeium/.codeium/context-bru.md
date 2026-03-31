# Codeium Context for Bruno API Client

## What is Bruno?
Bruno is an innovative API client that stores API collections directly in your filesystem using a plain text markup language called "Bru". It's designed as a Git-first, offline-only alternative to Postman, perfect for teams who want to version control their API tests alongside their code.

## Key Features
- **Multiple Protocols**: HTTP/REST, GraphQL, gRPC, WebSocket, SOAP
- **Powerful Scripting**: JavaScript pre-request and post-response scripts
- **Testing Framework**: Built-in Chai.js assertions
- **Environment Management**: Multiple environments with variable support
- **Secret Management**: Secure handling of API keys and tokens
- **CLI Support**: Run collections in CI/CD pipelines

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

## JavaScript API Reference

### Request Object (req)
Available in pre-request and test scripts:
- `req.getUrl()` / `req.setUrl(url)` - Get/set request URL
- `req.getMethod()` / `req.setMethod(method)` - Get/set HTTP method
- `req.getHeader(name)` / `req.setHeader(name, value)` - Manage headers
- `req.getBody()` / `req.setBody(body)` - Manage request body
- `req.setTimeout(ms)` - Set request timeout
- `req.getName()` - Get request name
- `req.getTags()` - Get request tags

### Response Object (res)
Available in post-response scripts and tests:
- `res.status` - HTTP status code
- `res.statusText` - HTTP status text
- `res.headers` - Response headers object
- `res.body` - Parsed response body
- `res.responseTime` - Response time in milliseconds
- `res.getHeader(name)` - Get specific header

### Bruno Runtime (bru)
Core scripting API:
- `bru.setVar(key, value)` / `bru.getVar(key)` - Runtime variables
- `bru.setEnvVar(key, value)` / `bru.getEnvVar(key)` - Environment variables
- `bru.getProcessEnv(key)` - System environment variables
- `bru.setNextRequest(name)` - Chain requests
- `bru.sleep(ms)` - Pause execution
- `bru.interpolate(string)` - Interpolate variables
- `bru.cookies.jar()` - Cookie management

### Dynamic Variables
Generate random test data:
- `{{$guid}}` - Random GUID
- `{{$timestamp}}` - Current timestamp
- `{{$randomInt}}` - Random integer
- `{{$randomEmail}}` - Random email
- `{{$randomFirstName}}` / `{{$randomLastName}}` - Random names
- `{{$randomPhoneNumber}}` - Random phone number
- `{{$randomCity}}` / `{{$randomCountry}}` - Random locations

## Core Concepts

### Variable Management
- **Environment variables**: `{{variableName}}` in .bru files
- **Runtime variables**: `bru.setVar("key", "value")` and `bru.getVar("key")`
- **Secret variables**: Listed in `vars:secret` blocks
- **Dynamic variables**: `{{$randomEmail}}` etc. for test data

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

## Best Practices
1. **Use .bru format** for all API definitions (never JSON)
2. **Store secrets** in `vars:secret` blocks, not in version control
3. **Use environment variables** for values that change across environments
4. **Write comprehensive tests** for status codes, structure, and data
5. **Use meaningful names** for requests and folders
6. **Leverage dynamic variables** for test data generation
7. **Chain requests** using `bru.setNextRequest()` for workflows
8. **Keep collections organized** for easy Git collaboration
9. **Add error handling** in pre-request scripts
10. **Test across environments** using different environment files

## Common Patterns

### Pre-Request Scripts
```javascript
// Generate test data
const email = bru.interpolate('{{$randomEmail}}');
bru.setVar("testEmail", email);

// Validate required variables
if (!bru.getEnvVar("apiKey")) {
  throw new Error("API key is required");
}
```

### Post-Response Scripts
```javascript
// Extract and store data
if (res.status === 200) {
  bru.setVar("userId", res.body.id);
  bru.setVar("authToken", res.body.token);
}

// Chain to next request
bru.setNextRequest("Get User Profile");
```

### Request Chaining
```javascript
// In login request post-response
if (res.status === 200) {
  bru.setVar("authToken", res.body.token);
  bru.setNextRequest("Get User Profile");
}
```

When working with Bruno, prioritize the plain text, Git-collaborative workflow and the unique .bru file format.
