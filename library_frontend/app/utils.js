import { api } from "./config"

export const fetchBooks = async (term = "") => {
  fetch(`${api}books?term=${term}`)
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    })
    .catch(error => {
      console.error('Fetch error:', error);
    });
}

export const fetchBorrowedBooks = async (term = "") => {
  fetch(`${api}borrowings`)
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    })
    .catch(error => {
      console.error('Fetch error:', error);
    });
}
