package br.unp.abr.dao;

import java.util.List;

import br.unp.abr.model.Rota;
import br.unp.abr.model.User;



public interface RotaDao {
	public Rota getRota(String nome);
	public User getUser(int idUser);
	public void addRota(Rota rota);
	public void deleteRota(int idRota);
	public List<Rota> listaRotas(int idUser);

}
