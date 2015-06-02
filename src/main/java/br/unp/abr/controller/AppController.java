package br.unp.abr.controller;

import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import br.unp.abr.model.User;

import org.springframework.web.bind.support.SessionStatus;

@Controller
public class AppController {

	private static final Logger logger = LoggerFactory
			.getLogger(AppController.class);

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String login(Locale locale, Model model, SessionStatus status) {
		// clear previous session data first:
		logger.info("Erasing session data first ...");
		status.setComplete();

		logger.info("Add a new user object into the model attribute:");
		// create an empty user object:
		User user = new User();
		// avoid default login error message:
		user.setValidUser(true);
		model.addAttribute("USER", user);
		return "login";
	}
}
