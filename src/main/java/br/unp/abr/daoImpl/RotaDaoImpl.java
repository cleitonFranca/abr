package br.unp.abr.daoImpl;

import java.util.List;

import javax.transaction.Transactional;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import br.unp.abr.dao.RotaDao;
import br.unp.abr.model.Rota;
import br.unp.abr.model.User;

@Repository("rotaDao")
@Transactional
public class RotaDaoImpl implements RotaDao {
	
	@Autowired
	private SessionFactory sessionFactory;

	@Override
	public Rota getRota(String origem) {
		
		return (Rota) this.sessionFactory.getCurrentSession()
				.createQuery("FROM Rota r WHERE r.origem = :origem")
				.setParameter("origem", origem)
				.uniqueResult();
	}

	@Override
	public User getUser(int idUser) {
		User u = (User) this.sessionFactory.getCurrentSession().get(User.class, new Integer(idUser));
		
		return u;
	}

	@Override
	public void addRota(Rota rota) {
		this.sessionFactory.getCurrentSession().persist(rota);
	}

	@Override
	public void deleteRota(int idRota) {
		Rota r = (Rota) this.sessionFactory.getCurrentSession().get(Rota.class, idRota);
		
		if(r != null){
			this.sessionFactory.getCurrentSession().delete(r);
		}		
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Rota> listaRotas(int idUser) {
	
		List<Rota> listarRotas = (List<Rota>) this.sessionFactory.getCurrentSession()
				.createQuery("FROM Rota r WHERE r.user_Id = :id_user")
				.setParameter("id_user", idUser).list();
		
		return listarRotas;
		 
	}

}
