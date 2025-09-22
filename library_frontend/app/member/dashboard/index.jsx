import { BooksList } from "../../books_list";

const borrowedBooks = () => {
  return [
    { title: "The Great Gatsby", author: "F. Scott Fitzgerald", due_date: "2023-07-15" },
    { title: "1984", author: "George Orwell", due_date: "2023-07-20" },
    { title: "To Kill a Mockingbird", author: "Harper Lee", due_date: "2023-07-25" },
  ];
}

const overdueBooks = () => {
  return [
    { title: "The Great Gatsby", author: "F. Scott Fitzgerald", due_date: "2023-07-15" },
    { title: "1984", author: "George Orwell", due_date: "2023-07-20" },
  ]
}

export function Dashboard() {
  return (
    <main className="flex flex-col items-center mt-4">
      <div className="dark:bg-white w-xl p-4 rounded-lg shadow-md mb-4">
        <input type="search" className="border"/>
        <button className="border rounded-r-sm">Search</button>
      </div>
      <div className="flex items-center justify-center pt-16 pb-4">
        <div className="flex-1 flex items-center gap-16 min-h-0 justify-center">
          <div className="w-2/5 px-4">
            <BooksList title="Borrowed books" books={borrowedBooks()}></BooksList>
          </div>
          <div className="w-2/5 space-y-6 px-4">
            <BooksList title="Overdue books" books={overdueBooks()}></BooksList>
          </div>
        </div>
      </div>
    </main>
  );
}
