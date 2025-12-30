const db = require('../config/database');

const User = {
  // Get all users
  findAll: async () => {
    const [rows] = await db.query('SELECT * FROM users ORDER BY id DESC');
    return rows;
  },

  // Get user by ID
  findById: async (id) => {
    const [rows] = await db.query('SELECT * FROM users WHERE id = ?', [id]);
    return rows[0];
  },

  // Create new user
  create: async (userData) => {
    const { firstname, lastname, email } = userData;
    const [result] = await db.query(
      'INSERT INTO users (firstname, lastname, email) VALUES (?, ?, ?)',
      [firstname, lastname, email]
    );
    return result.insertId;
  },

  // Update user
  update: async (id, userData) => {
    const { firstname, lastname, email } = userData;
    const [result] = await db.query(
      'UPDATE users SET firstname = ?, lastname = ?, email = ? WHERE id = ?',
      [firstname, lastname, email, id]
    );
    return result.affectedRows;
  },

  // Delete user
  delete: async (id) => {
    const [result] = await db.query('DELETE FROM users WHERE id = ?', [id]);
    return result.affectedRows;
  },

  // Check if email exists
  emailExists: async (email, excludeId = null) => {
    let query = 'SELECT id FROM users WHERE email = ?';
    const params = [email];
    
    if (excludeId) {
      query += ' AND id != ?';
      params.push(excludeId);
    }
    
    const [rows] = await db.query(query, params);
    return rows.length > 0;
  }
};

module.exports = User;
