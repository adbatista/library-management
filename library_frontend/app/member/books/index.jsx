export function Books({books}) {
  return (
    <main className="flex flex-col items-center mt-4">
      <div className="flex items-center justify-center pt-16 pb-4">
        <div className="flex-1 flex items-center gap-16 min-h-0 justify-center">
          <div className="w-2/5 px-4">
            <div className="rounded-3xl border border-gray-200 p-6 dark:border-gray-700 space-y-4">
              <p className="leading-6 text-gray-700 dark:text-gray-200 text-center">
                Books
              </p>
              <ul className="dark:text-gray-200">
                {books.map(({ title, author, due_date }) => (
                  <li key={title}>
                    {title} by {author} - Due on {due_date}
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>
      </div>
    </main>
  );
}
