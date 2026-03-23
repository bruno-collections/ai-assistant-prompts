# GitHub Copilot Instructions for Bruno API Client (YAML / OpenCollection Format)

## About Bruno
Bruno is an innovative API client that stores API collections directly in your filesystem. As of **Bruno v3.1**, the default format is **YAML** based on the [OpenCollection specification](https://spec.opencollection.com/). It's designed as a Git-first, offline-only alternative to Postman, perfect for teams who want to version control their API tests alongside their code.

> **Note**: For legacy Bru format instructions, see `copilot-instructions-bru.md`.

## Key Features
- **Multiple Protocols**: HTTP/REST, GraphQL, gRPC, WebSocket, SOAP
- **Powerful Scripting**: JavaScript pre-request and post-response scripts
- **Testing Framework**: Built-in Chai.js assertions
- **Environment Management**: Multiple environments with variable support
- **Secret Management**: Secure handling of API keys and tokens
- **CLI Support**: Run collections in CI/CD pipelines
- **YAML Format**: Human-readable, Git-friendly YAML files (OpenCollection spec)

## Core Concepts for Copilot

### Collection Directory Structure
**CRITICAL**: Bruno collections have a specific directory structure that MUST be followed:

```
My Collection/
├── bruno.json                    # Collection metadata (REQUIRED)
├── collection.yaml               # Collection-level settings (optional)
├── .gitignore                    # Git ignore file
├── environments/                 # Environment files directory
│   ├── Local.yaml
│   ├── Production.yaml
│   └── Staging.yaml
├── folder.yaml                   # Folder-level settings (optional)
├── Get User.yaml                 # Individual request files
├── Create User.yaml
└── Users/                        # Subfolder for organization
    ├── folder.yaml               # Folder metadata
    ├── Get User by ID.yaml
    └── Update User.yaml
```

**Key Rules**:
1. **bruno.json is REQUIRED** at the collection root - this identifies it as a Bruno collection
2. **Request files** use `.yaml` extension and contain a single API request
3. **Folder files** named `folder.yaml` contain folder-level metadata and settings
4. **Environment files** go in `environments/` directory with `.yaml` extension
5. **Collection file** named `collection.yaml` contains collection-level settings (optional)

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

### YAML Request File Structure
When creating `.yaml` request files, use this structure with these **top-level sections**:

```yaml
info:        # Request metadata (name, type, seq, tags)
http:        # HTTP request configuration
runtime:     # Scripts and assertions
settings:    # Request settings
docs:        # Request documentation
```

### Basic YAML Request Example

```yaml
info:
  name: Request Name
  type: http
  seq: 1

http:
  method: GET
  url: "{{baseUrl}}/endpoint"
  headers:
    - name: content-type
      value: application/json
    - name: authorization
      value: "Bearer {{token}}"
  body:
    type: json
    data: |-
      {
        "key": "value"
      }

runtime:
  scripts:
    - type: before-request
      code: |-
        bru.setVar("timestamp", Date.now());
    - type: tests
      code: |-
        test("Status is 200", function() {
          expect(res.status).to.equal(200);
        });

settings:
  encodeUrl: true
```

### Request Types and Their Examples

#### HTTP/REST Requests
```yaml
info:
  name: Create User
  type: http
  seq: 1

http:
  method: POST
  url: "{{baseUrl}}/users"
  body:
    type: json
    data: |-
      {
        "username": "johndoe",
        "email": "john@example.com"
      }
  auth:
    type: bearer
    token: "{{token}}"

settings:
  encodeUrl: true
```

#### GraphQL Requests
```yaml
info:
  name: Get User Data
  type: http
  seq: 1

http:
  method: POST
  url: "{{baseUrl}}/graphql"
  body:
    type: graphql
    data: |-
      query {
        user(id: "123") {
          id
          name
          email
        }
      }
  auth:
    type: bearer
    token: "{{token}}"

settings:
  encodeUrl: true
```

#### gRPC Requests
```yaml
info:
  name: SayHello
  type: grpc
  seq: 1

grpc:
  url: "{{host}}"
  service: hello.HelloService
  method: SayHello
  body:
    type: json
    data: |-
      {
        "greeting": "hello"
      }
  auth: inherit

settings:
  encodeUrl: true
```

#### WebSocket Requests
```yaml
info:
  name: WebSocket Test
  type: ws
  seq: 1

ws:
  url: "ws://localhost:8081/ws"
  headers:
    - name: Authorization
      value: "Bearer {{token}}"
  auth: inherit

settings:
  encodeUrl: true
```

### Body Formats

#### JSON Body
```yaml
body:
  type: json
  data: |-
    {
      "username": "johndoe",
      "email": "john@example.com"
    }
```

#### Text Body
```yaml
body:
  type: text
  data: "This is plain text content"
```

#### XML Body
```yaml
body:
  type: xml
  data: |-
    <?xml version="1.0" encoding="UTF-8"?>
    <user>
      <username>johndoe</username>
      <email>john@example.com</email>
    </user>
```

#### Form URL Encoded
```yaml
body:
  type: form-urlencoded
  data:
    - name: username
      value: johndoe
    - name: password
      value: secret123
    - name: disabled_field
      value: value
      disabled: true
```

#### Multipart Form
```yaml
body:
  type: multipart-form
  data:
    - name: username
      value: johndoe
    - name: avatar
      value: "@file(/path/to/avatar.jpg)"
    - name: description
      value: User profile picture
```

### Authentication

#### Bearer Token
```yaml
auth:
  type: bearer
  token: "{{token}}"
```

#### Basic Auth
```yaml
auth:
  type: basic
  username: admin
  password: secret123
```

#### API Key
```yaml
auth:
  type: apikey
  key: x-api-key
  value: "{{api-key}}"
  placement: header
```

#### OAuth2
```yaml
auth:
  type: oauth2
  grant_type: authorization_code
  callback_url: http://localhost:8080/callback
  authorization_url: https://provider.com/oauth/authorize
  access_token_url: https://provider.com/oauth/token
  client_id: "{{client_id}}"
  client_secret: "{{client_secret}}"
  scope: read write
```

**Supported auth types**: `none`, `inherit`, `basic`, `bearer`, `apikey`, `digest`, `oauth2`, `awsv4`, `ntlm`.

### Headers and Parameters

#### Headers
Headers are arrays of objects with `name`, `value`, and optional `disabled` fields:
```yaml
http:
  headers:
    - name: content-type
      value: application/json
    - name: x-api-key
      value: "{{apiKey}}"
    - name: x-request-id
      value: "{{$uuid}}"
    - name: disabled-header
      value: some-value
      disabled: true
```

#### Query Parameters
```yaml
http:
  params:
    query:
      - name: page
        value: "1"
      - name: limit
        value: "10"
      - name: sort
        value: desc
      - name: disabled_param
        value: value
        disabled: true
```

#### Path Parameters
```yaml
http:
  params:
    path:
      - name: userId
        value: "123"
      - name: status
        value: active
```

### Variables

#### Variable Interpolation
Use `{{variableName}}` syntax to reference variables:
- Environment variables: `{{baseUrl}}`, `{{apiKey}}`
- Runtime variables: `{{user_id}}`
- Dynamic variables: `{{$guid}}`, `{{$timestamp}}`, `{{$randomInt}}`
- Response data: `{{res.body.token}}`

### Scripts

#### Pre-Request Script
```yaml
runtime:
  scripts:
    - type: before-request
      code: |-
        const timestamp = Date.now();
        bru.setVar("request_timestamp", timestamp);

        // Set headers dynamically
        req.setHeader("X-Timestamp", timestamp.toString());

        // Modify request body
        const body = req.getBody();
        body.timestamp = timestamp;
        req.setBody(JSON.stringify(body));
```

#### Post-Response Script
```yaml
runtime:
  scripts:
    - type: after-response
      code: |-
        // Extract data from response
        const token = res.body.token;
        bru.setVar("authToken", token);

        // Set environment variable
        bru.setEnvVar("sessionToken", token);

        // Chain to next request
        if (res.status === 200) {
          bru.setNextRequest("Get User Profile");
        }
```

### Testing and Assertions

#### Assertions (Declarative)
**Use for simple, declarative assertions without writing JavaScript:**
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
    - expression: res.body.id
      operator: isNumber
    - expression: res.headers.content-type
      operator: contains
      value: application/json
    - expression: res.body.email
      operator: contains
      value: "@example.com"
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

#### Tests (Complex Validation)
**Use for complex logic, loops, and custom validation with Chai.js:**
```yaml
runtime:
  scripts:
    - type: tests
      code: |-
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
```

**When to Use**:
- Use `assertions` for simple, declarative assertions
- Use `tests` scripts with Chai.js for complex logic, loops, and custom validation

### Environment Files

Environment files go in the `environments/` directory using `.yaml` extension:

```yaml
variables:
  - name: baseUrl
    value: https://api.example.com
  - name: apiVersion
    value: v1
  - name: timeout
    value: "30000"
  - name: apiKey
    value: ""
    secret: true
  - name: authToken
    value: ""
    secret: true
```

**Environment file naming**: `environments/Production.yaml`, `environments/Local.yaml`

### Folder Files

Folder files (`folder.yaml`) contain folder-level metadata and settings:

```yaml
info:
  name: User Management
  type: folder

http:
  headers:
    - name: x-api-version
      value: v2
    - name: x-client-id
      value: "{{clientId}}"
  auth:
    type: bearer
    token: "{{token}}"

runtime:
  scripts:
    - type: before-request
      code: |-
        // Runs before every request in this folder
        bru.setVar("folder_timestamp", Date.now());
    - type: tests
      code: |-
        // Runs after every request in this folder
        test("Folder level test", function() {
          expect(res.status).to.be.oneOf([200, 201, 204]);
        });
```

### Collection Files

Collection files (`collection.yaml`) contain collection-level settings:

```yaml
info:
  name: My API Collection

http:
  headers:
    - name: user-agent
      value: Bruno/1.0

runtime:
  scripts:
    - type: before-request
      code: |-
        // Runs before every request in the collection
        console.log("Collection pre-request script");
    - type: tests
      code: |-
        // Runs after every request in the collection
        test("Collection level test", function() {
          expect(res.responseTime).to.be.below(5000);
        });
```

### Settings

Request-level settings:
```yaml
settings:
  encodeUrl: true
  timeout: 0
  followRedirects: true
  maxRedirects: 5
```

| Field | Type | Description |
|-------|------|-------------|
| `encodeUrl` | boolean | Whether to URL-encode the request URL |
| `timeout` | number | Request timeout in milliseconds (0 = no timeout) |
| `followRedirects` | boolean | Whether to follow HTTP redirects |
| `maxRedirects` | number | Maximum number of redirects to follow |

### Documentation

Request-level documentation in Markdown format:
```yaml
docs: |-
  # User Creation API

  This endpoint creates a new user in the system.

  ## Required Fields
  - name: User's full name
  - email: User's email address
```

## JavaScript API Reference

### Request Object (req)
Available in `before-request` scripts:

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
Available in `after-response` and `tests` scripts:

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
```yaml
# Login.yaml
info:
  name: Login
  type: http
  seq: 1

http:
  method: POST
  url: "{{baseUrl}}/auth/login"
  body:
    type: json
    data: |-
      {
        "username": "{{username}}",
        "password": "{{password}}"
      }
  auth:
    type: none

runtime:
  scripts:
    - type: after-response
      code: |-
        // Save token for subsequent requests
        const token = res.body.access_token;
        bru.setEnvVar("authToken", token);

        // Chain to next request
        bru.setNextRequest("Get User Profile");
    - type: tests
      code: |-
        test("Login successful", function() {
          expect(res.status).to.equal(200);
          expect(res.body).to.have.property('access_token');
        });
```

#### 2. Data Extraction and Reuse
```yaml
runtime:
  scripts:
    - type: after-response
      code: |-
        // Extract multiple values
        const userId = res.body.user.id;
        const sessionId = res.body.session.id;
        const expiresAt = res.body.session.expires_at;

        // Store for later use
        bru.setVar("userId", userId);
        bru.setVar("sessionId", sessionId);
        bru.setEnvVar("currentSession", sessionId);
```

#### 3. Conditional Request Chaining
```yaml
runtime:
  scripts:
    - type: after-response
      code: |-
        if (res.status === 200 && res.body.requiresVerification) {
          bru.setNextRequest("Send Verification Code");
        } else if (res.status === 200) {
          bru.setNextRequest("Get Dashboard");
        } else {
          bru.setNextRequest(null); // Stop chain
        }
```

#### 4. Dynamic Request Modification
```yaml
runtime:
  scripts:
    - type: before-request
      code: |-
        // Add timestamp to prevent caching
        const url = req.getUrl();
        req.setUrl(`${url}?t=${Date.now()}`);

        // Add signature header
        const body = req.getBody();
        const signature = generateSignature(body);
        req.setHeader("X-Signature", signature);
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
- Request `.yaml` files
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

```yaml
variables:
  - name: baseUrl
    value: "{{process.env.BASE_URL}}"
  - name: apiKey
    value: "{{process.env.API_KEY}}"
  - name: environment
    value: production
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
1. **Use environment variables** for secrets - never commit secrets to `.yaml` files
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
1. **Use descriptive names** for request files: `Get User by ID.yaml`, not `request1.yaml`
2. **Organize in folders** by feature or resource: `Users/`, `Orders/`, `Auth/`
3. **Use folder.yaml** to share common settings across requests in a folder
4. **Keep environments consistent** across team members
5. **Use .gitignore** to exclude sensitive data and temporary files

### Variable Management
1. **Environment variables** for values that change per environment (URLs, API keys)
2. **Collection variables** for values shared across all requests
3. **Folder variables** for values shared within a folder
4. **Request variables** for request-specific values
5. **Runtime variables** for temporary values during execution
6. **Secret variables** for sensitive data (use `secret: true` in environment files)

### Testing Strategy
1. **Use assertions** for simple validations
2. **Use tests scripts** for complex logic and custom validations
3. **Test at multiple levels**: request, folder, and collection
4. **Validate status codes, headers, and response body**
5. **Use meaningful test names** that describe what's being tested
6. **Extract and reuse data** from responses for subsequent requests

### Security
1. **Never commit secrets** to version control
2. **Use `secret: true`** for sensitive environment variables
3. **Use .gitignore** to exclude secret files
4. **Use CI/CD secrets** for production credentials
5. **Rotate API keys** regularly

### Git Workflow
1. **Commit collection changes** alongside code changes
2. **Review .yaml file changes** in pull requests
3. **Use branches** for experimental API changes
4. **Tag releases** to track API versions
5. **Document breaking changes** in commit messages

## Common Mistakes to Avoid

1. ❌ **Missing bruno.json** - Every collection MUST have a bruno.json file
2. ❌ **Wrong file extensions** - Use `.yaml` for requests, environments, and folders
3. ❌ **Incorrect directory structure** - Environments must be in `environments/` folder
4. ❌ **Hardcoded secrets** - Use variables and `secret: true` in environment files
5. ❌ **Missing working-directory in CI/CD** - Always specify the collection path
6. ❌ **Overly complex bruno.json** - Keep it minimal, let Bruno manage metadata
7. ❌ **Not using variable interpolation** - Use `{{variableName}}` syntax
8. ❌ **Mixing assertions and tests** - Use assertions for simple checks, tests for complex logic
9. ❌ **Forgetting disabled fields** - Use `disabled: true` to disable headers, params, assertions
10. ❌ **Not organizing requests** - Use folders and meaningful names

## Quick Reference

### File Types
- `bruno.json` - Collection metadata (REQUIRED)
- `collection.yaml` - Collection-level settings
- `folder.yaml` - Folder-level settings
- `*.yaml` - Request files
- `environments/*.yaml` - Environment files

### Variable Scopes (in order of precedence)
1. Runtime variables (set via `bru.setVar()`)
2. Request variables
3. Folder variables (from `folder.yaml`)
4. Collection variables (from `collection.yaml`)
5. Environment variables (from `environments/*.yaml`)
6. Global environment variables
7. Process environment variables (`process.env.*`)

### Script Execution Order
1. Collection `before-request`
2. Folder `before-request`
3. Request `before-request`
4. **Request is sent**
5. Request `after-response`
6. Folder `after-response`
7. Collection `after-response`
8. Request `tests`
9. Folder `tests`
10. Collection `tests`

When generating Bruno-related code, prioritize the YAML file format (OpenCollection spec), proper directory structure, and Git-collaborative workflow.