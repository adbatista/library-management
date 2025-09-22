import {api} from "../config";

const returnBook = (id) => {
  fetch(`${api}borrowings/${id}`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({returned_at: new Date()})
  })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
    })
    .catch(error => {
      console.error('Error creating post:', error);
    });
}
export function BooksList({title, books, showReturnBookButton = false}) {
  return (
    <div className="rounded-3xl border border-gray-200 p-6 dark:border-gray-700 space-y-4">
      <p className="leading-6 text-gray-700 dark:text-gray-200 text-center">
        {title}
      </p>
      <ul className="dark:text-gray-200">
        {books.map(({ id, title, author, due_date }) => (
          <li key={id}>
            {title} by {author} - Due on {due_date}
            { showReturnBookButton && (<button className="ml-2" onClick={returnBook(id)}>Return Book</button>) }
          </li>
        ))}
      </ul>
    </div>
  )
}
