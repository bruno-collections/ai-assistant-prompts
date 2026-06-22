# Bruno API Client — Devin Skills File (YAML / OpenCollection Format)

## What is Bruno?
Bruno is a Git-first, offline-only API client that stores collections directly in the filesystem. As of **Bruno v3.1**, the default format is **YAML** based on the [OpenCollection specification](https://spec.opencollection.com/).

> For legacy Bru format, see `bruno-bru.md`.

## Key Features
- **Protocols**: HTTP/REST, GraphQL, gRPC, WebSocket, SOAP
- **Scripting**: JavaScript pre-request and post-response scripts
- **Testing**: Built-in Chai.js assertions
- **Environments**: Multiple environments with variable and secret support
- **CLI**: Run collections in CI/CD pipelines via `bru` CLI
- **Format**: Human-readable, Git-friendly YAML (OpenCollection spec)

## Collection Directory Structure
```
My Collection/
├── opencollection.yml             # Collection root (REQUIRED)
├── collection.yml                 # Collection-level settings (optional)
├── environments/                  # Environment files
│   ├── Local.yml
│   └── Production.yml
├── Get User.yml                   # Request files
├── Create User.yml
└── Users/                         # Subfolder
    ├── folder.yml
    └── Get User by ID.yml
```

## opencollection.yml (REQUIRED)
Always include the `opencollection` version header as the first line:

```yaml
opencollection: 1.0.0

info:
  name: Your Collection Name
```

Full example with optional fields:
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

**Do NOT** put request-specific keys (`http:`, `method:`, `url:`) in `opencollection.yml` — those belong in individual request `.yml` files.

## Request File Structure (.yml)
```yaml
info:
  name: Create User
  type: http
  seq: 1

http:
  method: POST
  url: "{{baseUrl}}/api/users"
  headers:
    - name: content-type
      value: application/json
  body:
    type: json
    data: |-
      {
        "name": "{{userName}}",
        "email": "{{userEmail}}"
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
        if (res.status === 201) {
          bru.setVar("newUserId", res.body.id);
        }
    - type: tests
      code: |-
        test("User created", function() {
          expect(res.status).to.equal(201);
          expect(res.body).to.have.property("id");
        });

settings:
  encodeUrl: true
```

## Environment Files
```yaml
variables:
  - name: baseUrl
    value: https://api.example.com
  - name: apiKey
    value: ""
    secret: true
```

## Authentication Types
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

Supported types: `none`, `inherit`, `basic`, `bearer`, `apikey`, `digest`, `oauth2`, `awsv4`, `ntlm`.

## Body Types
```yaml
# JSON
body:
  type: json
  data: |-
    { "key": "value" }

# Form URL Encoded
body:
  type: form-urlencoded
  data:
    - name: key1
      value: value1

# XML
body:
  type: xml
  data: |-
    <?xml version="1.0"?>
    <root><element>value</element></root>

# Multipart Form
body:
  type: multipart-form
  data:
    - name: file
      value: "@file(/path/to/file.jpg)"
```

## JavaScript API Reference

### Request Object (req) — available in `before-request` scripts
- `req.getUrl()` / `req.setUrl(url)`
- `req.getMethod()` / `req.setMethod(method)`
- `req.getHeader(name)` / `req.setHeader(name, value)`
- `req.getBody()` / `req.setBody(body)`
- `req.setTimeout(ms)`

### Response Object (res) — available in `after-response` and `tests` scripts
- `res.status` — HTTP status code
- `res.statusText` — HTTP status text
- `res.headers` — Response headers object
- `res.body` — Parsed response body
- `res.responseTime` — Response time in milliseconds
- `res.getHeader(name)`

### Bruno Runtime (bru) — available in all scripts
- `bru.setVar(key, value)` / `bru.getVar(key)` — Runtime variables
- `bru.setEnvVar(key, value)` / `bru.getEnvVar(key)` — Environment variables
- `bru.getProcessEnv(key)` — System environment variables
- `bru.setNextRequest(name)` — Chain requests
- `bru.sleep(ms)` — Pause execution
- `bru.interpolate(string)` — Interpolate variables
- `bru.cookies.jar()` — Cookie management

### Dynamic Variables
- `{{$guid}}` / `{{$randomUUID}}` — Random identifiers
- `{{$timestamp}}` / `{{$isoTimestamp}}` — Timestamps
- `{{$randomInt}}` — Random integer
- `{{$randomEmail}}`, `{{$randomFirstName}}`, `{{$randomLastName}}`
- `{{$randomCity}}`, `{{$randomCountry}}`, `{{$randomPhoneNumber}}`

## Testing with Chai.js
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
          expect(res.responseTime).to.be.below(2000);
        });
```

## Declarative Assertions
```yaml
runtime:
  assertions:
    - expression: res.status
      operator: eq
      value: "200"
    - expression: res.body.success
      operator: eq
      value: "true"
    - expression: res.body.data
      operator: isJson
```

Operators: `eq`, `neq`, `lt`, `lte`, `gt`, `gte`, `contains`, `startsWith`, `endsWith`, `isNumber`, `isString`, `isBoolean`, `isJson`, `isArray`, `isEmpty`, `isNull`, `isUndefined`, `isTrue`, `isFalse`.

## Bruno CLI (CI/CD)
```bash
bru run --env Production                          # Run with environment
bru run --env Production --reporter-html results.html  # HTML report
bru run --env Demo-Env "Product Update Flow"      # Run specific folder
```

Always specify `working-directory` pointing to the collection root in CI pipelines.

## Common Mistakes
- Missing `opencollection.yml` — every collection MUST have one
- Using `meta:` instead of `info:` — use `info:` for request metadata
- Putting `http:` in `opencollection.yml` — request details go in separate `.yml` files
- Using `test` instead of `tests` for script type
- Putting tests at root level — they belong under `runtime: scripts:`
- Using `.yaml` extension — Bruno uses `.yml`
