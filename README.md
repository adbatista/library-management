# Library Management System

* the dashboard requirements
  ```
  Dashboard:
  - Librarian:
    - A dashboard showing total books, total borrowed books, books due today, and a list of members with overdue books.
  - Member:
    - A dashboard showing books they've borrowed, their due dates, and any
  overdue books.
  ```
  * it's in the backend section but it's a frontend task

* forgot password and password update are not in the requirements, it'll no be implemented due the time

* the PDF has incomplete details
  ```
  API Endpoints:
  ○ Develop a RESTful API that allows CRUD operations for books and borrowings.
  ○ Ensure proper status codes and responses for each endpoint.
  ○ Testing should be done with RSPEC.
  ○ Spec files should be included for all the requirements above.

  ```
  * it says nothing about the authentication endpoints

* it says nothing about user name if it should have or not, so I added it only one field for the whole name

* author field in the book table for this simple case and based on the PDF requirements does not need to be a separate table

* the requirements do not say anythinb about the librarian that maked the book as returned, so I did not add this field
* I'm not shure if the librarian can also borrow a books, so I did not allow this
* `They can't borrow the same book multiple times.` I'm assuming once borrowed even if returned they can't borrow it again
