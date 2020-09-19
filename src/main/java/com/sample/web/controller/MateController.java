package com.sample.web.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sample.dto.HallSeatDto;
import com.sample.dto.JsonHallSeat;
import com.sample.dto.MateDetailDto;
import com.sample.dto.MateUserDto;
import com.sample.dto.PerformanceDetailDto;
import com.sample.dto.PerformanceDto;
import com.sample.service.HallService;
import com.sample.service.MateManagerService;
import com.sample.service.MateService;
import com.sample.service.PerformanceService;
import com.sample.service.ReserveService;
import com.sample.service.UserService;
import com.sample.web.form.MateSearchForm;
import com.sample.web.security.Auth;
import com.sample.web.view.Mate;
import com.sample.web.view.MateTag;
import com.sample.web.view.MateTimeLine;
import com.sample.web.view.Pagination;
import com.sample.web.view.Reserve;
import com.sample.web.view.User;

@Controller
@RequestMapping("/mate")
public class MateController {

	@Autowired
	private MateService mateService;
	@Autowired
	private PerformanceService performanceService;
	@Autowired
	private ReserveService reserveService;
	@Autowired
	private MateManagerService mateManagerService;
	@Autowired
	private HallService hallService;
	@Autowired
	private UserService userService;
	
	@org.springframework.web.bind.annotation.ExceptionHandler(RuntimeException.class)
	public String runtimeExceptionHandler(RuntimeException e) {
		e.printStackTrace();
		return "error/server-error";
	}
	@org.springframework.web.bind.annotation.ExceptionHandler(Exception.class)
	public String ExceptionHandler(Exception e) {
		e.printStackTrace();
		return "error/server-error";
	}	
	
	/**
	 * matelist 페이지에서 '참가'버튼을 클릭하면 해당 방으로 입장가능하다.
	 * 
	 * @param performanceId 필수값. performance_main 테이블의 id 값
	 * @param mateId 필수값. mate_main 테이블의 id 값
	 * @param model 해당방의 user의 정보, mate_category 테이블의 정보
	 * 		  	접근하고자하는 url 의 get 정보 (performanceId, mateId)값을 
	 * 			model로 보낸다.
	 * @return mate/matedetail.jsp 페이지이동
	 */
	@GetMapping("/matedetail.do")
	public String matedetail(@RequestParam("pid") int performanceId, 
			@RequestParam("mnum") int mateId, Model model, HttpSession session) {
		
		List<Map<Integer, String>> categories = mateService.getMateAllCategory();
		List<User> users = mateService.getMateUserByMateId(mateId);
		
		model.addAttribute("mate", users);
		model.addAttribute("pid", performanceId);
		model.addAttribute("mnum", mateId);
		model.addAttribute("categories", categories);
		
		return "mate/matedetail";
	}
	/**
	 * 검색하여 이후 로딩되었을 때
	 * @param performanceId
	 * @param mateSearchForm
	 * @param session
	 * @param model
	 * @return
	 */
	@PostMapping("/mate.do")
	public String mateSearch(@RequestParam("pid") int performanceId,
			@ModelAttribute("mateSearchForm") MateSearchForm mateSearchForm,
			HttpSession session, Model model) {

		/*
		 * 해 당 아이디가 접근 권한이 있는지 체크하기
		 * 유저가 특정 공연을 결제를 완료했으면 접근가능
		 */
		User user = (User) session.getAttribute("LOGIN_USER");

		if(reserveService.getReserveByUserIdAndPerformanceId(user.getId(), performanceId) == null) {
			return "redirect:/home.do";
		}
		PerformanceDetailDto performance = performanceService.getPerformanceByPerformanceMainId(performanceId);
		if(performance == null) {
			return "redirect:/home.do";
		}
		List<Reserve> reserve = reserveService.getReserveByUserIdAndPerformanceId(user.getId(), performanceId);
		if(reserve.isEmpty()) {
			return "redirect:/home.do";
		}
		
		Map<String, Object> searchMap = mateService.getMatesByPerformanceIdSearch(performanceId, user.getId(), mateSearchForm);
		int totalRows = (int) searchMap.get("searchCount");
		
		Pagination pagination = new Pagination(10, 5, mateSearchForm.getPageNo(), totalRows);

		List<Mate> mateInfo = mateService.getMatesByPerformanceId(performanceId, user.getId());
		List<Mate> mateList = (List<Mate>) searchMap.get("searchList");
		List<Map<Integer, String>> mateCat = mateService.getMateAllCategory();
		Integer mateCount = mateService.getCountMateByPerformanceId(performanceId, user.getId());
		MateUserDto mateUser = mateService.getUserExistMate(performanceId, user.getId());
		if(mateUser == null) {
			return "redirect:/home.do";
		}

		
		Mate mate = mateService.getMate(performanceId, user.getId());
			
		model.addAttribute("mate", mate);
		model.addAttribute("MateProgressCount", mateService.getStatusByPerformanceId(performanceId, user.getId(), "모집중"));
		model.addAttribute("MateCompleteCount", mateService.getStatusByPerformanceId(performanceId, user.getId(),"모집완료"));
		model.addAttribute("MateEmptyCount", mateService.getStatusByPerformanceId(performanceId, user.getId(),"빈방"));
		
		model.addAttribute("pagination", pagination);
		model.addAttribute("mateList", mateList);
		model.addAttribute("mateInfo", mateInfo);
		model.addAttribute("category", mateCat);
		model.addAttribute("mateCount", mateCount);
		model.addAttribute("mateUser", mateUser);
		model.addAttribute("mateSearchForm", mateSearchForm);

		return "mate/matelist";
	}
	/**
	 * 맨 처음 로딩되었을때
	 * @param performanceId
	 * @param mateSearchForm
	 * @param session
	 * @param model
	 * @return
	 */
	@GetMapping("/mate.do")
	public String mate(@RequestParam("pid") int performanceId,
					HttpSession session, Model model) {
		
		//Search 폼
		/*
		 * 해 당 아이디가 접근 권한이 있는지 체크하기
		 * 유저가 특정 공연을 결제를 완료했으면 접근가능
		 */
		User user = (User) session.getAttribute("LOGIN_USER");
		
		if(reserveService.getReserveByUserIdAndPerformanceId(user.getId(), performanceId) == null) {
			return "redirect:/home.do";
		}
		PerformanceDetailDto performance = performanceService.getPerformanceByPerformanceMainId(performanceId);
		if(performance == null) {
			return "redirect:/home.do";
		}
		
		List<Reserve> reserve = reserveService.getReserveByUserIdAndPerformanceId(user.getId(), performanceId);
		if(reserve.isEmpty()) {
			return "redirect:/home.do";
		}
		
		MateSearchForm mateSearchForm = new MateSearchForm();
		mateSearchForm.setPageNo(1);
		mateSearchForm.setIsEmpty("Y");
		mateSearchForm.setIsFull("Y");

		
		Map<String, Object> searchMap = mateService.getMatesByPerformanceIdSearch(performanceId, user.getId(), mateSearchForm);
		int totalRows = (int) searchMap.get("searchCount");
		
		Pagination pagination = new Pagination(10, 5, mateSearchForm.getPageNo(), totalRows);
		List<Mate> mateInfo = mateService.getMatesByPerformanceId(performanceId, user.getId());
		List<Mate> mateList = (List<Mate>) searchMap.get("searchList");
		List<Map<Integer, String>> mateCat = mateService.getMateAllCategory();
		Integer mateCount = mateService.getCountMateByPerformanceId(performanceId, user.getId());
		
		MateUserDto mateUser = mateService.getUserExistMate(performanceId, user.getId());

		if(mateUser == null) {
			return "redirect:/home.do";
		}
		
		Mate mate = mateService.getMate(performanceId, user.getId());
		
		model.addAttribute("mate", mate);
		
		model.addAttribute("MateProgressCount", mateService.getStatusByPerformanceId(performanceId, user.getId(), "모집중"));
		model.addAttribute("MateCompleteCount", mateService.getStatusByPerformanceId(performanceId, user.getId(),"모집완료"));
		model.addAttribute("MateEmptyCount", mateService.getStatusByPerformanceId(performanceId, user.getId(),"빈방"));
		
		
		model.addAttribute("pagination", pagination);
		model.addAttribute("mateInfo", mateInfo);
		model.addAttribute("mateList", mateList);
		model.addAttribute("category", mateCat);
		model.addAttribute("mateCount", mateCount);
		model.addAttribute("mateUser", mateUser);
		model.addAttribute("mateSearchForm", mateSearchForm);
		
		return "mate/matelist";
	}
	/**
	 * 해당 방의 정보를 ajax 데이터와 연결하여 불러온다.
	 * @param performanceId 
	 * @param mateId
	 * @return
	 */
	@Auth
	@PostMapping("/matedetail.do")
	@ResponseBody
	public MateDetailDto mateRoom(@RequestParam("pid") int performanceId, 
							@RequestParam("mnum") int mateId, HttpSession session) {
		
		
		//전부 ajax로 가져온다.
		
		//메이트 조건 -> 메이트 아이디, 공연 아이디
		//해당 메이트 방의 공연 정보, 유저정보, 메이트 정보, 타임라인 정보를 가져온다.
		//제약조건 : 메이트 방에 해당하는 유저가 있는지 검사한다.
		//제약조건 : 세션값이 있는지 해당하고, 글을 올리는 유저를 검사한다.
		MateDetailDto detail = mateService.getMateRoomDetail(mateId, performanceId);
		//로그인한 유저정보를 가져온다.
		User user = (User) session.getAttribute("LOGIN_USER");
		String userNickName = null;
		if(user != null) {
			userNickName = user.getNickname();
			detail.setSessionUserId(userNickName);
		}
		
		return detail;
	}
	/**
	 * 해당 메이트 방의 timeline 입력시에 정보를 가져와서 insert 한다.
	 * @param mateId ajax에서 mateId를 받아온다.
	 * @param content ajax에서 content를 받아온다.
	 * @param session 세션에서 userId를 받아온다.
	 */
	@Auth
	@RequestMapping("/timeline.do")
	@ResponseBody
	public void addTimeLine(@RequestParam("mnum") int mateId, 
							@RequestParam("content") String content,
							@RequestParam("performanceId") int performanceId,
									HttpSession session) {
		User user = (User) session.getAttribute("LOGIN_USER");
		if(user == null) {
			throw new RuntimeException("접근 권한이 없습니다.");
		}
		MateTimeLine mateTimeLine = new MateTimeLine();
		mateTimeLine.setPerformanceId(performanceId);
		mateTimeLine.setUser(user);
		mateTimeLine.setId(mateId);
		mateTimeLine.setContent(content);
		mateService.addMateTimeLineByMateIdAndUserId(mateTimeLine);
	}
	/**
	 * 해당 메이트방을 실시간으로 감시해서 새로운 채팅 내역이 있으면 갱신한다.
	 * @param performanceId
	 * @param mateId
	 * @return
	 */
	@Auth
	@RequestMapping("/timelineInterval.do")
	@ResponseBody
	public Map<String, Object> mateTimeLineCount(@RequestParam("pid") int performanceId, 
			@RequestParam("mnum") int mateId, HttpSession session) {
		Map<String, Object> map = new HashMap<>();
		map.put("service", mateService.getMateTimeLineCountByMateId(mateId));
		
		User user = (User) session.getAttribute("LOGIN_USER");
		if(user != null) {
			map.put("sessionId", user.getId());
		}
		
		return map;
	}
	@Auth
	@RequestMapping("/addTag.do")
	@ResponseBody
	public List<MateTag> addmateTag(@RequestParam("mnum") int mateId, 
							@RequestParam("tags") List<String> tags,
							@RequestParam("performanceId") int performanceId
							, HttpSession session) {
		
		return mateService.addHashTag(mateId, tags, performanceId);
	}
	@Auth
	@RequestMapping("/updateCat.do")
	@ResponseBody
	public int updateMateCategory(@RequestParam("mnum") int mateId,
			@RequestParam("mcat") int categoryId) {
		mateService.updateMateCategoryByMateId(categoryId, mateId);
		
		return categoryId;
	}
	
	//해당 공연을 예약한 유저가 해당 메이트방 참가 신청을하면 더하는 것
	@Auth
	@RequestMapping("/addMateMember.do")
	public String addMate(@RequestParam("pid") int performanceId,
					@RequestParam("mnum") int mateId, HttpSession session, Model model) {
		
		User user = (User) session.getAttribute("LOGIN_USER");
		//유저 입장
		mateService.addMateMember(mateId, user, performanceId);

		List<Reserve> reserve = reserveService.getReserveByUserIdAndPerformanceId(user.getId(), performanceId);
		if(reserve.isEmpty()) {
			return "redirect:/home.do";
		}
		
		model.addAttribute("mnum",mateId);
		model.addAttribute("pid", performanceId);
		
		return "redirect:matedetail.do";
	}
	//ajax 통신, 참가버튼을 누르면 ajax와 사전에 통신하여 유효값 검증을 한다.
	@Auth
	@RequestMapping("/beforeAddMate.do")
	public @ResponseBody  Map<String, Object> beforeAddMate(@RequestParam("pid") int performanceId,
			@RequestParam("mnum") int mateId, HttpSession session) {
		User user = (User) session.getAttribute("LOGIN_USER");
		//세션확인
		return mateService.beforAddMateIsPassMate(performanceId, mateId, user.getId());
	}	
	
	//좌석 미리보기
	@RequestMapping("/seatPreview.do")
	@ResponseBody
	public Map<String, Object> previewSeat(@RequestParam("performanceId") int performanceId,
											@RequestParam("mateId") int mateId) {
		Map<String, Object> map = new HashMap<>();
		List<JsonHallSeat> seats = mateManagerService.getHallSeats(performanceId);
		List<HallSeatDto> mateSeats = hallService.getSeatsByMateId(mateId);
		
		map.put("seats", seats);
		map.put("mateSeats", mateSeats);
		return map;
	}
	
	@RequestMapping("/mateOut.do")
	@ResponseBody
	public void mateOut(@RequestParam("performanceMainId") int performanceId,
							@RequestParam("mateId") int mateId,
								@RequestParam("userId") String userId) {
	
		//해당 유저가 mate_memebers 인지 검사한다.
		boolean existUser = mateService.getMateUserByMateIdAndUserId(userId, mateId);
		if(!existUser) {
			new RuntimeException("허용되지 않은 유저 입니다.");
		}

		User savedUser = userService.getUserDetail(userId);
		if(savedUser == null) {
			new RuntimeException("존재하지 않은 유저입니다.");
		}
		mateService.deleteMate(performanceId, mateId, userId);
	}
	
}
