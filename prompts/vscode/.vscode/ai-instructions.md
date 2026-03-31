# VS Code AI Instructions for Bruno API Client (YAML / OpenCollection Format)

## What is Bruno?
Bruno is an innovative API client that stores API collections directly in your filesystem. As of **Bruno v3.1**, the default format is **YAML** based on the [OpenCollection specification](https://spec.opencollection.com/). It's designed as a Git-first, offline-only alternative to Postman, perfect for teams who want to version control their API tests alongside their code.

> **Note**: For legacy Bru format instructions, see `ai-instructions-bru.md`.

## Core Features
- **Multiple Protocols**: HTTP/REST, GraphQL, gRPC, WebSocket, SOAP
- **Powerful Scripting**: JavaScript pre-request and post-response scripts
- **Testing Framework**: Built-in Chai.js assertions
- **Environment Management**: Multiple environments with variable support
- **Secret Management**: Secure handling of API keys and tokens
- **CLI Support**: Run collections in CI/CD pipelines
- **YAML Format**: Human-readable, Git-friendly YAML files (OpenCollection spec)

## Collection Directory Structure
```
My Collection/
├── opencollection.yml             # Collection root file (REQUIRED)
├── collection.yml                 # Collection-level settings (optional)
├── environments/                  # Environment files directory
│   ├── Local.yml
│   └── Production.yml
├── Get User.yml                   # Individual request files
├── Create User.yml
└── Users/                         # Subfolder for organization
    ├── folder.yml
    └── Get User by ID.yml
```

### opencollection.yml Format
**ALWAYS include the `opencollection` version header** as the first line. Use the latest version from the [OpenCollection spec](https://spec.opencollection.com/) (currently `1.0.0`).

**Minimal `opencollection.yml`**:
```yaml
opencollection: 1.0.0

info:
  name: Your Collection Name
```

**Full `opencollection.yml`** with optional collection-level fields:
```yaml
opencollection: 1.0.0

info:
  name: Bruno Example
config:
  proxy:
    inherit: true
request:
  variables:
    - name: tokenVar
      value: tokenCollection
      disabled: true
  scripts:
    - type: before-request
      code: // console.log('Collection Level Script Logic')
docs:
  content: |-
    ### Markdown Docs
  type: text/markdown
```

**IMPORTANT**: `opencollection.yml` supports collection-level `info:`, `config:`, `request:` (variables/scripts), and `docs:`. **DO NOT** add request-specific keys like `http:` — those belong in individual request `.yml` files.

### YAML Request Files (.yml)
```yaml
info:
  name: Get User Profile
  type: http
  seq: 1

http:
  method: GET
  url: "{{baseUrl}}/users/{{userId}}"
  headers:
    - name: accept
      value: application/json
  body:
    type: none
  auth:
    type: inherit

runtime:
  scripts:
    - type: before-request
      code: |-
        bru.setVar("timestamp", Date.now());
        bru.setVar("userId", "123");
    - type: after-response
      code: |-
        if (res.status === 200) {
          bru.setVar("userName", res.body.name);
        }
    - type: tests
      code: |-
        test("User profile retrieved successfully", function() {
          expect(res.status).to.equal(200);
          expect(res.body).to.have.property("name");
          expect(res.body).to.have.property("email");
        });

settings:
  encodeUrl: true
```

### Environment Files
```yaml
variables:
  - name: baseUrl
    value: https://api.example.com
  - name: apiVersion
    value: v1
  - name: apiKey
    value: ""
    secret: true
  - name: clientSecret
    value: ""
    secret: true
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
```yaml
# Bearer Token
auth:
  type: bearer
  token: "{{authToken}}"

# Basic Auth
auth:
  type: basic
  username: "{{username}}"
  password: "{{password}}"

# API Key
auth:
  type: apikey
  key: x-api-key
  value: "{{apiKey}}"
  placement: header
```

### Request Body Types
```yaml
# JSON Body
body:
  type: json
  data: |-
    {
      "name": "John Doe",
      "email": "john@example.com"
    }

# Form URL Encoded
body:
  type: form-urlencoded
  data:
    - name: username
      value: john
    - name: password
      value: secret

# XML Body
body:
  type: xml
  data: |-
    <?xml version="1.0"?>
    <user>
      <name>John</name>
    </user>
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
```yaml
runtime:
  scripts:
    - type: tests
      code: |-
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
```

## Best Practices
1. **Use YAML format** for all API definitions (OpenCollection spec)
2. **Store secrets** with `secret: true` in environment files, not in version control
3. **Use environment variables** for values that change across environments
4. **Write comprehensive tests** for status codes, structure, and data
5. **Use meaningful names** for requests and folders
6. **Leverage dynamic variables** for test data generation
7. **Chain requests** using `bru.setNextRequest()` for workflows
8. **Keep collections organized** for easy Git collaboration

## Common Mistakes
- ❌ Missing `opencollection.yml` — every collection MUST have one
- ❌ Using `meta:` instead of `info:` — use `info:` for request metadata
- ❌ Putting `http:` blocks in `opencollection.yml` — request details go in separate `.yml` files
- ❌ Using `test` instead of `tests` for script type
- ❌ Putting tests at root level — they belong under `runtime: scripts:`
- ❌ Using `.yaml` extension — Bruno uses `.yml`

## Common Tasks
- Creating API requests in YAML format
- Setting up multiple environments (dev, staging, prod)
- Writing pre-request scripts for dynamic data
- Adding post-response scripts for data extraction
- Writing comprehensive test assertions
- Organizing collections with folders
- Managing secrets securely
- Chaining requests for complex workflows
- Converting from Postman/Insomnia

When working with Bruno, prioritize the YAML file format (OpenCollection spec), proper directory structure, and Git-collaborative workflow.
