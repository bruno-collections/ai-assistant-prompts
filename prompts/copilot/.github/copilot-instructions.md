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

### Collection Directory Structure
**CRITICAL**: Bruno collections have a specific directory structure that MUST be followed:

```
My Collection/
├── bruno.json                    # Collection metadata (REQUIRED)
├── collection.bru                # Collection-level settings (optional)
├── .gitignore                    # Git ignore file
├── environments/                 # Environment files directory
│   ├── Local.bru
│   ├── Production.bru
│   └── Staging.bru
├── folder.bru                    # Folder-level settings (optional)
├── Get User.bru                  # Individual request files
├── Create User.bru
└── Users/                        # Subfolder for organization
    ├── folder.bru                # Folder metadata
    ├── Get User by ID.bru
    └── Update User.bru
```

**Key Rules**:
1. **bruno.json is REQUIRED** at the collection root - this identifies it as a Bruno collection
2. **Request files** use `.bru` extension and contain a single API request
3. **Folder files** named `folder.bru` contain folder-level metadata and settings
4. **Environment files** go in `environments/` directory with `.bru` extension
5. **Collection file** named `collection.bru` contains collection-level settings (optional)

### bruno.json Format
**ALWAYS use this minimal canonical format** for bruno.json:

```json
{
  "version": "1",
  "name": "Your Collection Name",
  "type": "collection"
}
```

**Optional fields** (only add if specifically needed):
```json
{
  "version": "1",
  "name": "Your Collection Name",
  "type": "collection",
  "ignore": ["node_modules", ".git"]
}
```

**IMPORTANT**: 
- Do NOT add `pathname`, `files`, `activeEnvironmentUid` or other fields unless the project specifically requires them
- Use string values for "version" (not numbers)
- Keep it minimal - Bruno adds metadata automatically

### Bru File Format for Requests
When creating `.bru` request files, use this structure:

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
  authorization: Bearer {{token}}
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

### Request Types and Their Blocks

#### HTTP/REST Requests
```bru
meta {
  name: Create User
  type: http
  seq: 1
}

post {
  url: {{baseUrl}}/users
  body: json
  auth: bearer
}
```

#### GraphQL Requests
```bru
meta {
  name: Get User Data
  type: graphql-request
  seq: 1
}

post {
  url: {{baseUrl}}/graphql
  body: graphql
  auth: bearer
}

body:graphql {
  query {
    user(id: "123") {
      id
      name
      email
    }
  }
}

body:graphql:vars {
  {
    "userId": "123"
  }
}
```

#### gRPC Requests
```bru
meta {
  name: SayHello
  type: grpc
  seq: 1
}

grpc {
  url: {{host}}
  method: /hello.HelloService/SayHello
  body: grpc
  auth: inherit
  methodType: unary
}

metadata {
  authorization: Bearer {{token}}
}

body:grpc {
  name: message 1
  content: '''
    {
      "greeting": "hello"
    }
  '''
}
```

#### WebSocket Requests
```bru
meta {
  name: WebSocket Test
  type: ws
  seq: 1
}

ws {
  url: ws://localhost:8081/ws
  auth: inherit
}

headers {
  Authorization: Bearer {{token}}
}

body:ws {
  name: message 1
  content: '''
    {
      "action": "subscribe",
      "channel": "updates"
    }
  '''
}
```

### Body Formats

#### JSON Body
```bru
body:json {
  {
    "username": "johndoe",
    "email": "john@example.com"
  }
}
```

#### Text Body
```bru
body:text {
  This is plain text content
}
```

#### XML Body
```bru
body:xml {
  <?xml version="1.0" encoding="UTF-8"?>
  <user>
    <username>johndoe</username>
    <email>john@example.com</email>
  </user>
}
```

#### Form URL Encoded
```bru
body:form-urlencoded {
  username: johndoe
  password: secret123
  ~disabled_field: value
}
```

#### Multipart Form
```bru
body:multipart-form {
  username: johndoe
  avatar: @file(/path/to/avatar.jpg)
  description: User profile picture
}
```

#### File Upload
```bru
body:file {
  file: @file(path/to/file.json) @contentType(application/json)
}
```

### Authentication Blocks

#### Bearer Token
```bru
auth:bearer {
  token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
}
```

#### Basic Auth
```bru
auth:basic {
  username: admin
  password: secret123
}
```

#### API Key
```bru
auth:apikey {
  key: x-api-key
  value: api-secret-key-12345
  placement: header
}
```

#### OAuth2
```bru
auth:oauth2 {
  grant_type: authorization_code
  callback_url: http://localhost:8080/callback
  authorization_url: https://provider.com/oauth/authorize
  access_token_url: https://provider.com/oauth/token
  client_id: {{client_id}}
  client_secret: {{client_secret}}
  scope: read write
}
```

### Headers and Parameters

#### Headers
```bru
headers {
  content-type: application/json
  x-api-key: {{apiKey}}
  x-request-id: {{$uuid}}
  ~disabled-header: value
}
```

#### Query Parameters
```bru
params:query {
  page: 1
  limit: 10
  sort: desc
  ~disabled_param: value
}
```

#### Path Parameters
```bru
params:path {
  userId: 123
  status: active
}
```

### Variables

#### Request-Level Variables
```bru
vars:pre-request {
  user_id: 12345
  environment: production
}

vars:post-response {
  response_id: {{res.body.id}}
  processed_at: {{$timestamp}}
}
```

#### Variable Interpolation
Use `{{variableName}}` syntax to reference variables:
- Environment variables: `{{baseUrl}}`, `{{apiKey}}`
- Runtime variables: `{{user_id}}`
- Dynamic variables: `{{$guid}}`, `{{$timestamp}}`, `{{$randomInt}}`
- Response data: `{{res.body.token}}`

### Scripts

#### Pre-Request Script
```bru
script:pre-request {
  const timestamp = Date.now();
  bru.setVar("request_timestamp", timestamp);

  // Set headers dynamically
  req.setHeader("X-Timestamp", timestamp.toString());

  // Modify request body
  const body = req.getBody();
  body.timestamp = timestamp;
  req.setBody(JSON.stringify(body));
}
```

#### Post-Response Script
```bru
script:post-response {
  // Extract data from response
  const token = res.body.token;
  bru.setVar("authToken", token);

  // Set environment variable
  bru.setEnvVar("sessionToken", token);

  // Chain to next request
  if (res.status === 200) {
    bru.setNextRequest("Get User Profile");
  }
}
```

### Testing and Assertions

#### Assert Block (Simple Assertions)
**Use for simple, declarative assertions:**
```bru
assert {
  res.status: eq 200
  res.body.success: eq true
  res.body.data: isJson
  res.body.id: isNumber
  res.headers.content-type: contains application/json
  res.body.email: contains @example.com
}
```

**Assertion Operators**:
- `eq` - Equals
- `neq` - Not equals
- `lt` - Less than
- `lte` - Less than or equal
- `gt` - Greater than
- `gte` - Greater than or equal
- `contains` - Contains substring
- `startsWith` - Starts with
- `endsWith` - Ends with
- `isNumber` - Is a number
- `isString` - Is a string
- `isBoolean` - Is a boolean
- `isJson` - Is valid JSON
- `isArray` - Is an array
- `isEmpty` - Is empty
- `isNull` - Is null
- `isUndefined` - Is undefined
- `isTrue` - Is true
- `isFalse` - Is false

**Disable assertions** with `~` prefix:
```bru
assert {
  res.status: eq 200
  ~res.body.optional: eq value
}
```

#### Tests Block (Complex Validation)
**Use for complex logic, loops, and custom validation:**
```bru
tests {
  test("Status is 200", function() {
    expect(res.status).to.equal(200);
  });

  test("Response has required fields", function() {
    expect(res.body).to.have.property('id');
    expect(res.body).to.have.property('name');
    expect(res.body.email).to.match(/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/);
  });

  test("Array contains items", function() {
    expect(res.body.items).to.be.an('array');
    expect(res.body.items).to.have.lengthOf.at.least(1);
  });
}
```

**When to Use**:
- Use `assert` block for simple, declarative assertions
- Use `tests` block with Chai.js for complex logic, loops, and custom validation

### Environment Files

Environment files go in the `environments/` directory:

```bru
vars {
  baseUrl: https://api.example.com
  apiVersion: v1
  timeout: 30000
}

vars:secret [
  apiKey,
  authToken,
  clientSecret
]
```

**Environment file naming**: `environments/Production.bru`, `environments/Local.bru`

**Color coding** (optional):
```bru
color: #FF5733
```

### Folder Files

Folder files (`folder.bru`) contain folder-level metadata and settings:

```bru
meta {
  name: User Management
  seq: 1
}

headers {
  x-api-version: v2
  x-client-id: {{clientId}}
}

auth {
  mode: bearer
}

script:pre-request {
  // Runs before every request in this folder
  bru.setVar("folder_timestamp", Date.now());
}

tests {
  // Runs after every request in this folder
  test("Folder level test", function() {
    expect(res.status).to.be.oneOf([200, 201, 204]);
  });
}
```

### Collection Files

Collection files (`collection.bru`) contain collection-level settings:

```bru
meta {
  name: My API Collection
}

headers {
  user-agent: Bruno/1.0
}

script:pre-request {
  // Runs before every request in the collection
  console.log("Collection pre-request script");
}

tests {
  // Runs after every request in the collection
  test("Collection level test", function() {
    expect(res.responseTime).to.be.below(5000);
  });
}
```

## JavaScript API Reference

### Request Object (req)
Available in `script:pre-request` blocks:

```javascript
// URL manipulation
req.getUrl()                    // Get current URL
req.setUrl(url)                 // Set URL

// HTTP method
req.getMethod()                 // Get HTTP method
req.setMethod('POST')           // Set HTTP method

// Headers
req.getHeader('content-type')   // Get specific header
req.setHeader('x-api-key', key) // Set header
req.getHeaders()                // Get all headers

// Body
req.getBody()                   // Get request body
req.setBody(body)               // Set request body

// Timeout
req.setTimeout(5000)            // Set timeout in milliseconds
```

### Response Object (res)
Available in `script:post-response` and `tests` blocks:

```javascript
res.status                      // HTTP status code (e.g., 200)
res.statusText                  // Status text (e.g., "OK")
res.headers                     // Response headers object
res.body                        // Parsed response body
res.responseTime                // Response time in milliseconds

// Access nested response data
res.body.data.user.id
res.body.items[0].name
res.headers['content-type']
```

### Bruno Runtime (bru)
Available in all script blocks:

```javascript
// Runtime variables (request-scoped)
bru.setVar(key, value)          // Set runtime variable
bru.getVar(key)                 // Get runtime variable

// Environment variables (environment-scoped)
bru.setEnvVar(key, value)       // Set environment variable
bru.setEnvVar(key, null)        // Delete environment variable
bru.getEnvVar(key)              // Get environment variable

// Global environment variables (shared across all environments)
bru.setGlobalEnvVar(key, value) // Set global environment variable
bru.getGlobalEnvVar(key)        // Get global environment variable

// Request chaining
bru.setNextRequest(name)        // Set next request to run
bru.setNextRequest(null)        // Stop request chain

// Variable interpolation
bru.interpolate(string)         // Interpolate variables in string

// Cookie management
bru.cookies.jar()               // Get cookie jar
```

### Dynamic Variables
Bruno provides built-in dynamic variables:

```javascript
{{$guid}}                       // Random GUID
{{$timestamp}}                  // Current Unix timestamp
{{$isoTimestamp}}               // ISO 8601 timestamp
{{$randomInt}}                  // Random integer (0-1000)
{{$randomEmail}}                // Random email address
{{$randomFirstName}}            // Random first name
{{$randomLastName}}             // Random last name
{{$randomPhoneNumber}}          // Random phone number
{{$randomCity}}                 // Random city name
{{$randomStreetAddress}}        // Random street address
{{$randomCountry}}              // Random country
{{$randomUUID}}                 // Random UUID v4
```

### Common Patterns

#### 1. Authentication Flow
```bru
# Login.bru
meta {
  name: Login
  type: http
  seq: 1
}

post {
  url: {{baseUrl}}/auth/login
  body: json
  auth: none
}

body:json {
  {
    "username": "{{username}}",
    "password": "{{password}}"
  }
}

script:post-response {
  // Save token for subsequent requests
  const token = res.body.access_token;
  bru.setEnvVar("authToken", token);

  // Chain to next request
  bru.setNextRequest("Get User Profile");
}

tests {
  test("Login successful", function() {
    expect(res.status).to.equal(200);
    expect(res.body).to.have.property('access_token');
  });
}
```

#### 2. Data Extraction and Reuse
```bru
script:post-response {
  // Extract multiple values
  const userId = res.body.user.id;
  const sessionId = res.body.session.id;
  const expiresAt = res.body.session.expires_at;

  // Store for later use
  bru.setVar("userId", userId);
  bru.setVar("sessionId", sessionId);
  bru.setEnvVar("currentSession", sessionId);
}
```

#### 3. Conditional Request Chaining
```bru
script:post-response {
  if (res.status === 200 && res.body.requiresVerification) {
    bru.setNextRequest("Send Verification Code");
  } else if (res.status === 200) {
    bru.setNextRequest("Get Dashboard");
  } else {
    bru.setNextRequest(null); // Stop chain
  }
}
```

#### 4. Dynamic Request Modification
```bru
script:pre-request {
  // Add timestamp to prevent caching
  const url = req.getUrl();
  req.setUrl(`${url}?t=${Date.now()}`);

  // Add signature header
  const body = req.getBody();
  const signature = generateSignature(body);
  req.setHeader("X-Signature", signature);
}
```

## CI/CD & GitHub Actions

### Running Bruno Collections in Pipelines

#### Working Directory Requirement
**CRITICAL**: Always specify `working-directory` pointing to the collection root:

```yaml
- name: Run API Tests
  working-directory: ./bruno-collection-e2e-demo
  run: bru run --env Demo-Env Product\ Update\ Flow --reporter-html results.html --sandbox=developer
```

The `working-directory` tells Bruno where to find:
- `bruno.json` (collection metadata)
- Environment files in `environments/`
- Request `.bru` files
- Where to output results

#### Common bru CLI Options
```bash
bru run --env Production              # Specify environment
bru run --env Production --output ./results  # Custom output directory
bru run --env Production --reporter-html results.html  # HTML report
bru run --env Production --reporter-junit results.xml  # JUnit XML report
bru run --env Production --reporter-json results.json  # JSON report
bru run --env Production --bail       # Exit on first failure
bru run --env Production --tests      # Run tests only
bru run --folder "User Management"    # Run specific folder
bru run --recursive                   # Run all requests recursively
```

#### Example GitHub Actions Workflow
```yaml
name: Bruno API Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  api-tests:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Bruno CLI
        run: npm install -g @usebruno/cli

      - name: Run API Tests
        working-directory: ./bruno-collection-e2e-demo
        env:
          API_KEY: ${{ secrets.API_KEY }}
          BASE_URL: ${{ secrets.BASE_URL }}
        run: bru run --env Demo-Env Product\ Update\ Flow --reporter-html results.html --sandbox=developer

      - name: Upload Test Results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: bruno-test-results
          path: ./bruno-collection-e2e-demo/results.html
```

#### Using Environment Variables from CI/CD
Reference CI/CD secrets in your environment files:

```bru
vars {
  baseUrl: {{process.env.BASE_URL}}
  apiKey: {{process.env.API_KEY}}
  environment: production
}
```

Or set them in the workflow:
```yaml
- name: Run Tests
  working-directory: ./collections/My API Collection
  env:
    BASE_URL: https://api.production.com
    API_KEY: ${{ secrets.PROD_API_KEY }}
  run: bru run --env Production
```

#### Best Practices for CI/CD
1. **Use environment variables** for secrets - never commit secrets to `.bru` files
2. **Separate environments** for different stages (dev, staging, production)
3. **Generate reports** for visibility into test results
4. **Use --bail flag** to fail fast on critical test failures
5. **Upload artifacts** for post-run analysis and debugging
6. **Run on PR and push** to catch issues early
7. **Use matrix strategy** to test against multiple environments

#### Matrix Testing Example
```yaml
jobs:
  api-tests:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        environment: [Development, Staging, Production]

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm install -g @usebruno/cli

      - name: Run Tests - ${{ matrix.environment }}
        working-directory: ./collections/My API Collection
        run: bru run --env ${{ matrix.environment }} --reporter-html results-${{ matrix.environment }}.html
```

## Best Practices

### File Organization
1. **Use descriptive names** for request files: `Get User by ID.bru`, not `request1.bru`
2. **Organize in folders** by feature or resource: `Users/`, `Orders/`, `Auth/`
3. **Use folder.bru** to share common settings across requests in a folder
4. **Keep environments consistent** across team members
5. **Use .gitignore** to exclude sensitive data and temporary files

### Variable Management
1. **Environment variables** for values that change per environment (URLs, API keys)
2. **Collection variables** for values shared across all requests
3. **Folder variables** for values shared within a folder
4. **Request variables** for request-specific values
5. **Runtime variables** for temporary values during execution
6. **Secret variables** for sensitive data (use `vars:secret` block)

### Testing Strategy
1. **Use assert blocks** for simple validations
2. **Use tests blocks** for complex logic and custom validations
3. **Test at multiple levels**: request, folder, and collection
4. **Validate status codes, headers, and response body**
5. **Use meaningful test names** that describe what's being tested
6. **Extract and reuse data** from responses for subsequent requests

### Security
1. **Never commit secrets** to version control
2. **Use vars:secret** for sensitive environment variables
3. **Use .gitignore** to exclude secret files
4. **Use CI/CD secrets** for production credentials
5. **Rotate API keys** regularly

### Git Workflow
1. **Commit collection changes** alongside code changes
2. **Review .bru file changes** in pull requests
3. **Use branches** for experimental API changes
4. **Tag releases** to track API versions
5. **Document breaking changes** in commit messages

## Common Mistakes to Avoid

1. ❌ **Missing bruno.json** - Every collection MUST have a bruno.json file
2. ❌ **Wrong file extensions** - Use `.bru` for requests, environments, and folders
3. ❌ **Incorrect directory structure** - Environments must be in `environments/` folder
4. ❌ **Hardcoded secrets** - Use variables and `vars:secret` blocks
5. ❌ **Missing working-directory in CI/CD** - Always specify the collection path
6. ❌ **Overly complex bruno.json** - Keep it minimal, let Bruno manage metadata
7. ❌ **Not using variable interpolation** - Use `{{variableName}}` syntax
8. ❌ **Mixing assert and tests** - Use assert for simple checks, tests for complex logic
9. ❌ **Forgetting to disable fields** - Use `~` prefix to disable headers, params, assertions
10. ❌ **Not organizing requests** - Use folders and meaningful names

## Quick Reference

### File Types
- `bruno.json` - Collection metadata (REQUIRED)
- `collection.bru` - Collection-level settings
- `folder.bru` - Folder-level settings
- `*.bru` - Request files
- `environments/*.bru` - Environment files

### Variable Scopes (in order of precedence)
1. Runtime variables (set via `bru.setVar()`)
2. Request variables (`vars:pre-request`, `vars:post-response`)
3. Folder variables (from `folder.bru`)
4. Collection variables (from `collection.bru`)
5. Environment variables (from `environments/*.bru`)
6. Global environment variables
7. Process environment variables (`process.env.*`)

### Script Execution Order
1. Collection `script:pre-request`
2. Folder `script:pre-request`
3. Request `script:pre-request`
4. **Request is sent**
5. Request `script:post-response`
6. Folder `script:post-response`
7. Collection `script:post-response`
8. Request `tests`
9. Folder `tests`
10. Collection `tests`

When generating Bruno-related code, prioritize the .bru file format, proper directory structure, and Git-collaborative workflow.

