package br.unp.abr.controller;

import java.util.List;
import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.Valid;
import javax.validation.Validator;

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
public class WelcomeController {

	@Autowired
	private Validator validator;
	@Autowired
	private UserDao userDao;
	@Autowired
	private RotaDao rotaDao;
	final Logger logger = LoggerFactory.getLogger(WelcomeController.class);

	// the login form has been submitted:
	@RequestMapping(value = "/welcome", method = RequestMethod.POST)
	public String submit(@ModelAttribute("USER") @Valid User user,
			BindingResult result, ModelMap model) {

		// validate user:
		Set<ConstraintViolation<User>> violations = validator.validate(user);

		// check the form for errors:
		if (violations.size() > 0) {
			user.setValidUser(true);
			return "login";
		} else if (userDao.getUser(user.getUsername(), user.getPassword()) != null) {
			user = userDao.getUser(user.getUsername(), user.getPassword());
			List<Rota> rotas = (List<Rota>) rotaDao.listaRotas(user.getUserId());
			
			// variaveis de acesso na view
			model.addAttribute("USER", user);
			model.addAttribute("user_id", user.getUserId());
			model.addAttribute("listaDeRotas", rotas);
			
			return "app";
		} else {
			// if this line is reached, it is a non existent user:
			user.setValidUser(false);
			return "login";
		}
	}
	
	

}
