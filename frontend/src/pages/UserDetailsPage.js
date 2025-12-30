import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import userService from '../services/userService';
import UserForm from '../components/UserForm';
import './UserDetailsPage.css';

function UserDetailsPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [isEditing, setIsEditing] = useState(false);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);

  useEffect(() => {
    fetchUser();
  }, [id]);

  const fetchUser = async () => {
    try {
      setLoading(true);
      setError('');
      const response = await userService.getUserById(id);
      setUser(response.data);
    } catch (err) {
      setError('Failed to load user details.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async () => {
    try {
      await userService.deleteUser(id);
      navigate('/');
    } catch (err) {
      setError('Failed to delete user.');
      console.error(err);
    }
  };

  const handleUpdateSuccess = () => {
    setIsEditing(false);
    fetchUser();
  };

  if (loading) {
    return <div className="loading">Loading user details...</div>;
  }

  if (error && !user) {
    return (
      <div className="error-container">
        <div className="error-message">{error}</div>
        <button className="btn btn-primary" onClick={() => navigate('/')}>
          Back to Users
        </button>
      </div>
    );
  }

  return (
    <div className="user-details-page">
      <button className="btn btn-secondary back-btn" onClick={() => navigate('/')}>
        ← Back to Users
      </button>

      <div className="card">
        {!isEditing ? (
          <>
            <div className="user-header">
              <h2>User Details</h2>
              <div className="action-buttons">
                <button 
                  className="btn btn-primary"
                  onClick={() => setIsEditing(true)}
                >
                  Edit
                </button>
                <button 
                  className="btn btn-danger"
                  onClick={() => setShowDeleteConfirm(true)}
                >
                  Delete
                </button>
              </div>
            </div>

            {error && <div className="error-message">{error}</div>}

            <div className="user-details">
              <div className="detail-row">
                <span className="label">ID:</span>
                <span className="value">{user.id}</span>
              </div>
              <div className="detail-row">
                <span className="label">First Name:</span>
                <span className="value">{user.firstname}</span>
              </div>
              <div className="detail-row">
                <span className="label">Last Name:</span>
                <span className="value">{user.lastname}</span>
              </div>
              <div className="detail-row">
                <span className="label">Email:</span>
                <span className="value">{user.email}</span>
              </div>
            </div>

            {showDeleteConfirm && (
              <div className="delete-confirm">
                <p>Are you sure you want to delete this user?</p>
                <div className="confirm-buttons">
                  <button 
                    className="btn btn-danger"
                    onClick={handleDelete}
                  >
                    Yes, Delete
                  </button>
                  <button 
                    className="btn btn-secondary"
                    onClick={() => setShowDeleteConfirm(false)}
                  >
                    Cancel
                  </button>
                </div>
              </div>
            )}
          </>
        ) : (
          <>
            <h2>Edit User</h2>
            <UserForm 
              user={user} 
              onSuccess={handleUpdateSuccess}
              onCancel={() => setIsEditing(false)}
            />
          </>
        )}
      </div>
    </div>
  );
}

export default UserDetailsPage;
