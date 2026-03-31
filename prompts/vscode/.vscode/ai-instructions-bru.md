# VS Code AI Instructions for Bruno API Client

## What is Bruno?
Bruno is an innovative API client that stores API collections directly in your filesystem using a plain text markup language (.bru files). It's designed as a Git-first, offline-only alternative to Postman, perfect for teams who want to version control their API tests alongside their code.

## Core Features
- **Multiple Protocols**: HTTP/REST, GraphQL, gRPC, WebSocket, SOAP
- **Powerful Scripting**: JavaScript pre-request and post-response scripts
- **Testing Framework**: Built-in Chai.js assertions
- **Environment Management**: Multiple environments with variable support
- **Secret Management**: Secure handling of API keys and tokens
- **CLI Support**: Run collections in CI/CD pipelines
- **File-Based Storage**: Everything in plain text, perfect for Git

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

## JavaScript API Reference

### Request Object (req)
- `req.getUrl()` / `req.setUrl(url)` - Get/set request URL
- `req.getMethod()` / `req.setMethod(method)` - Get/set HTTP method
- `req.getHeader(name)` / `req.setHeader(name, value)` - Manage headers
- `req.getBody()` / `req.setBody(body)` - Manage request body
- `req.setTimeout(ms)` - Set request timeout
- `req.getName()` - Get request name
- `req.getTags()` - Get request tags

### Response Object (res)
- `res.status` - HTTP status code
- `res.statusText` - HTTP status text
- `res.headers` - Response headers object
- `res.body` - Parsed response body
- `res.responseTime` - Response time in milliseconds

### Bruno Runtime (bru)
- `bru.setVar(key, value)` / `bru.getVar(key)` - Runtime variables
- `bru.setEnvVar(key, value)` / `bru.getEnvVar(key)` - Environment variables
- `bru.setNextRequest(name)` - Chain requests
- `bru.sleep(ms)` - Pause execution
- `bru.interpolate(string)` - Interpolate variables including dynamic ones
- `bru.cookies.jar()` - Cookie management

### Dynamic Variables
- `{{$guid}}`, `{{$timestamp}}`, `{{$randomInt}}`
- `{{$randomEmail}}`, `{{$randomFirstName}}`, `{{$randomLastName}}`
- `{{$randomPhoneNumber}}`, `{{$randomCity}}`, `{{$randomCountry}}`

## Common Patterns

### Variable Management
```javascript
// Environment variables in .bru files
{{baseUrl}}/api/users

// Runtime variables in scripts
bru.setVar("userId", res.body.id);
const userId = bru.getVar("userId");

// Generate test data
const email = bru.interpolate('{{$randomEmail}}');
```

### Authentication
```bru
auth:bearer {
  token: {{authToken}}
}

auth:basic {
  username: {{username}}
  password: {{password}}
}

auth:apikey {
  key: x-api-key
  value: {{apiKey}}
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

### Pre-Request Scripts
```javascript
// Set dynamic values
bru.setVar("timestamp", Date.now());
bru.setVar("requestId", `req_${Date.now()}`);

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
if (res.body.needsVerification) {
  bru.setNextRequest("Verify Email");
}
```

### Testing Patterns
```javascript
test("Status code is 200", function() {
  expect(res.status).to.equal(200);
});

test("Response structure is correct", function() {
  expect(res.body).to.be.an("object");
  expect(res.body).to.have.property("data");
});

test("Response time is acceptable", function() {
  expect(res.responseTime).to.be.below(2000);
});

test("Data validation", function() {
  expect(res.body.user.email).to.match(/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/);
});
```

### Cookie Management
```javascript
const jar = bru.cookies.jar();
jar.setCookie("https://api.example.com", "sessionId", "abc123");
const cookie = await jar.getCookie("https://api.example.com", "sessionId");
```

## Best Practices
1. **Use .bru format** for all API definitions (never JSON)
2. **Store secrets** in `vars:secret` blocks, not in version control
3. **Use environment variables** for values that change across environments
4. **Write comprehensive tests** for status codes, structure, and data
5. **Use meaningful names** for requests and folders
6. **Leverage dynamic variables** for test data generation
7. **Chain requests** using `bru.setNextRequest()` for workflows
8. **Keep collections organized** for easy Git collaboration

## Common Tasks
- Creating API requests in .bru format
- Setting up multiple environments (dev, staging, prod)
- Writing pre-request scripts for dynamic data
- Adding post-response scripts for data extraction
- Writing comprehensive test assertions
- Organizing collections with folders
- Managing secrets securely
- Chaining requests for complex workflows
- Converting from Postman/Insomnia

When working with Bruno, prioritize the plain text, Git-collaborative approach and always consider the offline-first philosophy.
