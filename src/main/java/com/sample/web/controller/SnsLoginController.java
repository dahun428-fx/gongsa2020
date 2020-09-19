package com.sample.web.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sample.service.UserService;
import com.sample.web.form.UserSignupForm;
import com.sample.web.view.User;

@Controller
@SessionAttributes({"LOGIN_USER", "LOGIN_TYPE"})
public class SnsLoginController {

	@Autowired
	private UserService userService;
	
	@Value("#{gongsa['server.url']}")
	private String serverUrl;
	
	@Value("#{gongsa['kakao.restKey']}")
	private String kakaoRestKey;
	
	@Value("#{gongsa['kakao.clientSecretKey']}")
	private String kakaoClientSecret;
	
	@RequestMapping("/sns/signup.do")
	public String snsSignup(@RequestParam("email") String email,
			 Model model) {									///////////////////////////		9
		
		
		UserSignupForm userSignupForm = new UserSignupForm();
		userSignupForm.setEmail(email);
		userSignupForm.setId(email);
		
		model.addAttribute("userSignupForm", userSignupForm);
		
		return "user/snsSignup";																	////////////////////////          10
	}
	
	@GetMapping("/sns/kakao.do")
	public String getKakaoSignIn(@RequestParam("code") String code, RedirectAttributes redirectAttributes, Model model) throws Exception {
//		System.out.println("[카카오 사용자 인증] 완료");		/////////////////////////////////////////////////////////////////////////        1
		
//		System.out.println("[카카오 사용자 인증] 사용자 프로필 정보 조회");
		String accessToken = this.getAccessToken(code);	
		// 사용자 정보 조회하기
		JsonNode userInfo = this.getKakaoUserInfo(code, accessToken);	////////////////////////////////////////////////////////////////////          2
//		System.out.println("json node userInfo : " + userInfo);
		
//		System.out.println("[카카오 사용자 인증] 이메일: " + userInfo.get("kakao_account").get("email").textValue());		/////////////////     7	
	
		
		redirectAttributes.addAttribute("email", userInfo.get("kakao_account").get("email").textValue());
	
//		System.out.println("[카카오 사용자 인증] 회원가입 페이지 재요청 응답 보내기");
		
		//아이디를 조회해서 일치하는 유저 정보가 있는지 찾고, 로그인하게 하기
		//만약에 DB에 메일이 있으면, 로그인 기능 완료
		User user = userService.getUserDetail(userInfo.get("kakao_account").get("email").textValue());
		if(user != null) {
			model.addAttribute("LOGIN_USER", user);
			model.addAttribute("LOGIN_TYPE", "sns");
			
			return "redirect:/home.do";
		}
		// 없으면, 리다이렉트로 회원가입 페이지 이동
		
		
		
		return "redirect:/sns/signup.do";																			/////////////     8
	}
	@PostMapping("/sns/kakao.do")
	@ResponseBody
	public Map<String, Object> getKakaoSignIn() {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("kakaoRestKey", kakaoRestKey);
		map.put("serverUrl", serverUrl);
		
		return map;
	}
	
	
	// 사용자정보를 조회하기 위한 엑세스 토큰 획득하기
	private String getAccessToken(String code) throws Exception {							////////////////////////////////////// 					5
//		System.out.println("[엑세스 토큰 획득] 시작"); 
		// 엑세스 토큰을 조회하기 위한 URL
		String url = "https://kauth.kakao.com/oauth/token";
//		System.out.println("[엑세스 토큰 획득] URL: " + url);
		// 요청파라미터 정보를 담을 수 있는 객체 생성하기
		List<NameValuePair> postParams = new ArrayList<NameValuePair>();
		// 요청파라미터 값을 담기
		postParams.add(new BasicNameValuePair("grant_type", "authorization_code"));
		postParams.add(new BasicNameValuePair("client_id", kakaoRestKey));
		postParams.add(new BasicNameValuePair("redirect_uri", serverUrl+"/sns/kakao.do"));
		postParams.add(new BasicNameValuePair("code", code));
		postParams.add(new BasicNameValuePair("client_secret", kakaoClientSecret));
		
		// 엑세스토큰을 조회하기 위한 HttpClient객체 생성하기
		HttpClient client = HttpClientBuilder.create().build();
		// 지정된 URL에 대해 POST방식 요청을 담당하는 객체 생성하기
		HttpPost post = new HttpPost(url);
		// 위에서 정의한 요청파라미터 정보를 post객체에 저장하기
		post.setEntity(new UrlEncodedFormEntity(postParams));
		
//		System.out.println("[엑세스 토큰 획득] 요청파라미터: " +post.toString());
		
//		System.out.println("[엑세스 토큰 획득] 카카오측에 요청");
		// 다음으로 요청을 보내고 응답컨텐츠 받아오기
		HttpResponse response = client.execute(post);
		
		// 응답코드가 200인 경우 엑세스 토큰 조회하기
		int responseCode = response.getStatusLine().getStatusCode();
//		System.out.println("[엑세스 토큰 획득] 응답코드: " + responseCode);
		if (responseCode == 200) {
			// 응답컨텐츠(JSON 형식의 데이타)를 읽어서 JsonNode로 변환하는 객체다.
			ObjectMapper mapper = new ObjectMapper();
			// 응답컨텐츠를 JsonNode로 변환하기
			JsonNode result = mapper.readTree(response.getEntity().getContent());
//			System.out.println();
			String accessToken = result.get("access_token").toString();
//			System.out.println("[엑세스 토큰 획득] AccessTokent: " + accessToken);
//			System.out.println("[엑세스 토큰 획득] 종료");
			// JsonNode객체에서 엑세스 토큰을 꺼내서 반환하기
			return accessToken;	
		} else {
			throw new RuntimeException("[엑세스 토큰 획득] 실패");
		}
		
		
	}
	
	// 사용자 정보 조회하기
	private JsonNode getKakaoUserInfo(String code, String accessToken)  throws Exception {	//////////////////////////////////////////////							3
		// 사용자 정보를 조회하기 위한 엑세스 토큰 획득하기
						////////////////////////////////////////////////////					4
		
//		System.out.println("[사용자 프로필 조회] 시작");						///////////////////////////////////////////////////   					6
		// 사용자 정보를 요청하는 URL
		String url = "https://kapi.kakao.com/v2/user/me";
//		System.out.println("[사용자 프로필 조회] URL: " + url);
		
		// 사용자 정보를 요청하기 위한 HttpClient객체 생성하기
		HttpClient client = HttpClientBuilder.create().build();
		// 지정된 URL에 대한 Post방식의 요청을 생성하기
		HttpPost post = new HttpPost(url);
		// 요청 헤더에 엑세스 토큰 정보 추가하기
		post.addHeader("Authorization", "Bearer " + accessToken);
		
//		System.out.println("[사용자 프로필 조회] 카카오측에 요청");
		// POST 요청을 보내고, 응답을 받아오기
		HttpResponse response = client.execute(post);
		// 응답코드 조회하기
		int responseCode = response.getStatusLine().getStatusCode();
//		System.out.println("[사용자 프로필 조회] 응답코드: " + responseCode);
		// 응답코드가 200인 경우 응답 컨텐츠 받기
		if (responseCode == 200) {
			ObjectMapper mapper = new ObjectMapper();
			JsonNode result = mapper.readTree(response.getEntity().getContent());
//			System.out.println("[사용자 프로필 조회] 사용자프로필: " + result);
//			System.out.println("[사용자 프로필 조회] 종료");
			return result;
		} else {
			throw new RuntimeException("[사용자 프로필 조회] 실패");
		}
		
	}
	
	@GetMapping("/sns/logout.do")
	public String logout( SessionStatus sessionStatus) throws Exception {
		
//		System.out.println("[카카오톡] 로그아웃 완료");
		sessionStatus.setComplete();
		return "redirect:/home.do";
	}
	
}
