import { BooksList } from "../../books_list";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Search from "../../routes/search";
import { Books } from "../../member/books";
import { useEffect, useMemo } from "react";
import { fetchBooks, fetchBorrowedBooks } from "../../utils";

const membersOverdue = () => {
  return [{name: "Mario", email: "mario@email.com"}]
}

const booksDueToday = () => [{
  id: 1, title: "The Great Gatsby", author: "F. Scott Fitzgerald", due_date: "2023-07-15"
}]

export function Dashboard() {
  const [books, setBooks] = useState([]);
  const [borrwedBooks, setBorrowedBooks] = useState([]);
  useEffect(() => {
    setBooks(fetchBooks());
    setBorrowedBooks(fetchBorrowedBooks());
  }, []);

  const booksCount = useMemo(() => books.length, [books]);
  const totalBorrowedBooks = useMemo(() => borrwedBooks.length, [borrwedBooks]);
  const booksDueToday = useMemo(() => {
    const today = new Date().toISOString().split('T')[0];
    return borrwedBooks.filter(book => book.due_date === today);
  }, [borrwedBooks]);
  const membersOverdue = useMemo(() => {
    const today = new Date().toISOString().split('T')[0];

    return borrwedBooks.filter(book => book.due_date < today)
  }, [borrwedBooks]);

  return (
    <main className="flex flex-col items-center mt-4">

      <div className="flex items-center justify-center pt-16 pb-4">
        <div className="flex-1 flex items-center gap-16 min-h-0 justify-center  text-gray-700 dark:text-gray-200 text-center">
          <div className="w-md px-4 rounded-3xl border border-gray-200 p-6 dark:border-gray-700 space-y-4">
            Total Books: { booksCount }
          </div>
          <div className="w-md px-4 rounded-3xl border border-gray-200 p-6 dark:border-gray-700 space-y-4">
            Total Borrowed Books: { totalBorrowedBooks }
          </div>
          <div className="space-y-6 px-4">
            <BooksList title="Books Due Today" books={booksDueToday} showReturnBookButton={true} />
          </div>
          <div className="space-y-6 px-4">
            <p>Member Overdue</p>
            <ul className="dark:text-gray-200">
              {membersOverdue().map(({ name, email }) => (
                <li key={name}>
                  {name} - {email}
                </li>
              ))}
            </ul>
          </div>

        </div>
      </div>
    </main>
  );
}
