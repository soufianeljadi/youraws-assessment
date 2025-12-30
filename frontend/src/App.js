import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import UserListPage from './pages/UserListPage';
import UserDetailsPage from './pages/UserDetailsPage';
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <nav className="navbar">
          <div className="container">
            <h1>User Management System</h1>
            <Link to="/" className="nav-link">Home</Link>
          </div>
        </nav>
        <div className="container">
          <Routes>
            <Route path="/" element={<UserListPage />} />
            <Route path="/users/:id" element={<UserDetailsPage />} />
          </Routes>
        </div>
      </div>
    </Router>
  );
}

export default App;
