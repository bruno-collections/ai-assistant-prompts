# GitHub Copilot Instructions for Bruno API Client

## About Bruno
Bruno is an innovative API client that stores API collections directly in your filesystem using a plain text markup language called "Bru". It's designed as a Git-first, offline-only alternative to Postman, perfect for teams who want to version control their API tests alongside their code.

## Key Features
- **Multiple Protocols**: HTTP/REST, GraphQL, gRPC, WebSocket, SOAP
- **Powerful Scripting**: JavaScript pre-request and post-response scripts
- **Testing Framework**: Built-in Chai.js assertions
- **Environment Management**: Multiple environments with variable support
- **Secret Management**: Secure handling of API keys and tokens
- **CLI Support**: Run collections in CI/CD pipelines

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

## JavaScript API Reference

### Request Object (req)
- `req.getUrl()` / `req.setUrl(url)` - Get/set request URL
- `req.getMethod()` / `req.setMethod(method)` - Get/set HTTP method
- `req.getHeader(name)` / `req.setHeader(name, value)` - Manage headers
- `req.getBody()` / `req.setBody(body)` - Manage request body
- `req.setTimeout(ms)` - Set request timeout

### Response Object (res)
- `res.status` - HTTP status code
- `res.body` - Parsed response body
- `res.headers` - Response headers
- `res.responseTime` - Response time in milliseconds

### Bruno Runtime (bru)
- `bru.setVar(key, value)` / `bru.getVar(key)` - Runtime variables
- `bru.setEnvVar(key, value)` / `bru.getEnvVar(key)` - Environment variables
- `bru.setNextRequest(name)` - Chain requests
- `bru.interpolate(string)` - Interpolate variables
- `bru.cookies.jar()` - Cookie management

### Dynamic Variables
- `{{$guid}}`, `{{$timestamp}}`, `{{$randomInt}}`
- `{{$randomEmail}}`, `{{$randomFirstName}}`, `{{$randomLastName}}`
- `{{$randomPhoneNumber}}`, `{{$randomCity}}`

### Environment Files
```bru
vars {
  baseUrl: https://api.example.com
  apiVersion: v1
}

vars:secret [
  apiKey,
  authToken
]
```

### Common Patterns
1. **Request Structure**: Always include meta block with name, type, seq
2. **Authentication**: Use auth:bearer, auth:basic, or auth:apikey blocks
3. **Testing**: Use Chai.js assertions in tests block
4. **Scripts**: Pre-request for setup, post-response for data extraction
5. **Variables**: Use `{{variableName}}` for environment variables
6. **Secrets**: Store sensitive data in vars:secret blocks
7. **Request Chaining**: Use `bru.setNextRequest()` for workflows

### File Organization
- `collection.bru`: Collection-level settings
- `bruno.json`: Collection metadata
- `environments/`: Environment files (.bru format)
- Individual `.bru` files for each API request
- Folders can have `folder.bru` for shared settings

### Best Practices
- Always use .bru format, never JSON for requests
- Store secrets in vars:secret blocks
- Use environment variables for values that change
- Write comprehensive tests for API responses
- Use meaningful names for requests and folders
- Leverage dynamic variables for test data
- Chain requests for complex workflows
- Keep collections organized for Git collaboration

### Request Types Supported
- **HTTP/REST**: GET, POST, PUT, DELETE, PATCH, etc.
- **GraphQL**: Queries, mutations, subscriptions
- **gRPC**: Protocol buffer based requests
- **WebSocket**: Real-time bidirectional communication
- **SOAP**: XML-based web services

When generating Bruno-related code, prioritize the .bru file format and Git-collaborative workflow.
