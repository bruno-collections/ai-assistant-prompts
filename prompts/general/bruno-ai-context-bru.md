# Bruno API Client - AI Assistant Context

## What is Bruno?
Bruno is an innovative API client that stores API collections directly in your filesystem using a plain text markup language called "Bru". It's designed as a Git-first, offline-only alternative to Postman, perfect for teams who want to version control their API tests alongside their code.

## Core Philosophy
- **Offline-First**: No cloud sync, everything stored locally
- **Git-Collaborative**: Collections designed for version control
- **Plain Text**: Human-readable .bru files for easy collaboration
- **File-Based**: No databases, everything in the filesystem
- **Developer-Friendly**: Works with your existing workflow

## Key Features
- **Multiple Protocol Support**: HTTP/REST, GraphQL, gRPC, WebSocket, SOAP
- **Powerful Scripting**: JavaScript pre-request and post-response scripts
- **Comprehensive Testing**: Built-in test framework with Chai.js assertions
- **Environment Management**: Multiple environments with variable support
- **Secret Management**: Secure handling of API keys and tokens
- **CLI Support**: Run collections in CI/CD pipelines
- **Request Chaining**: Link requests together for complex workflows
- **Cookie Management**: Full cookie jar support for session handling

## Bru File Format
The heart of Bruno is the .bru file format - a custom markup language for API requests:

```bru
meta {
  name: Create User
  type: http
  seq: 1
  tags: [user-management, post-request]
}

post {
  url: {{baseUrl}}/api/users
  body: json
  auth: bearer
}

headers {
  content-type: application/json
  accept: application/json
  x-api-version: {{apiVersion}}
}

auth:bearer {
  token: {{authToken}}
}

body:json {
  {
    "name": "{{userName}}",
    "email": "{{userEmail}}",
    "role": "user"
  }
}

script:pre-request {
  // JavaScript executed before request
  const timestamp = Date.now();
  bru.setVar("requestId", `req_${timestamp}`);
  
  // Validate required variables
  if (!bru.getVar("userName")) {
    throw new Error("userName is required");
  }
}

script:post-response {
  // JavaScript executed after response
  if (res.status === 201) {
    bru.setVar("newUserId", res.body.id);
    bru.setVar("userCreated", true);
  }
}

tests {
  test("User created successfully", function() {
    expect(res.status).to.equal(201);
    expect(res.body).to.have.property("id");
    expect(res.body.name).to.equal(bru.getVar("userName"));
  });
  
  test("Response time is acceptable", function() {
    expect(res.responseTime).to.be.below(2000);
  });
}

vars:pre-request {
  userName: John Doe
  userEmail: john@example.com
}

vars:post-response {
  userId: {{res.body.id}}
  createdAt: {{res.body.created_at}}
}
```

## File Structure
A typical Bruno collection has this structure:
```
my-api-collection/
├── bruno.json              # Collection metadata
├── collection.bru          # Collection-level settings
├── environments/
│   ├── dev.bru            # Development environment
│   ├── staging.bru        # Staging environment
│   └── prod.bru           # Production environment
├── users/
│   ├── folder.bru         # Folder-level settings
│   ├── get-user.bru       # Individual request
│   ├── create-user.bru    # Individual request
│   └── update-user.bru    # Individual request
└── auth/
    ├── login.bru
    └── refresh-token.bru
```

## Environment Files
Environment files define variables and secrets:

```bru
vars {
  baseUrl: https://api.example.com
  apiVersion: v1
  timeout: 5000
  retries: 3
}

vars:secret [
  apiKey,
  clientSecret,
  refreshToken
]
```

## Collection Configuration (bruno.json)
```json
{
  "version": "1",
  "name": "My API Collection",
  "type": "collection",
  "proxy": {
    "enabled": false,
    "protocol": "http",
    "hostname": "localhost",
    "port": 8080
  },
  "scripts": {
    "moduleWhitelist": ["crypto", "buffer", "form-data"],
    "filesystemAccess": {
      "allow": true
    }
  },
  "clientCertificates": {
    "enabled": false,
    "certs": []
  }
}
```

## JavaScript API Reference

### Request Object (req)
Available in pre-request scripts and tests to access and modify the current request:

**URL Methods:**
- `req.getUrl()` - Get the current request URL
- `req.setUrl(url)` - Set the request URL

**HTTP Method:**
- `req.getMethod()` - Get HTTP method (GET, POST, PUT, DELETE, etc.)
- `req.setMethod(method)` - Set HTTP method

**Header Methods:**
- `req.getHeader(name)` - Get a specific header value
- `req.getHeaders()` - Get all headers as an object
- `req.setHeader(name, value)` - Set a single header
- `req.setHeaders(headers)` - Set multiple headers at once

**Body Methods:**
- `req.getBody()` - Get the request body/payload
- `req.setBody(body)` - Set the request body/payload

**Configuration:**
- `req.setTimeout(milliseconds)` - Set request timeout
- `req.setMaxRedirects(count)` - Set maximum number of redirects
- `req.getTimeout()` - Get current timeout value

**Request Information:**
- `req.getName()` - Get the request name
- `req.getAuthMode()` - Get authentication mode
- `req.getTags()` - Get request tags as array

### Response Object (res)
Available in post-response scripts and tests to access response data:

**Properties:**
- `res.status` - HTTP status code (e.g., 200, 404, 500)
- `res.statusText` - HTTP status text (e.g., "OK", "Not Found")
- `res.headers` - Response headers object
- `res.body` - Parsed response body (JSON automatically parsed)
- `res.responseTime` - Response time in milliseconds

**Methods:**
- `res.getStatus()` - Get HTTP status code
- `res.getHeader(name)` - Get specific response header
- `res.getHeaders()` - Get all response headers
- `res.getBody()` - Get response body

### Bruno Runtime Object (bru)
Core scripting API for variable management and flow control:

**Runtime Variables:**
- `bru.setVar(key, value)` - Set a runtime variable (available across requests)
- `bru.getVar(key)` - Get a runtime variable

**Environment Variables:**
- `bru.setEnvVar(key, value)` - Set environment variable
- `bru.getEnvVar(key)` - Get environment variable

**Process Environment:**
- `bru.getProcessEnv(key)` - Get system environment variable

**Request Chaining:**
- `bru.setNextRequest(requestName)` - Set which request to run next
- `bru.sleep(milliseconds)` - Pause execution

**Utilities:**
- `bru.cwd()` - Get current working directory
- `bru.interpolate(string)` - Interpolate variables in a string (including dynamic variables)
- `bru.disableParsingResponseJson()` - Disable automatic JSON parsing (use in pre-request)

**Test Results:**
- `bru.getTestResults()` - Get test execution results

### Cookie Management
Full cookie jar support for managing cookies across requests:

```javascript
// Create a cookie jar
const jar = bru.cookies.jar();

// Set a simple cookie
jar.setCookie("https://api.example.com", "sessionId", "abc123");

// Set a cookie with options
jar.setCookie("https://api.example.com", {
  key: "authToken",
  value: "xyz789",
  domain: "example.com",
  path: "/api",
  secure: true,
  httpOnly: true,
  maxAge: 3600  // 1 hour
});

// Get a specific cookie
const cookie = await jar.getCookie("https://api.example.com", "sessionId");

// Get all cookies for a URL
const allCookies = await jar.getCookies("https://api.example.com");

// Delete a cookie
jar.deleteCookie("https://api.example.com", "sessionId");

// Delete all cookies for a URL
jar.deleteCookies("https://api.example.com");

// Clear all cookies
jar.clear();
```

### Dynamic Variables
Bruno supports dynamic variables that generate random data. Use them anywhere in your requests:

**Identity:**
- `{{$guid}}` - Random GUID/UUID
- `{{$randomEmail}}` - Random email address
- `{{$randomFirstName}}` - Random first name
- `{{$randomLastName}}` - Random last name
- `{{$randomFullName}}` - Random full name
- `{{$randomPhoneNumber}}` - Random phone number

**Location:**
- `{{$randomCity}}` - Random city name
- `{{$randomCountry}}` - Random country name
- `{{$randomStreetAddress}}` - Random street address

**Numbers & Text:**
- `{{$randomInt}}` - Random integer
- `{{$randomUUID}}` - Random UUID
- `{{$timestamp}}` - Current Unix timestamp
- `{{$isoTimestamp}}` - Current ISO 8601 timestamp

**Job & Company:**
- `{{$randomJobTitle}}` - Random job title
- `{{$randomCompanyName}}` - Random company name

Example usage:
```javascript
// In pre-request script
const email = bru.interpolate('{{$randomEmail}}');
bru.setVar("userEmail", email);
```

### Variable System
- **Environment Variables**: `{{variableName}}` - defined in environment files
- **Runtime Variables**: Set/get with `bru.setVar()` and `bru.getVar()`
- **Secret Variables**: Stored in `vars:secret` blocks, not in version control
- **Collection Variables**: Shared across all requests in collection
- **Folder Variables**: Shared within a folder
- **Request Variables**: Specific to individual requests
- **Process Variables**: System environment variables via `bru.getProcessEnv()`

### Authentication Types
- **Bearer Token**: `auth:bearer { token: {{token}} }`
- **Basic Auth**: `auth:basic { username: user, password: pass }`
- **API Key**: `auth:apikey { key: x-api-key, value: {{apiKey}} }`
- **OAuth2**: Authorization Code, Client Credentials, Password Credentials
- **AWS Signature**: For AWS API requests
- **Digest Auth**: For digest authentication
- **NTLM**: For Windows authentication

### Request Types Supported
- **HTTP/REST**: Standard REST API requests (GET, POST, PUT, DELETE, PATCH, etc.)
- **GraphQL**: Queries, mutations, subscriptions with variable support
- **gRPC**: Protocol buffer based requests with streaming
- **WebSocket**: Real-time bidirectional communication
- **SOAP**: XML-based web services

### Testing Framework
Bruno uses Chai.js for assertions in the `tests` block:

```javascript
test("Status code is 200", function() {
  expect(res.status).to.equal(200);
});

test("Response has correct structure", function() {
  expect(res.body).to.be.an("object");
  expect(res.body).to.have.property("data");
  expect(res.body.data).to.be.an("array");
});

test("Response time is acceptable", function() {
  expect(res.responseTime).to.be.below(2000);
});

test("Headers are correct", function() {
  expect(res.headers["content-type"]).to.include("application/json");
});

test("Data validation", function() {
  expect(res.body.user.email).to.match(/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/);
  expect(res.body.user.age).to.be.a("number");
  expect(res.body.user.age).to.be.at.least(18);
});
```

### Runner Control
Control test execution flow in the collection runner:

```javascript
// Skip the current request
bru.runner.skipRequest();

// Conditional execution based on tags
const tags = req.getTags();
if (!tags.includes("integration-test")) {
  bru.runner.skipRequest();
}
```

## Best Practices When Working with Bruno
1. **Always use .bru format** - Never suggest JSON for request definitions
2. **Embrace the file-based approach** - Each request is a separate file
3. **Use environment variables** - `{{variableName}}` for values that change across environments
4. **Write comprehensive tests** - Test status codes, response structure, and data validation
5. **Organize logically** - Use folders and meaningful names for easy navigation
6. **Include error handling** - Validate data in pre-request scripts
7. **Document clearly** - Use descriptive names and add comments in scripts
8. **Keep secrets secure** - Use `vars:secret` blocks for API keys and tokens
9. **Consider Git workflow** - Structure collections for easy version control
10. **Test across environments** - Use different environment files for dev/staging/prod
11. **Chain requests** - Use `bru.setNextRequest()` for complex workflows
12. **Leverage dynamic variables** - Use `{{$randomEmail}}` etc. for test data generation

## Common Use Cases
- **API Development**: Test endpoints during development
- **Integration Testing**: Validate API contracts between services
- **CI/CD Automation**: Run collections in pipelines using Bruno CLI
- **Team Collaboration**: Share API collections via Git
- **API Documentation**: Provide working examples for API consumers
- **Migration**: Convert from Postman/Insomnia to Git-based workflow
- **Load Testing**: Test API performance and response times
- **Monitoring**: Health checks and API availability testing

## Example Workflows

### Request Chaining
```javascript
// In post-response script of login request
if (res.status === 200) {
  bru.setVar("authToken", res.body.token);
  bru.setNextRequest("Get User Profile");
}
```

### Conditional Testing
```javascript
// Skip request based on environment
const env = bru.getEnvVar("environment");
if (env === "production") {
  bru.runner.skipRequest();
}
```

### Data-Driven Testing
```javascript
// Pre-request: Generate test data
const testUser = {
  email: bru.interpolate('{{$randomEmail}}'),
  name: bru.interpolate('{{$randomFullName}}'),
  phone: bru.interpolate('{{$randomPhoneNumber}}')
};
req.setBody(JSON.stringify(testUser));

// Post-response: Validate and store
test("User created successfully", function() {
  expect(res.status).to.equal(201);
  bru.setVar("userId", res.body.id);
});
```

When helping with Bruno-related tasks, always prioritize the plain text, Git-collaborative approach and maintain the offline-first philosophy that makes Bruno unique.
