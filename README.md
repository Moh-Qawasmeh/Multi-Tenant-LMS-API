# Multi-Tenant Learning Management System (LMS)

A GraphQL-based Learning Management System built with Ruby on Rails 7.1. This application supports multi-tenancy via subdomains, allowing different schools to exist in isolation within the same application instance.

## Prerequisites

*   **Ruby**: 3.3.0
*   **Database**: PostgreSQL
*   **Redis** (Optional, for Action Cable/Background Jobs if enabled)

## Getting Started

### 1. Installation

Clone the repository and install dependencies:

```bash
git clone <repository-url>
cd lms
bundle install
```

### 2. Database Setup

Create the database, run migrations, and seed it with initial data:

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

### 3. Running the Server

Start the Rails server:

```bash
bin/rails server
```

The application will be available at `http://localhost:3000`.

## Accessing Schools (Multi-Tenancy)

This application uses **subdomains** to identify the current school context. You cannot access the application via `localhost:3000` directly without a subdomain corresponding to a valid school.

### Local Development Configuration

To test subdomains locally, you need to alias them to `127.0.0.1`. Add the following to your `/etc/hosts` file:

```
127.0.0.1   school1.localhost
127.0.0.1   school2.localhost
```

You can then access the schools via:
*   `http://school1.localhost:3000`
*   `http://school2.localhost:3000`

### Default Logins (from Seeds)

The `db/seeds.rb` file creates example data for testing. The password for all users is **`password123`**.

**School One** (`school1.localhost:3000`):
*   **Admin**: `admin1@school1.com`
*   **Instructor**: `instructor1@school1.com`
*   **User**: `user1@school1.com`

**School Two** (`school2.localhost:3000`):
*   **Admin**: `admin1@school2.com`
*   **Instructor**: `instructor1@school2.com`
*   **User**: `user1@school2.com`

## GraphQL API

The API endpoint is `/graphql`.

To interact with the API, you can use a client like Postman or Insomnia. Remember to send requests to the correct subdomain (e.g., `http://school1.localhost:3000/graphql`).

### Authentication

Authentication is handled via Devise and JWT.

1.  **Sign In Mutation**:
    ```graphql
    mutation {
      signIn(input: { email: "user1@school1.com", password: "password123" }) {
        token
        user {
          id
          email
        }
        errors
      }
    }
    ```

2.  **Authenticated Requests**:
    Includes the returned token in the `Authorization` header:
    ```
    Authorization: Bearer <your_jwt_token>
    ```

## Testing

Run the test suite (including the integration tests for auth flows):

```bash
bin/rails test
```

## Architecture Notes

*   **Multi-tenancy**: Implemented via `CurrentSchoolMiddleware` and scoped `Current.school`.
*   **Authorization**: Uses CanCanCan, initialized with `Current.user`.
*   **Authentication**: Devise + `devise-jwt`.
