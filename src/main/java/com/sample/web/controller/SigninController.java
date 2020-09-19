package com.sample.web.controller;



import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;



import com.sample.dto.UserInfoDto;
import com.sample.service.UserService;

import com.sample.web.form.FindUserInfo;
import com.sample.web.form.LoginForm;
import com.sample.web.view.Pagination;
import com.sample.web.view.User;

@Controller
@SessionAttributes({"LOGIN_USER", "LOGIN_TYPE"})
public class SigninController {

	
	@Autowired
	private UserService userService;

	@Value("#{gongsa['sms.id']}")
	private String smsId;
	
	@Value("#{gongsa['sms.pw']}")
	private String smsPw;
	
	@Value("#{gongsa['sms.email']}")
	private String smsEmail;
	
	@Value("#{gongsa['server.url']}")
	private String serverUrl;
	
	
	@GetMapping("/signin.do")
	public String signinForm(Model model) {
		LoginForm loginForm = new LoginForm();
		model.addAttribute("loginForm", loginForm);

		return "user/signin";

	}

	@PostMapping("/signin.do")
	public String signin(@ModelAttribute("loginForm") @Valid LoginForm loginForm, BindingResult errors, Model model) {

		if (errors.hasErrors()) {

			return "user/signin";
		}
		//로그인 처리
		User user = userService.loginUser(loginForm.getId(), loginForm.getPassword());
		if (user == null) {

			return "redirect:/signin.do?error=fail";

		}

		// 로그인된 사용자 정보를 세션에 저장
		model.addAttribute("LOGIN_USER", user);
		model.addAttribute("LOGIN_TYPE", "web");

		return "redirect:/home.do";

	}

	@GetMapping("/signout.do")
	public String signout(SessionStatus sessionStatus, HttpSession session) {
		sessionStatus.setComplete();


		return "redirect:/home.do";
	}



	@RequestMapping("/sendMail.do")
	public String mailSender(@ModelAttribute("findUserInfo") @Valid FindUserInfo findUserInfo, BindingResult errors, ModelMap mo) throws AddressException, MessagingException { 

		// 네이버일 경우 smtp.naver.com 을 입력합니다. 
		// Google일 경우 smtp.gmail.com 을 입력합니다. 
		if (errors.hasErrors()) {
			return "user/findId";
		}

		String host = "smtp.naver.com"; 
		final String username = smsId; //네이버 아이디를 입력해주세요. @nave.com은 입력하지 마시구요. 
		final String password = smsPw; //네이버 이메일 비밀번호를 입력해주세요.
		
		int port=465; //포트번호 
		
		User user = userService.getUserByEmail(findUserInfo.getEmail());
		if (user == null) {
			return "redirect:/findId.do?error=fail";
		}	
		// 메일 내용 
		// String recipient = "aldus207"; //받는 사람의 메일주소를 입력해주세요. 
		String subject = "공공연한 사이입니다."; //메일 제목 입력해주세요. 
		String body = "안녕하세요 공공연한 사이입니다." + "\n회원님의 ID는" + user.getId() + "입니다."; //메일 내용 입력해주세요. 

		Properties props = System.getProperties(); // 정보를 담기 위한 객체 생성 

		// SMTP 서버 정보 설정 
		props.put("mail.smtp.host", host); 
		props.put("mail.smtp.port", port); 
		props.put("mail.smtp.auth", true); 
		props.put("mail.smtp.ssl.enable", true); 
		props.put("mail.smtp.ssl.trust", host); 
				
		//Session 생성 
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() 
		{ 
			String un=username; 
			String pw=password; 
			protected javax.mail.PasswordAuthentication getPasswordAuthentication() { 
				return new javax.mail.PasswordAuthentication(un, pw); 
			} 
		}); 
		session.setDebug(true); //for debug 

		Message mimeMessage = new MimeMessage(session); //MimeMessage 생성 
		mimeMessage.setFrom(new InternetAddress(smsEmail)); //발신자 셋팅 , 보내는 사람의 이메일주소를 한번 더 입력합니다. 이때는 이메일 풀 주소를 다 작성해주세요. 
		if (findUserInfo.getEmail().isEmpty()) {
			return "redirect:/findId.do";
		}
		
		
		mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(findUserInfo.getEmail())); //수신자셋팅 //.TO 외에 .CC(참조) .BCC(숨은참조) 도 있음 
		mimeMessage.setSubject(subject); //제목셋팅 
		mimeMessage.setText(body); //내용셋팅 
		Transport.send(mimeMessage); //javax.mail.Transport.send() 이용 
		
		return "user/mailCompl";
	}
	
	
	
	@RequestMapping("/sendMailPwd.do")
	public String mailSenderPwd(@ModelAttribute("findUserInfo") @Valid FindUserInfo findUserInfo, BindingResult errors, ModelMap mo) throws AddressException, MessagingException { 
		
		System.out.println("email : "+findUserInfo.getEmail());
		// 네이버일 경우 smtp.naver.com 을 입력합니다. 
		// Google일 경우 smtp.gmail.com 을 입력합니다. 
		if (errors.hasErrors()) {
			return "user/findPwd";
		}
		
		String host = "smtp.naver.com"; 
		final String username = smsId; //네이버 아이디를 입력해주세요. @nave.com은 입력하지 마시구요. 
		final String password = smsPw; //네이버 이메일 비밀번호를 입력해주세요.
		
		int port=465; //포트번호 
		
		User user = userService.getUserByEmail(findUserInfo.getEmail());
		if (user == null) {
			
			return "redirect:/findPwd.do?error=fail";
			
		}	
		// 메일 내용 
		String subject = "공공연한 사이입니다."; //메일 제목 입력해주세요. 
		String body = "안녕하세요 공공연한 사이입니다." + "\n회원님의 비밀번호는" + user.getPassword() + "입니다."; //메일 내용 입력해주세요. 
		
		Properties props = System.getProperties(); // 정보를 담기 위한 객체 생성 
		
		// SMTP 서버 정보 설정 
		props.put("mail.smtp.host", host); 
		props.put("mail.smtp.port", port); 
		props.put("mail.smtp.auth", true); 
		props.put("mail.smtp.ssl.enable", true); 
		props.put("mail.smtp.ssl.trust", host); 
		
		//Session 생성 
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() 
		{ 
			String un=username; 
			String pw=password; 
			protected javax.mail.PasswordAuthentication getPasswordAuthentication() { 
				return new javax.mail.PasswordAuthentication(un, pw); 
			} 
		}); 
		session.setDebug(true); //for debug 
		
		Message mimeMessage = new MimeMessage(session); //MimeMessage 생성 
		mimeMessage.setFrom(new InternetAddress(smsEmail)); //발신자 셋팅 , 보내는 사람의 이메일주소를 한번 더 입력합니다. 이때는 이메일 풀 주소를 다 작성해주세요. 
		if (findUserInfo.getEmail().isEmpty()) {
			
			return "redirect:/findPwd.do";
		}
		
		
		mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(findUserInfo.getEmail())); //수신자셋팅 //.TO 외에 .CC(참조) .BCC(숨은참조) 도 있음 
		mimeMessage.setSubject(subject); //제목셋팅 
		mimeMessage.setText(body); //내용셋팅 
		Transport.send(mimeMessage); //javax.mail.Transport.send() 이용 
		
		return "user/mailCompl";
	}
	
	
	@PostMapping("/sendMailTerm.do")
	public String mailSenderTerm(@ModelAttribute("findUserInfo") @Valid FindUserInfo findUserInfo, BindingResult errors, ModelMap mo) throws AddressException, MessagingException { 
		
		System.out.println("email : "+findUserInfo.getEmail());
		// 네이버일 경우 smtp.naver.com 을 입력합니다. 
		// Google일 경우 smtp.gmail.com 을 입력합니다. 
		User user = userService.getUserByEmail(findUserInfo.getEmail());
		System.out.println("이메일로 검색한 사용자 : " + user);
		if (user != null) {
			errors.rejectValue("email", null, "이미 가입한 이메일입니다.");
		}
		if (errors.hasErrors()) {
			return "user/term";
		}
		
		String host = "smtp.naver.com"; 
		final String username = smsId; //네이버 아이디를 입력해주세요. @nave.com은 입력하지 마시구요. 
		final String password = smsPw; //네이버 이메일 비밀번호를 입력해주세요.
		
		int port=465; //포트번호 
		// 메일 내용 
		// String recipient = "aldus207"; //받는 사람의 메일주소를 입력해주세요. 
		String subject = "공공연한 사이입니다."; //메일 제목 입력해주세요. 
		String customerEamil = findUserInfo.getEmail();
		String body = "이 <a href='"+serverUrl+"/signup.do?email="+customerEamil+"'>링크</a>를 타고가서 회원가입해주시기 바랍니다."; //메일 내용 입력해주세요. 
		
		Properties props = System.getProperties(); // 정보를 담기 위한 객체 생성 
		
		// SMTP 서버 정보 설정 
		props.put("mail.smtp.host", host); 
		props.put("mail.smtp.port", port); 
		props.put("mail.smtp.auth", true); 
		props.put("mail.smtp.ssl.enable", true); 
		props.put("mail.smtp.ssl.trust", host); 
		
		//Session 생성 
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() 
		{ 
			String un=username; 
			String pw=password; 
			protected javax.mail.PasswordAuthentication getPasswordAuthentication() { 
				return new javax.mail.PasswordAuthentication(un, pw); 
			} 
		}); 
		session.setDebug(true); //for debug 
		
		Message mimeMessage = new MimeMessage(session); //MimeMessage 생성 
		mimeMessage.setFrom(new InternetAddress(smsEmail)); //발신자 셋팅 , 보내는 사람의 이메일주소를 한번 더 입력합니다. 이때는 이메일 풀 주소를 다 작성해주세요. 
		if (findUserInfo.getEmail().isEmpty()) {
			System.out.println("안돼!");
			
			return "redirect:/term.do";
		}
		
		
		mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(findUserInfo.getEmail())); //수신자셋팅 //.TO 외에 .CC(참조) .BCC(숨은참조) 도 있음 
		mimeMessage.setSubject(subject); //제목셋팅 
		mimeMessage.setContent(body, "text/html;charset=utf-8"); //내용셋팅 
		Transport.send(mimeMessage); //javax.mail.Transport.send() 이용 
		System.out.println("실행");
		
		return "user/mailCompl";
	}


	@GetMapping("/findId.do")
	public String findIdForm(Model model) {
		model.addAttribute("findUserInfo", new FindUserInfo());
		return "user/findId";
	}
	
	@GetMapping("/findPwd.do")
	public String findPwdForm(Model model) {
		model.addAttribute("findUserInfo", new FindUserInfo());
		return "user/findPwd";
	}
	
	@GetMapping("/adminProfile.do")
	public String adminProfile(Model model, 
			@RequestParam(value = "pageNo", required=false, defaultValue="1") int pageNo,
			@RequestParam(value = "sort", required=false, defaultValue="date") String sort,
			@RequestParam(value = "query", required=false) String query) {
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("sort", sort);
		if (query != null) {
			param.put("query", query);
		}
		
		int total = userService.getAllUsersCount(param);
		int row = 10;
		Pagination pagination = new Pagination(row, 3, pageNo, total);
		int beginIndex  = pagination.getBeginIndex() - 1;
		int endIndex = row;
		
		param.put("endIndex", endIndex);
		param.put("beginIndex", beginIndex);
		
		List<UserInfoDto> userList = userService.getAllUsers(param);
		System.out.println(pagination);
	
		model.addAttribute("pagination", pagination);
		model.addAttribute("users", userList);
		
		return "user/adminProfile";
	}
	
	@RequestMapping("/adminProfileDetail.do")
	@ResponseBody
	public UserInfoDto adminProfileDetail(@RequestParam("id") String id ) {
		
		UserInfoDto userDetail = userService.getUserInfoDetail(id);
		
		return userDetail;
	}

	
}	


