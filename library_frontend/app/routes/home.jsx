import { Dashboard as MemberDashboard } from "../member/dashboard";
import { Dashboard as LibrarianDashboard } from "../librarian/dashboard";

export default function Home() {
  // return <MemberDashboard />;
  return <LibrarianDashboard />;
}
