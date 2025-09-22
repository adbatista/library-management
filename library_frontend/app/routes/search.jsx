import { Books } from "../member/books";
import { api } from "../config";
export async function loader({ params }) {
  const books = await fetch(`${api}books?term=${params.term || ""}`)
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    })
    .catch(error => {
      console.error('Fetch error:', error);
    });

  return { books }
}


export default function Search({loaderData}) {
  return <Books books={loaderData.books}/>;
}
