# Codeium Context for Bruno API Client (YAML / OpenCollection Format)

## What is Bruno?
Bruno is an innovative API client that stores API collections directly in your filesystem. As of **Bruno v3.1**, the default format is **YAML** based on the [OpenCollection specification](https://spec.opencollection.com/). It's designed as a Git-first, offline-only alternative to Postman, perfect for teams who want to version control their API tests alongside their code.

> **Note**: For legacy Bru format context, see `context-bru.md`.

## Key Features
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

## YAML Request File Structure

### Key File Formats — Request Files (.yml)
```yaml
info:
  name: API Request Name
  type: http
  seq: 1

http:
  method: POST
  url: "{{baseUrl}}/api/endpoint"
  headers:
    - name: content-type
      value: application/json
  body:
    type: json
    data: |-
      {
        "key": "value"
      }
  auth:
    type: bearer
    token: "{{authToken}}"

runtime:
  scripts:
    - type: before-request
      code: |-
        bru.setVar("timestamp", Date.now());
    - type: after-response
      code: |-
        if (res.status === 200) {
          bru.setVar("responseId", res.body.id);
        }
    - type: tests
      code: |-
        test("Request successful", function() {
          expect(res.status).to.equal(200);
          expect(res.body).to.have.property("id");
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
  - name: authToken
    value: ""
    secret: true
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
- **Environment variables**: `{{variableName}}` in `.yml` files
- **Runtime variables**: `bru.setVar("key", "value")` and `bru.getVar("key")`
- **Secret variables**: Use `secret: true` in environment files
- **Dynamic variables**: `{{$randomEmail}}` etc. for test data

### Authentication Patterns
```yaml
# Bearer Token
auth:
  type: bearer
  token: "{{token}}"

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

### Body Types
```yaml
# JSON Body
body:
  type: json
  data: |-
    {
      "data": "value"
    }

# Form URL Encoded
body:
  type: form-urlencoded
  data:
    - name: key1
      value: value1

# XML Body
body:
  type: xml
  data: |-
    <?xml version="1.0"?>
    <root>
      <element>value</element>
    </root>
```

### Testing with Chai.js
```yaml
runtime:
  scripts:
    - type: tests
      code: |-
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
```

## File Organization
- `opencollection.yml`: Collection root file (REQUIRED — must include `opencollection` version header)
- `collection.yml`: Collection-level settings
- `environments/`: Environment files (`.yml`)
- Individual `.yml` files for each request
- Folders can contain `folder.yml` for shared settings

## Best Practices
1. **Use YAML format** for all API definitions (OpenCollection spec)
2. **Store secrets** with `secret: true` in environment files, not in version control
3. **Use environment variables** for values that change across environments
4. **Write comprehensive tests** for status codes, structure, and data
5. **Use meaningful names** for requests and folders
6. **Leverage dynamic variables** for test data generation
7. **Chain requests** using `bru.setNextRequest()` for workflows
8. **Keep collections organized** for easy Git collaboration
9. **Add error handling** in pre-request scripts
10. **Test across environments** using different environment files

## Common Mistakes
- ❌ Missing `opencollection.yml` — every collection MUST have one
- ❌ Using `meta:` instead of `info:` — use `info:` for request metadata
- ❌ Putting `http:` blocks in `opencollection.yml` — request details go in separate `.yml` files
- ❌ Using `test` instead of `tests` for script type
- ❌ Putting tests at root level — they belong under `runtime: scripts:`
- ❌ Using `.yaml` extension — Bruno uses `.yml`

When working with Bruno, prioritize the YAML file format (OpenCollection spec), proper directory structure, and Git-collaborative workflow.
