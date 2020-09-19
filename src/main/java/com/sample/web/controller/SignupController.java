package com.sample.web.controller;


import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.sample.service.UserService;
import com.sample.web.form.FindUserInfo;
import com.sample.web.form.UserSignupForm;
import com.sample.web.form.UserUpdateForm;
import com.sample.web.view.User;

@Controller
@SessionAttributes({"LOGIN_USER", "LOGIN_TYPE"})
public class SignupController {

	@Autowired
	private UserService userService;

	@GetMapping("/signup.do")
	public String form(Model model, @RequestParam("email") String customerEmail) {
		UserSignupForm userSignupForm = new UserSignupForm();
		userSignupForm.setEmail(customerEmail);
		model.addAttribute("userSignupForm", userSignupForm);
		return "user/signup";

	}

	// 회원가입 폼 입력후 완료 페이지
	@PostMapping("/signup.do")
	public String signup(@ModelAttribute("userSignupForm") @Valid UserSignupForm userForm, BindingResult errors) {

		// System.out.println(userForm.getId());
		// 아이디 중복체크
		Map<String, Object> condition = new HashMap<String, Object>();

		condition.put("column", "id");
		condition.put("value", userForm.getId());
		User savedUser = userService.getUserDetailByCondition(condition);
		if (savedUser != null) {
			errors.rejectValue("id", null, "이미 사용중인 아이디입니다.");
		}

		condition.put("column", "nickname");
		condition.put("value", userForm.getNickname());
		savedUser = userService.getUserDetailByCondition(condition);
		if (savedUser != null) {
			errors.rejectValue("nickname", null, "이미 사용중인 닉네임입니다.");
		}

		condition.put("column", "email");
		condition.put("value", userForm.getEmail());
		savedUser = userService.getUserDetailByCondition(condition);
		if (savedUser != null) {
			errors.rejectValue("email", null, "이미 사용중인 이메일입니다.");
		}

		condition.put("column", "tel");
		condition.put("value", userForm.getTel());
		savedUser = userService.getUserDetailByCondition(condition);
		if (savedUser != null) {
			errors.rejectValue("tel", null, "이미 사용중인 전화번호입니다.");
		}

		System.out.println("유효성 체크결과 에러가 발견되었는가? " + errors.hasErrors());
		if (errors.hasErrors()) {
			return "user/signup"; // 입력화면으로 내부이동하기
		}

		// 유효성 체크를 통한 입력값을 User객체에 복사한다.
		User user = new User();
		BeanUtils.copyProperties(userForm, user);
		// System.out.println(user);

		// 회원가입 처리
		userService.addUser(user);

		return "redirect:/signupCompl.do";
	}

	@PostMapping("/snsSignup.do")
	public String snsSignup(@ModelAttribute("userSignupForm") @Valid UserSignupForm userForm, BindingResult errors) {

		// System.out.println(userForm.getId());
		// 아이디 중복체크
		Map<String, Object> condition = new HashMap<String, Object>();

		condition.put("column", "id");
		condition.put("value", userForm.getId());
		User savedUser = userService.getUserDetailByCondition(condition);
		if (savedUser != null) {
			errors.rejectValue("id", null, "이미 사용중인 아이디입니다.");
		}

		condition.put("column", "nickname");
		condition.put("value", userForm.getNickname());
		savedUser = userService.getUserDetailByCondition(condition);
		if (savedUser != null) {
			errors.rejectValue("nickname", null, "이미 사용중인 닉네임입니다.");
		}

		condition.put("column", "email");
		condition.put("value", userForm.getEmail());
		savedUser = userService.getUserDetailByCondition(condition);
		if (savedUser != null) {
			errors.rejectValue("email", null, "이미 사용중인 이메일입니다.");
		}

		condition.put("column", "tel");
		condition.put("value", userForm.getTel());
		savedUser = userService.getUserDetailByCondition(condition);
		if (savedUser != null) {
			errors.rejectValue("tel", null, "이미 사용중인 전화번호입니다.");
		}

		System.out.println("유효성 체크결과 에러가 발견되었는가? " + errors.hasErrors());
		if (errors.hasErrors()) {
			return "user/snsSignup"; // 입력화면으로 내부이동하기
		}

		// 유효성 체크를 통한 입력값을 User객체에 복사한다.
		User user = new User();
		BeanUtils.copyProperties(userForm, user);
		// System.out.println(user);

		// 회원가입 처리
		userService.addUser(user);

		return "redirect:/signupCompl.do";
	}

	@RequestMapping("/signupCompl.do")
	public String signupCompl() {
		return "user/signupCompl";
	}

	@GetMapping("/term.do")
	public String term(Model model) {
		model.addAttribute("findUserInfo", new FindUserInfo());
		return "user/term";
	}

	@RequestMapping("/snsTerm.do")
	public String snsTerm(Model model) {

		return "user/snsTerm";
	}

	@RequestMapping("/signupComplete.do")
	public String signupComplete() {
		return "redirect:/home.do";
	}

	@RequestMapping("/userUpdate.do")
	public String updateUserInfo(@ModelAttribute("userUpdateForm") @Valid UserUpdateForm userUpdateForm,
			BindingResult errors, HttpSession session, Model model) {

		Map<String, Object> condition = new HashMap<String, Object>();

		condition.put("column", "nickname");
		condition.put("value", userUpdateForm.getNickname());
		User savedUser = userService.getUserDetailByCondition(condition);
		savedUser = userService.getUserDetailByCondition(condition);

		condition.put("column", "nickname");
		condition.put("value", userUpdateForm.getNickname());
		savedUser = userService.getUserDetailByCondition(condition);

		User sessionUser = (User) session.getAttribute("LOGIN_USER");

		if (!sessionUser.getNickname().equals(userUpdateForm.getNickname())) {

			if (savedUser != null) {
				errors.rejectValue("nickname", null, "이미 사용중인 닉네임입니다.");
			}

		}

		condition.put("column", "tel");
		condition.put("value", userUpdateForm.getTel());
		savedUser = userService.getUserDetailByCondition(condition);

		if (!sessionUser.getTel().equals(userUpdateForm.getTel())) {

			if (savedUser != null) {
				errors.rejectValue("tel", null, "이미 사용중인 전화번호입니다.");
			}

		}

		if (errors.hasErrors()) {
			return "user/userUpdate"; // 입력화면으로 내부이동하기
		}

		User user = new User();
		BeanUtils.copyProperties(userUpdateForm, user);

		// 회원 정보 수정 처리
		userService.fixUser(user);
		session.invalidate();
		model.addAttribute("LOGIN_USER", user);
		model.addAttribute("LOGIN_TYPE", "web");

		return "redirect:/mypage/mypagemain.do";
	}
		
	@RequestMapping("/deleteUser.do")
	@ResponseBody
	public void deleteUser(@RequestParam("id") String userId, HttpSession session) {
		userService.deleteUser(userId);
		session.invalidate();
		
	}	

	

	
}
