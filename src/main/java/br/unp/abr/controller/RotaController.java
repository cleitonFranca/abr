package br.unp.abr.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import br.unp.abr.dao.RotaDao;
import br.unp.abr.dao.UserDao;
import br.unp.abr.model.Rota;
import br.unp.abr.model.User;

@Controller
public class RotaController {
	
	@Autowired
	private UserDao userDao;
	@Autowired
	private RotaDao rotaDao;
	final Logger logger = LoggerFactory.getLogger(RotaController.class);
	
	
	@RequestMapping(value="/rota/addRota",  method = RequestMethod.POST)
	public String addRota(@ModelAttribute("Rota") Rota r, BindingResult result, ModelMap model){
		
		User user = rotaDao.getUser(r.getUser_Id());
		Integer userId = user.getUserId();
		List<Rota> rotas = (List<Rota>) rotaDao.listaRotas(userId);
		Rota rc = rotaDao.getRota(r.getOrigem());
		
			if(rc != null){
				
				System.out.println(rc.getOrigem());
				model.addAttribute("USERID", userId);
				model.addAttribute("listaDeRotas", rotas);
				model.addAttribute("msg","Rota já existe");
				return "app";
			}
		
		// variaveis de acesso na view
		model.addAttribute("USERID", userId);
		model.addAttribute("listaDeRotas", rotas);
		this.rotaDao.addRota(r);
		return "app";
	}

}
