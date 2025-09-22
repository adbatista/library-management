# README

## Setup

```
bundle install
rails db:create db:migrate db:seed
rails server
```


## Authentication

The API uses token-based authentication. To access protected endpoints, include the token in the request header:

```
Authorization: Bearer <token>
```

## Base URL

```
http://localhost:3000
```

---

## Endpoints

### 1. Users

#### Create User
- **Method**: `POST`
- **Endpoint**: `/users`
- **Description**: Creates a new user in the system
- **Authentication**: Not required

**Request Body:**
```json
{
  "user": {
    "name": "John Doe",
    "email_address": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "user_type": "member"
  }
}
```

**Parameters:**
- `name` (string): User's full name
- `email_address` (string): User's unique email
- `password` (string): User's password
- `password_confirmation` (string): Password confirmation
- `user_type` (string): User type - `"member"` or `"librarian"`

**Response (201):**
```json
{
  "id": 1,
  "name": "John Doe",
  "email_address": "john@example.com",
  "user_type": "member",
  "created_at": "2024-01-01T10:00:00.000Z",
  "updated_at": "2024-01-01T10:00:00.000Z"
}
```

**Response (422):**
```json
{
  "email_address": ["has already been taken"],
  "password": ["can't be blank"]
}
```

---

### 2. Sessions (Authentication)

#### Login
- **Method**: `POST`
- **Endpoint**: `/session`
- **Description**: Authenticates a user and returns a token
- **Authentication**: Not required
- **Rate Limit**: 10 attempts per 3 minutes

**Request Body:**
```json
{
  "email_address": "john@example.com",
  "password": "password123"
}
```

**Response (201):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (401):**
```json
{
  "error": "Invalid email or password"
}
```

**Response (429):**
```
HTTP 429 Too Many Requests
```

#### Logout
- **Method**: `DELETE`
- **Endpoint**: `/session`
- **Description**: Terminates the current session
- **Authentication**: Required

**Response (204):**
```
No Content
```

---

### 3. Books

#### List Books
- **Method**: `GET`
- **Endpoint**: `/books`
- **Description**: Lists all books with optional search
- **Authentication**: Required

**Query Parameters:**
- `term` (string, optional): Search term to filter by title, author, or genre

**Examples:**
- `/books` - List all books
- `/books?term=Harry Potter` - Search books by term

**Response (200):**
```json
[
  {
    "id": 1,
    "title": "To Kill a Mockingbird",
    "author": "Harper Lee",
    "genre": "Fiction",
    "isbn": "978-0-06-112008-4",
    "total_copies": 3,
    "created_at": "2024-01-01T10:00:00.000Z",
    "updated_at": "2024-01-01T10:00:00.000Z"
  }
]
```

#### Get Book
- **Method**: `GET`
- **Endpoint**: `/books/:id`
- **Description**: Gets details of a specific book
- **Authentication**: Required

**Response (200):**
```json
{
  "id": 1,
  "title": "To Kill a Mockingbird",
  "author": "Harper Lee",
  "genre": "Fiction",
  "isbn": "978-0-06-112008-4",
  "total_copies": 3,
  "created_at": "2024-01-01T10:00:00.000Z",
  "updated_at": "2024-01-01T10:00:00.000Z"
}
```

#### Create Book
- **Method**: `POST`
- **Endpoint**: `/books`
- **Description**: Adds a new book to the collection
- **Authentication**: Required (librarians only)

**Request Body:**
```json
{
  "book": {
    "title": "1984",
    "author": "George Orwell",
    "genre": "Dystopian Fiction",
    "isbn": "978-0-452-28423-4",
    "total_copies": 2
  }
}
```

**Parameters:**
- `title` (string): Book title
- `author` (string): Book author
- `genre` (string): Literary genre
- `isbn` (string): Unique ISBN of the book
- `total_copies` (integer): Total number of copies

**Response (201):**
```json
{
  "id": 2,
  "title": "1984",
  "author": "George Orwell",
  "genre": "Dystopian Fiction",
  "isbn": "978-0-452-28423-4",
  "total_copies": 2,
  "created_at": "2024-01-01T11:00:00.000Z",
  "updated_at": "2024-01-01T11:00:00.000Z"
}
```

**Response (422):**
```json
{
  "isbn": ["has already been taken"],
  "title": ["can't be blank"]
}
```

#### Update Book
- **Method**: `PUT/PATCH`
- **Endpoint**: `/books/:id`
- **Description**: Updates book information
- **Authentication**: Required (librarians only)

**Request Body:**
```json
{
  "book": {
    "total_copies": 5
  }
}
```

**Response (200):**
```json
{
  "id": 1,
  "title": "To Kill a Mockingbird",
  "author": "Harper Lee",
  "genre": "Fiction",
  "isbn": "978-0-06-112008-4",
  "total_copies": 5,
  "created_at": "2024-01-01T10:00:00.000Z",
  "updated_at": "2024-01-01T12:00:00.000Z"
}
```

#### Delete Book
- **Method**: `DELETE`
- **Endpoint**: `/books/:id`
- **Description**: Removes a book from the collection
- **Authentication**: Required (librarians only)

**Response (204):**
```
No Content
```

---

### 4. Borrowings

#### List Borrowings
- **Method**: `GET`
- **Endpoint**: `/borrowings`
- **Description**: Lists borrowings (members see only their own, librarians see all)
- **Authentication**: Required

**Response (200):**
```json
[
  {
    "id": 1,
    "book_id": 1,
    "user_id": 2,
    "borrowed_at": "2024-01-01T10:00:00.000Z",
    "returned_at": null,
    "due_date": "2024-01-15T10:00:00.000Z",
    "created_at": "2024-01-01T10:00:00.000Z",
    "updated_at": "2024-01-01T10:00:00.000Z"
  }
]
```

#### Get Borrowing
- **Method**: `GET`
- **Endpoint**: `/borrowings/:id`
- **Description**: Gets details of a specific borrowing
- **Authentication**: Required

**Response (200):**
```json
{
  "id": 1,
  "book_id": 1,
  "user_id": 2,
  "borrowed_at": "2024-01-01T10:00:00.000Z",
  "returned_at": null,
  "due_date": "2024-01-15T10:00:00.000Z",
  "created_at": "2024-01-01T10:00:00.000Z",
  "updated_at": "2024-01-01T10:00:00.000Z"
}
```

#### Create Borrowing
- **Method**: `POST`
- **Endpoint**: `/borrowings`
- **Description**: Records a new book borrowing
- **Authentication**: Required

**Request Body:**
```json
{
  "borrowing": {
    "book_id": 1
  }
}
```

**Parameters:**
- `book_id` (integer): ID of the book to be borrowed

**Response (201):**
```json
{
  "id": 1,
  "book_id": 1,
  "user_id": 2,
  "borrowed_at": "2024-01-01T10:00:00.000Z",
  "returned_at": null,
  "due_date": "2024-01-15T10:00:00.000Z",
  "created_at": "2024-01-01T10:00:00.000Z",
  "updated_at": "2024-01-01T10:00:00.000Z"
}
```

**Response (422):**
```json
{
  "base": ["No copies available for this book"],
  "book_id": ["You already borrowed this book"]
}
```

#### Return Book
- **Method**: `PUT/PATCH`
- **Endpoint**: `/borrowings/:id`
- **Description**: Records the return of a borrowed book
- **Authentication**: Required

**Request Body:**
```json
{
  "borrowing": {
    "returned_at": "2024-01-10T14:30:00.000Z"
  }
}
```

**Parameters:**
- `returned_at` (datetime): Date and time of return

**Response (200):**
```json
{
  "id": 1,
  "book_id": 1,
  "user_id": 2,
  "borrowed_at": "2024-01-01T10:00:00.000Z",
  "returned_at": "2024-01-10T14:30:00.000Z",
  "due_date": "2024-01-15T10:00:00.000Z",
  "created_at": "2024-01-01T10:00:00.000Z",
  "updated_at": "2024-01-10T14:30:00.000Z"
}
```

---

### 5. Health Check

#### Check Application Status
- **Method**: `GET`
- **Endpoint**: `/up`
- **Description**: Endpoint to check if the application is running
- **Authentication**: Not required

**Response (200):**
```
OK
```

---

## HTTP Status Codes

- **200**: OK - Successful request
- **201**: Created - Resource created successfully
- **204**: No Content - Successful request with no content return
- **401**: Unauthorized - Authentication failed
- **403**: Forbidden - Access denied (lack of permission)
- **404**: Not Found - Resource not found
- **422**: Unprocessable Entity - Invalid data
- **429**: Too Many Requests - Rate limit exceeded
