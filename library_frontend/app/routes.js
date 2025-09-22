import { index, route } from "@react-router/dev/routes";

export default [
  index("routes/home.jsx"),
  route("login", "routes/login.jsx"),
  route("sign_up", "routes/sign_up.jsx"),
  route("search", "routes/search.jsx"),
];
