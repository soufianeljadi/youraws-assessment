import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import userService from '../services/userService';
import UserForm from '../components/UserForm';
import './UserListPage.css';

function UserListPage() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showForm, setShowForm] = useState(false);

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      setError('');
      const response = await userService.getAllUsers();
      setUsers(response.data);
    } catch (err) {
      setError('Failed to load users. Please try again.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleUserCreated = () => {
    setShowForm(false);
    fetchUsers();
  };

  if (loading) {
    return <div className="loading">Loading users...</div>;
  }

  return (
    <div className="user-list-page">
      <div className="page-header">
        <h2>Users List</h2>
        <button 
          className="btn btn-primary"
          onClick={() => setShowForm(!showForm)}
        >
          {showForm ? 'Cancel' : 'Add New User'}
        </button>
      </div>

      {error && <div className="error-message">{error}</div>}

      {showForm && (
        <div className="card">
          <h3>Create New User</h3>
          <UserForm onSuccess={handleUserCreated} />
        </div>
      )}

      <div className="users-grid">
        {users.length === 0 ? (
          <div className="no-users">
            <p>No users found. Create your first user!</p>
          </div>
        ) : (
          users.map(user => (
            <div key={user.id} className="user-card">
              <div className="user-info">
                <h3>{user.firstname} {user.lastname}</h3>
                <p className="user-email">{user.email}</p>
                <p className="user-id">ID: {user.id}</p>
              </div>
              <Link to={`/users/${user.id}`} className="btn btn-primary">
                View Details
              </Link>
            </div>
          ))
        )}
      </div>
    </div>
  );
}

export default UserListPage;
