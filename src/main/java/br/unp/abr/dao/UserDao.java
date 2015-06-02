package br.unp.abr.dao;

import br.unp.abr.model.User;

public interface UserDao {
	// Return a user by login credentials:
	public User getUser(String username, String password);
}