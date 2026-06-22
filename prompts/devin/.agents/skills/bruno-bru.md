# Bruno API Client — Devin Skills File (Legacy Bru Format)

## What is Bruno?
Bruno is a Git-first, offline-only API client that stores collections directly in the filesystem using a plain text markup language called "Bru".

> For the newer YAML/OpenCollection format (Bruno v3.1+), see `bruno.md`.

## Key Features
- **Protocols**: HTTP/REST, GraphQL, gRPC, WebSocket, SOAP
- **Scripting**: JavaScript pre-request and post-response scripts
- **Testing**: Built-in Chai.js assertions
- **Environments**: Multiple environments with variable and secret support
- **CLI**: Run collections in CI/CD pipelines via `bru` CLI

## Collection Directory Structure
```
My Collection/
├── bruno.json                # Collection metadata (REQUIRED)
├── collection.bru            # Collection-level settings
├── environments/             # Environment files (.bru)
│   ├── Local.bru
│   └── Production.bru
├── Get User.bru              # Request files
├── Create User.bru
└── Users/                    # Subfolder
    ├── folder.bru
    └── Get User by ID.bru
```

## Collection Metadata (bruno.json)
```json
{
  "version": "1",
  "name": "API Collection",
  "type": "collection"
}
```

## Request File Structure (.bru)
```bru
meta {
  name: Create User
  type: http
  seq: 1
}

post {
  url: {{baseUrl}}/api/users
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
    "name": "{{userName}}",
    "email": "{{userEmail}}"
  }
}

script:pre-request {
  bru.setVar("timestamp", Date.now());
}

script:post-response {
  if (res.status === 201) {
    bru.setVar("newUserId", res.body.id);
  }
}

tests {
  test("User created", function() {
    expect(res.status).to.equal(201);
    expect(res.body).to.have.property("id");
  });
}
```

## Environment Files (.bru)
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

## Authentication Patterns
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

## Body Types
```bru
# JSON
body:json {
  { "key": "value" }
}

# Form URL Encoded
body:form-urlencoded {
  key1: value1
  key2: value2
}

# XML
body:xml {
  <?xml version="1.0"?>
  <root><element>value</element></root>
}
```

## JavaScript API Reference

### Request Object (req)
- `req.getUrl()` / `req.setUrl(url)`
- `req.getMethod()` / `req.setMethod(method)`
- `req.getHeader(name)` / `req.setHeader(name, value)`
- `req.getBody()` / `req.setBody(body)`
- `req.setTimeout(ms)`

### Response Object (res)
- `res.status` — HTTP status code
- `res.statusText` — HTTP status text
- `res.headers` — Response headers object
- `res.body` — Parsed response body
- `res.responseTime` — Response time in milliseconds

### Bruno Runtime (bru)
- `bru.setVar(key, value)` / `bru.getVar(key)` — Runtime variables
- `bru.setEnvVar(key, value)` / `bru.getEnvVar(key)` — Environment variables
- `bru.getProcessEnv(key)` — System environment variables
- `bru.setNextRequest(name)` — Chain requests
- `bru.sleep(ms)` — Pause execution
- `bru.interpolate(string)` — Interpolate variables
- `bru.cookies.jar()` — Cookie management

### Dynamic Variables
- `{{$guid}}` — Random GUID
- `{{$timestamp}}` — Current timestamp
- `{{$randomInt}}` — Random integer
- `{{$randomEmail}}`, `{{$randomFirstName}}`, `{{$randomLastName}}`
- `{{$randomCity}}`, `{{$randomCountry}}`, `{{$randomPhoneNumber}}`

## Testing with Chai.js
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
    expect(res.responseTime).to.be.below(2000);
  });
}
```

## Common Mistakes
- Using JSON format instead of `.bru` plain text
- Missing `bruno.json` metadata file
- Using `info:` instead of `meta {}` for request metadata
- Putting tests outside the `tests {}` block
