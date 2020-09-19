package com.sample.web.controller;


import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.text.StringEscapeUtils;
import org.apache.http.HttpRequest;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;

import com.sample.dao.PerformanceDao;
import com.sample.dto.PerformanceAgeReserveStats;
import com.sample.dto.PerformanceDetailDto;
import com.sample.dto.PerformanceGenderReserveStats;
import com.sample.service.HallService;
import com.sample.service.MateService;
import com.sample.service.PerformanceService;
import com.sample.web.form.PerformanceForm;
import com.sample.web.form.PerformanceUpdateForm;
import com.sample.web.view.HallInfo;
import com.sample.web.view.Pagination;
import com.sample.web.view.Performance;
import com.sample.web.view.PerformanceMain;
import com.sample.web.view.PerformanceSeatPrice;
import com.sample.web.view.UserLikes;




@Controller
@RequestMapping("/performance")
@SessionAttributes("performanceForm")
public class PerformanceContoller {

	@Autowired
	private PerformanceService performanceService;
	
	@Autowired
	private HallService hallService;
	
	@GetMapping("/update/main.do")
	public String updateMain(@RequestParam("performanceId") int performanceId, 
			@RequestParam("category") String category, Model model) {		
		
		return "/performance/update/main";
	}
	
	@GetMapping("/update/cancel.do")
	public String cancelUpdate(SessionStatus sessionStatus, @RequestParam("category") String category,
			Model model) {
		sessionStatus.setComplete();
			
		model.addAttribute("category", category);		
		return "redirect:/performance/adminList.do";	// 나중엔 performance/list.do?category='category'로 변경
		
	}
	
	
	@GetMapping("/update/updateBasicInfo.do")
	public String updateBasic(@RequestParam("performanceId") int performanceId, 
			@RequestParam("category") String category, Model model) {
		
		String genreCat = "";
		if (category.equals("콘서트")) {
			genreCat = "콘서트";
		} else if(category.equals("뮤지컬") || category.equals("연극")) {
			genreCat = "뮤지컬/연극";
		}			
		
		String[] genres = performanceService.getGenreByCategory(genreCat);		
		
		PerformanceDetailDto performance = performanceService.getPerformanceDetailById(performanceId);
				
		// 메이트가 등록된 공연정보인지 확인
		List<PerformanceMain> performanceMain = performanceService.getPerformanceMain(performanceId);
				
		if (performanceMain.size() != 0) {
			// 메이트가 등록된 공연정보라면 수정할 수 없음
			model.addAttribute("dateDisable", "disable");
		}else {			
			model.addAttribute("dateDisable", "able");
		}
				
		model.addAttribute("category",category);
		model.addAttribute("genres", genres);
		model.addAttribute("performanceId",performanceId);
		model.addAttribute("performance", performance);	
		
		return "/performance/update/updateBasicInfo";
	}
	
	@PostMapping("/update/updateBasicInfo.do")
	public String updateBasicSubmit(PerformanceUpdateForm performanceUpdateForm,
			HttpServletRequest request ,Model model) throws Exception{
		
		String imageSaveDirectory = request.getSession().getServletContext().getRealPath("/")+"resources/sample-images/";
		
		// 장르 설정하기
		List<String> genres = new ArrayList<String>();
		for (String genre : performanceUpdateForm.getGenre()) {
			genres.add(genre);
		}			
		
		Performance performance = new Performance();
		
		BeanUtils.copyProperties(performanceUpdateForm, performance);
		performance.setGenre(genres);
		
		
		if ("existing".equals(performanceUpdateForm.getImageSelect())) {
			System.out.println("기존의 이미지");
								
			// 기존의 이미지경로 가져오기 
			PerformanceDetailDto performanceDetailDto = performanceService.getPerformanceDetailById(performance.getId());
			performance.setImagePath(performanceDetailDto.getImagePath());
			// performanceInfo 테이블 
			
			
		} else if ("new".equals(performanceUpdateForm.getImageSelect())) {
			System.out.println("새 이미지");
			// 새 이미지 저장하기 
			MultipartFile upFile = performanceUpdateForm.getUpfile();
			if (!upFile.isEmpty()) {
				
				// 수정한 것
				String filename = upFile.getOriginalFilename();
				filename = System.currentTimeMillis()+filename;	
				File file = new File(imageSaveDirectory, filename);
				FileCopyUtils.copy(upFile.getInputStream(), new FileOutputStream(file));	
				performance.setImagePath(filename);
			}
			
		}
		
		// 1. 기존의 장르테이블을 지우고 새로 입력한다.
		// 2. 공연정보 테이블에 새로운 정보들을 저장한다.
		performanceService.updatePerformanceInfo(performance);		
		
		
		model.addAttribute("category", performanceUpdateForm.getCategory());
		model.addAttribute("performanceId",performanceUpdateForm.getId());
		
		return "redirect:completed.do";
	}
	
	@GetMapping("/update/completed.do")
	public String updateCompleted(@RequestParam("performanceId") int performanceId, 
			@RequestParam("category") String category, Model model) {
		
		model.addAttribute("category", category);
		model.addAttribute("performanceId", performanceId);
		
		return "/performance/update/completed";
	}
	
	@GetMapping("/update/updateLocationInfo.do")
	public String updateLocation(@RequestParam("performanceId") int performanceId, 
			@RequestParam("category") String category, Model model) {
		
		PerformanceDetailDto performance = performanceService.getPerformanceDetailById(performanceId);
		
		List<HallInfo> hallInfos = performanceService.getAllHallInfos();
		HallInfo hallInfo = performanceService.getHallInfoByPerformanceInfoId(performanceId);
		
		
		model.addAttribute("hallInfos", hallInfos);
		
		
		model.addAttribute("category",category);		
		model.addAttribute("performanceId",performanceId);
		model.addAttribute("performance", performance);	
		model.addAttribute("hallInfo", hallInfo);
				
		return "/performance/update/updateLocationInfo";
	}
	
	@PostMapping("/update/updateLocationInfo.do")
	public String updateLocationSubmit(PerformanceUpdateForm performanceUpdateForm,
			Model model) {
		
		
		Performance performance = new Performance();		
		BeanUtils.copyProperties(performanceUpdateForm, performance);
			
		HallInfo hallInfo = performanceService.getHallInfoById(performanceUpdateForm.getOriginalHallId());
		performance.setHallInfo(hallInfo);
		if ("new".equals(performanceUpdateForm.getHallInputType())) {			
			if((performanceUpdateForm.getHallName().equals(hallInfo.getName()))
				&& (performanceUpdateForm.getHallAddress().equals(hallInfo.getAddress()))) {
				// 직접입력이고 기존 정보와 차이가 없을때 (수정을 하지 않음)
				// 아무일도 하지 않는다.
				
			} else {
				// 직접입력이고 새로 데이터를 입력할 때
				// 1. 새로운 공연장 정보를 데이터베이스에 저장한다.
				// 2. 공연정보와 연결된 공연장 정보를 바꿔준다.
				HallInfo newHallInfo = new HallInfo();
				newHallInfo.setName(performanceUpdateForm.getHallName());
				newHallInfo.setAddress(performanceUpdateForm.getHallAddress());
				newHallInfo.setGpsX(performanceUpdateForm.getGpsX());
				newHallInfo.setGpsY(performanceUpdateForm.getGpsY());
				String insertHallInfo = "Y";	// 새로 입력한 공연정보이다.
				
				performanceService.updatePerformanceHallInfo(performance, newHallInfo, insertHallInfo);
			}
					
			
		} else if ("existing".equals(performanceUpdateForm.getHallInputType())) {
			if (performanceUpdateForm.getHallId() == performanceUpdateForm.getOriginalHallId()) {
				// 기존 공연장 입력이고 기존 정보와 차이가 없을때(수정을 하지 않음)
				// 아무일도 하지 않는다.
				//System.out.println("기존정보와 동일함");
			}else  {
				// 공연정보와 연결된 공연장정보를 바꿔준다.
				// 기존의 공연장정보를 가져온후 그 공연장정보로 공연정보의 공연장정보를 바꿔준다.
				//System.out.println("새로운 공연정보 아이디: "+ performanceUpdateForm.getHallId());
				HallInfo newHallInfo = performanceService.getHallInfoById(performanceUpdateForm.getHallId());
				String insertHallInfo = "N";	// 기존의 공연정보이다. 
				
				performanceService.updatePerformanceHallInfo(performance, newHallInfo, insertHallInfo);
			}
		}
		
		
		model.addAttribute("category", performanceUpdateForm.getCategory());
		model.addAttribute("performanceId",performanceUpdateForm.getId());
		
		return "redirect:completed.do";
	}
	
	
	
	@GetMapping("/update/updateSeatInfo.do")
	public String updateSeat(@RequestParam("performanceId") int performanceId, 
			@RequestParam("category") String category, Model model) {
		
				
		PerformanceDetailDto performance = performanceService.getPerformanceDetailById(performanceId);
		
		PerformanceSeatPrice aSeat = new PerformanceSeatPrice();
		aSeat.setInfoId(performanceId);
		aSeat.setSeatRate("A");
		
		PerformanceSeatPrice sSeat = new PerformanceSeatPrice();
		sSeat.setInfoId(performanceId);
		sSeat.setSeatRate("S");
		
		PerformanceSeatPrice rSeat = new PerformanceSeatPrice();
		rSeat.setInfoId(performanceId);
		rSeat.setSeatRate("R");
		
		PerformanceSeatPrice aSeatInfo = performanceService.getPerformanceSeatPriceByPerformanceInfoAndSeatRate(aSeat);
		PerformanceSeatPrice sSeatInfo = performanceService.getPerformanceSeatPriceByPerformanceInfoAndSeatRate(sSeat);
		PerformanceSeatPrice rSeatInfo = performanceService.getPerformanceSeatPriceByPerformanceInfoAndSeatRate(rSeat);
		
		model.addAttribute("category",category);		
		model.addAttribute("performanceId",performanceId);
		model.addAttribute("performance", performance);	
		model.addAttribute("aSeat", aSeatInfo);
		model.addAttribute("sSeat", sSeatInfo);
		model.addAttribute("rSeat", rSeatInfo);
		
		
		return "/performance/update/updateSeatInfo";
	}
	
	@PostMapping("/update/updateSeatInfo.do")
	public String updateSeatSubmit(PerformanceUpdateForm performanceUpdateForm,
			Model model) {
		
		Performance performance = new Performance();		
		BeanUtils.copyProperties(performanceUpdateForm, performance);
		
		
		// 새 좌석정보를 Map에 저장한다.
		Map<String, Integer> map = new HashMap<>();
		map.put("A", performanceUpdateForm.getaPrice());
		map.put("S", performanceUpdateForm.getsPrice());
		map.put("R", performanceUpdateForm.getrPrice());
		
		performanceService.updatePerformanceSeatInfo(performance, map);
		
		
		model.addAttribute("category", performanceUpdateForm.getCategory());
		model.addAttribute("performanceId",performanceUpdateForm.getId());
		
		return "redirect:completed.do";
		
	}
	
	
	
	@GetMapping("delete.do")
	public String delete(@RequestParam("performanceId") int performanceId,
			@RequestParam("category") String category, Model model) {
		
		
		PerformanceDetailDto performance =  performanceService.getPerformanceDetailById(performanceId);
		
		if (performance == null) {
			model.addAttribute("error", "notFound");
		} else {
			// 공연메인정보 조회
			List<PerformanceMain> performanceMain = performanceService.getPerformanceMain(performanceId);
			// 공연장르 조회
			String[] performanceGenres = performanceService.getGenreById(performanceId);
			// 공연 좌석가격정보 조회
			List<PerformanceSeatPrice> seatPrices = performanceService.getPerformanceSeatPriceById(performanceId);
			
			// 이미 해당공연에 예약을 한 사람이 있는 경우 삭제를 진행할 수 없다.
			// performance_main 테이블에 performanceInfoId에 해당하는 행이 있는 경우이다.
			if (performanceMain.size() != 0) {
				model.addAttribute("error", "disable");
			} else {
				// 공연정보를 삭제한다.
				performanceService.deletePerformance(performanceId);				
			}
			
		}		
		
		model.addAttribute("category", category);	
		
		return "/performance/delete";
	}
	
	
	@GetMapping("/add/step1.do")
	public String addStep1(Model model, @RequestParam(value="category", defaultValue="") String category) {
		
		String genreCat = "";
		if (category.equals("콘서트")) {
			genreCat = "콘서트";
		} else if(category.equals("뮤지컬") || category.equals("연극")) {
			genreCat = "뮤지컬/연극";
		}			
		
		String[] genres = performanceService.getGenreByCategory(genreCat);			
		
		model.addAttribute("category",category);
		model.addAttribute("genres", genres);
		
		PerformanceForm performanceForm = new PerformanceForm();
		model.addAttribute("performanceForm", performanceForm);
		
		return "/performance/add/step1";
	}
	
	
	@PostMapping("/add/step1.do")
	public String addStep1Submit(@ModelAttribute("performanceForm") PerformanceForm performanceForm,HttpServletRequest request ) throws Exception {
		
		String imageSaveDirectory = request.getSession().getServletContext().getRealPath("/")+"resources/sample-images/";
		
		MultipartFile upFile = performanceForm.getUpfile();
		if (!upFile.isEmpty()) {
			String filename = upFile.getOriginalFilename();
			filename = System.currentTimeMillis()+filename;	
			File file = new File(imageSaveDirectory, filename);
			FileCopyUtils.copy(upFile.getInputStream(), new FileOutputStream(file));	
			performanceForm.setImagePath(filename);
		} 
		
		return "redirect:step2.do";
	}
	
	@GetMapping("/add/step2.do") 
	public String addStep2(Model model, @ModelAttribute("performanceForm") PerformanceForm performanceForm) {
		
		List<HallInfo> hallInfos = performanceService.getAllHallInfos();
		
		model.addAttribute("hallInfos", hallInfos);
		return "/performance/add/step2";
		
	}
	
	@PostMapping("/add/step2.do")
	public String addStep2Submit(@ModelAttribute("performanceForm") PerformanceForm performanceForm ) {
		
		return "redirect:step3.do";
	}
	
	@GetMapping("/add/step3.do")
	public String addStep3(Model model, @ModelAttribute("performanceForm") PerformanceForm performanceForm) {
					
		return "/performance/add/step3";
	}
	
	@PostMapping("/add/step3.do")
	public String addStep3Submit(@ModelAttribute("performanceForm") PerformanceForm performanceForm,
			SessionStatus sessionStatus, Model model) throws Exception{
		
		
		//Performance에 performanceForm 정보 담기
		Performance performance = new Performance();
		performance.setCategory(performanceForm.getCategory());
		performance.setTitle(performanceForm.getTitle());
		performance.setStartDate(performanceForm.getStartDate());
		performance.setEndDate(performanceForm.getEndDate());
		performance.setRating(performanceForm.getRating());
		performance.setRunningTime(performanceForm.getRunningTime());
		performance.setProvider(performanceForm.getProvider());
		performance.setExplain(performanceForm.getExplain());
		performance.setImagePath(performanceForm.getImagePath());
		
		// 장르 넣기
		List<String> genres = new ArrayList<String>();
		for (String genre : performanceForm.getGenre()) {
			genres.add(genre);
		}		
		performance.setGenre(genres);
				
		// hallInfo 넣기 
		HallInfo hallInfo = new HallInfo();
		
		// 직접 입력의 경우
		// hallInfo.getId는 null이다.
		String insertHallYn = "";
		if("new".equals(performanceForm.getHallInputType())) {
			hallInfo.setName(performanceForm.getHallName());
			hallInfo.setAddress(performanceForm.getHallAddress());
			hallInfo.setGpsX(performanceForm.getGpsX());
			hallInfo.setGpsY(performanceForm.getGpsY());
			insertHallYn = "Y";
		} else if ("existing".equals(performanceForm.getHallInputType())) {	// 기존의 공연장을 선택한 경우			
			hallInfo = performanceService.getHallInfoById(performanceForm.getHallId());		
			insertHallYn = "N";
		}
		
		//PerformanceSeatPrice를 넣기 위한 Map
		Map<String, Integer> map = new HashMap<>();
		map.put("A", performanceForm.getaPrice());
		map.put("S", performanceForm.getsPrice());
		map.put("R", performanceForm.getrPrice());
		
		// 새 공연정보를 데이터베이스에 넣는다.
		performanceService.insertPerformance(performance, hallInfo, insertHallYn, map);
				
		// performanceForm 객체가 사라지기전에 category정보를 저장한다.
		model.addAttribute("category", performanceForm.getCategory());
		
		// @SessionAttribute({"이름", "이름})으로 모델의 저장된 객체 중에서 
		// 해당이름의 객체가 세션에 저장되게 되는데
		// sessionStatus.setComplete()메소드를 실행하면, 세션에 저장된 객체를
		// 삭제한다.
		
		sessionStatus.setComplete();
				
		return "redirect:completed.do";
		
	}
	
	@GetMapping("/add/completed.do")
	public String completed(Model model) {
		return "/performance/add/completed";
	}
	
	
	@GetMapping("/add/cancel.do")
	public String cancel(SessionStatus sessionStatus) {
		sessionStatus.setComplete();
		return "redirect:/admin/home.do";	// 나중엔 performance/list.do?category='category'로 변경
	}

	
	@GetMapping("/totalList.do")
	public String totalList(Model model
			, @RequestParam("title") String title
			, @RequestParam(value = "pageNo", defaultValue="1") int pageNo
			, @RequestParam(value = "rows", defaultValue = "5") int rows
			, @RequestParam(value= "order", defaultValue = "dateOrder") String listOrder) {
		
			Map<String, Object> pagingmap = new HashMap<String, Object>();
						
			pagingmap.put("title", title);
			pagingmap.put("pageNo", pageNo);
			pagingmap.put("rows", rows);	
			
			// 정렬 정리 
			if (!listOrder.isEmpty()) {
				pagingmap.put("listOrder", listOrder);
			} else {
				pagingmap.put("listOrder", "dateOrder");
			}
			
			
			// 페이징 처리된 map을 조회한다.(검색조건에 해당하고, 특정 페이지 범위내의 자료를 가져온다.
			Map<String, Object> resultMap = performanceService.getTotalSearchForPaging(pagingmap);
			
			//System.out.println("totalList를 컨트롤러에서 페이징처리한 결과");
			
			Pagination pagination = (Pagination) resultMap.get("pagination");
			
			List<PerformanceDetailDto> performancesWithPaging 
				= (List<PerformanceDetailDto>) resultMap.get("performances");
			
			int totalRows = (Integer)resultMap.get("totalRows");
			int totalPageCount = (int)Math.ceil(((double)totalRows/(double)rows));
						
			model.addAttribute("title", title);
			model.addAttribute("performances", performancesWithPaging);
			model.addAttribute("pagination", pagination);
			model.addAttribute("pageNo", pageNo);
			model.addAttribute("totalPageCount", totalPageCount);
			model.addAttribute("rows", rows);
		
		return "performance/totalList";
	}
	
	@GetMapping("/adminList.do")
	public String adminList(Model model
			, @RequestParam(value="category", defaultValue="콘서트") String category
			, @RequestParam(value = "pageNo", defaultValue="1") int pageNo
			, @RequestParam(value = "rows", defaultValue = "5") int rows
			, @RequestParam(value= "order", defaultValue = "dateOrder") String listOrder
			, @RequestParam(value = "title", defaultValue="") String title
			, @RequestParam(value = "genre", required=false) String[] searchGenres
			, @RequestParam(value = "startDay", defaultValue = "") String startDay 
			, @RequestParam(value = "endDay", defaultValue = "") String endDay
			, @RequestParam(value= "age", defaultValue="0") String age
			, @RequestParam(value="changed", defaultValue="N", required=false) String changed) {
		
		
		//만약 폼이 변경된 뒤에 페이지번호나 검색버튼을 눌렀을 시
		if ("Y".equals(changed)) {
			pageNo = 1;
		}
		
		// 조회하기 위한 맵 만들기 
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category", category);
		
		// 페이징처리용 map
		Map<String, Object> pagingmap = new HashMap<String, Object>();
		pagingmap.put("category", category);
		
		if (!title.isEmpty()) {
			map.put("title", title);
			pagingmap.put("title", title);
			
			//performanceForm.setTitle(title);
		}
		if (searchGenres != null && searchGenres.length > 0 && !"전체".equals(searchGenres[0])) {
			map.put("genres", searchGenres);
			pagingmap.put("genres", searchGenres);			
			//performanceForm.setGenres(searchGenres);
		}
		if (!startDay.isEmpty()) {
			map.put("startDate", startDay);			
			pagingmap.put("startDate", startDay);			
			//performanceForm.setStartDay(startDay);
		}
		if (!endDay.isEmpty()) {
			map.put("endDate", endDay);			
			pagingmap.put("endDate", endDay);			
			//performanceForm.setEndDay(endDay);
		}
		if (!"0".equals(age)) {
			map.put("age", age);
			pagingmap.put("age", age);
			//performanceForm.setAge(age);
		}
		// 정렬 정리 
		if (!listOrder.isEmpty()) {
			pagingmap.put("listOrder", listOrder);
		} else {
			pagingmap.put("listOrder", "dateOrder");
		}
				
		// 관리자용		
		String admin = "admin";
		pagingmap.put("admin", admin);
		
		pagingmap.put("pageNo", pageNo);
		pagingmap.put("rows", rows);		
		
		List<PerformanceDetailDto> performances = performanceService.searchPerformances(map);
		
		// 페이징 처리된 map을 조회한다.(검색조건에 해당하고, 특정 페이지 범위내의 자료를 가져온다.
		Map<String, Object> resultMap = performanceService.getPerformanceForPaging(pagingmap);
		
		//System.out.println("Controller에서 페이징처리된 결과 테스트");
		Pagination pagination = (Pagination) resultMap.get("pagination");
		
		List<PerformanceDetailDto> performancesWithPaging 
			= (List<PerformanceDetailDto>) resultMap.get("performances");
		
		int totalRows = (Integer)resultMap.get("totalRows");
		int totalPageCount = (int)Math.ceil(((double)totalRows/(double)rows));
	
		// 전체 누르면 전체 12개의 줄이 나오는 오류
		
		String genreCat = "";
		if (category.equals("콘서트")) {
			genreCat = "콘서트";
		} else if(category.equals("뮤지컬") || category.equals("연극")) {
			genreCat = "뮤지컬/연극";
		}			
		
		String[] genres = performanceService.getGenreByCategory(genreCat);	
		
		
				
		model.addAttribute("category", category);
		model.addAttribute("genres", genres );
		// 페이징 처리가 안된 것
		//model.addAttribute("performances", performances);
		// 페이징 처리가 된 것
		model.addAttribute("performances", performancesWithPaging);
		model.addAttribute("pagination", pagination);
		model.addAttribute("pageNo", pageNo);
		model.addAttribute("totalPageCount", totalPageCount);
		model.addAttribute("rows", rows);
		
						
		return "/performance/adminList";
		
		
	}
	
	
	
	@GetMapping("/list.do")
	public String list(Model model
			, @RequestParam("category") String category
			, @RequestParam(value = "pageNo", defaultValue="1") int pageNo
			, @RequestParam(value = "rows", defaultValue = "5") int rows
			, @RequestParam(value= "order", defaultValue = "dateOrder") String listOrder
			, @RequestParam(value = "title", defaultValue="") String title
			, @RequestParam(value = "genre", required=false) String[] searchGenres
			, @RequestParam(value = "startDay", defaultValue = "") String startDay 
			, @RequestParam(value = "endDay", defaultValue = "") String endDay
			, @RequestParam(value= "age", defaultValue="0") String age
			, @RequestParam(value="changed", defaultValue="N", required=false) String changed) {
		
		
		
		//만약 폼이 변경된 뒤에 페이지번호나 검색버튼을 눌렀을 시
		if ("Y".equals(changed)) {
			pageNo = 1;
		}
		
		// 조회하기 위한 맵 만들기 
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category", category);
		
		// 페이징처리용 map
		Map<String, Object> pagingmap = new HashMap<String, Object>();
		pagingmap.put("category", category);
		
		if (!title.isEmpty()) {
			map.put("title", title);
			pagingmap.put("title", title);
			
			//performanceForm.setTitle(title);
		}
		if (searchGenres != null && searchGenres.length > 0 && !"전체".equals(searchGenres[0])) {
			map.put("genres", searchGenres);
			pagingmap.put("genres", searchGenres);			
			//performanceForm.setGenres(searchGenres);
		}
		if (!startDay.isEmpty()) {
			map.put("startDate", startDay);			
			pagingmap.put("startDate", startDay);			
			//performanceForm.setStartDay(startDay);
		}
		if (!endDay.isEmpty()) {
			map.put("endDate", endDay);			
			pagingmap.put("endDate", endDay);			
			//performanceForm.setEndDay(endDay);
		}
		if (!"0".equals(age)) {
			map.put("age", age);
			pagingmap.put("age", age);
			//performanceForm.setAge(age);
		}
		
		// 정렬 정리 
		if (!listOrder.isEmpty()) {
			pagingmap.put("listOrder", listOrder);
		} else {
			pagingmap.put("listOrder", "dateOrder");
		}
						
		pagingmap.put("pageNo", pageNo);
		pagingmap.put("rows", rows);		
		
		List<PerformanceDetailDto> performances = performanceService.searchPerformances(map);
		
		// 페이징 처리된 map을 조회한다.(검색조건에 해당하고, 특정 페이지 범위내의 자료를 가져온다.
		Map<String, Object> resultMap = performanceService.getPerformanceForPaging(pagingmap);
		
		Pagination pagination = (Pagination) resultMap.get("pagination");
		
		List<PerformanceDetailDto> performancesWithPaging 
			= (List<PerformanceDetailDto>) resultMap.get("performances");
		
		int totalRows = (Integer)resultMap.get("totalRows");
		int totalPageCount = (int)Math.ceil(((double)totalRows/(double)rows));
	
		
		String genreCat = "";
		if (category.equals("콘서트")) {
			genreCat = "콘서트";
		} else if(category.equals("뮤지컬") || category.equals("연극")) {
			genreCat = "뮤지컬/연극";
		}			
		
		String[] genres = performanceService.getGenreByCategory(genreCat);	
		
		//슬라이드용 performanceList 가져오기
		List<PerformanceDetailDto> slidePerformances = performanceService.getPerformancesByCategory(category);
		List<PerformanceDetailDto> sliedPerformanceTop3 = new ArrayList<>();
		if(slidePerformances.size() > 2) {
			for(int i = 0; i < 3; i++) {
				sliedPerformanceTop3.add(slidePerformances.get(i));
			}
		} else {
			sliedPerformanceTop3.addAll(slidePerformances);
		}
		
		
		model.addAttribute("slidePerformances", sliedPerformanceTop3);
		model.addAttribute("category", category);
		model.addAttribute("genres", genres );
		// 페이징 처리가 된 것
		model.addAttribute("performances", performancesWithPaging);
		model.addAttribute("pagination", pagination);
		model.addAttribute("pageNo", pageNo);
		model.addAttribute("totalPageCount", totalPageCount);
		model.addAttribute("rows", rows);
		
		
				
		return "/performance/list";
	}
	
	
	
	
	@GetMapping("/detail.do")
	public @ResponseBody Map<String, Object> getProduct(@RequestParam("id") int performanceId,
			@RequestParam("userId") String userId) {
		
		System.out.println("여긴 performance/detail.do 입니다.");
		
		PerformanceDetailDto performance = performanceService.getPerformanceDetailById(performanceId);
		HallInfo hallInfo = hallService.getHallInfoByPerformanceId(performanceId);
		UserLikes userLikes = new UserLikes();
		String userLiked = ""; // 좋아요를 이미 눌렀는지 여부
		PerformanceGenderReserveStats manReserveStats = new PerformanceGenderReserveStats();
		PerformanceGenderReserveStats womanReserveStats = new PerformanceGenderReserveStats();
		
		PerformanceAgeReserveStats age10ReserveStats = new PerformanceAgeReserveStats();
		PerformanceAgeReserveStats age20ReserveStats = new PerformanceAgeReserveStats();
		PerformanceAgeReserveStats age30ReserveStats = new PerformanceAgeReserveStats();
		PerformanceAgeReserveStats age40ReserveStats = new PerformanceAgeReserveStats();
		PerformanceAgeReserveStats age50ReserveStats = new PerformanceAgeReserveStats();
		
		// 남자 공연예매수
		manReserveStats.setPerformanceInfoId(performanceId);
		manReserveStats.setGender("M");
		manReserveStats.setReserveCount(performanceService.getGenderReserveCountByPerformanceInfoIdAndGender(manReserveStats));
		
		// 여자 공연예매수
		womanReserveStats.setPerformanceInfoId(performanceId);
		womanReserveStats.setGender("F");
		womanReserveStats.setReserveCount(performanceService.getGenderReserveCountByPerformanceInfoIdAndGender(womanReserveStats));
		
		// 10대이하 공연예매수
		age10ReserveStats.setPerformanceInfoId(performanceId);
		age10ReserveStats.setAgeGroup(10);
		age10ReserveStats.setReserveCount(performanceService.getAgeGroupReserveCountByPerformanceInfoIdAndAge(age10ReserveStats));
		
		// 20대 공연예매수
		age20ReserveStats.setPerformanceInfoId(performanceId);
		age20ReserveStats.setAgeGroup(20);
		age20ReserveStats.setReserveCount(performanceService.getAgeGroupReserveCountByPerformanceInfoIdAndAge(age20ReserveStats));
		
		// 30대 공연예매수
		age30ReserveStats.setPerformanceInfoId(performanceId);
		age30ReserveStats.setAgeGroup(30);
		age30ReserveStats.setReserveCount(performanceService.getAgeGroupReserveCountByPerformanceInfoIdAndAge(age30ReserveStats));
		
		// 40대 공연예매수
		age40ReserveStats.setPerformanceInfoId(performanceId);
		age40ReserveStats.setAgeGroup(40);
		age40ReserveStats.setReserveCount(performanceService.getAgeGroupReserveCountByPerformanceInfoIdAndAge(age40ReserveStats));
		
		// 50대 이상 공연예매수
		age50ReserveStats.setPerformanceInfoId(performanceId);
		age50ReserveStats.setAgeGroup(50);
		age50ReserveStats.setReserveCount(performanceService.getAgeGroupReserveCountByPerformanceInfoIdAndAge(age50ReserveStats));
		
		System.out.println("남자 공연예매수: "+manReserveStats.getReserveCount());
		System.out.println("여자 공연예매수: "+womanReserveStats.getReserveCount());
		System.out.println("10대 공연예매수: "+age10ReserveStats.getReserveCount());
		System.out.println("20대 공연예매수: "+age20ReserveStats.getReserveCount());
		System.out.println("30대 공연예매수: "+age30ReserveStats.getReserveCount());
		System.out.println("40대 공연예매수: "+age40ReserveStats.getReserveCount());
		System.out.println("50대 공연예매수: "+age50ReserveStats.getReserveCount());
		
		if ("".equals(userId)) {
			System.out.println("로그인되지 않았습니다.");
			userLiked = "N";
		}else {
			System.out.println("loginUserId:" + userId);
			userLikes.setId(userId);
			userLikes.setPerformanceInfoId(performanceId);
			UserLikes resultUserLikes = performanceService.getUserLikesByUserIdAndPerformanceInfoId(userLikes);
			
			if (resultUserLikes != null) {
				userLiked ="Y";
			}else {
				userLiked = "N";
			}
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("performance", performance);
		map.put("hallInfo", hallInfo);
		map.put("userLiked", userLiked);
		map.put("manReserveCount", manReserveStats.getReserveCount());
		map.put("womanReserveCount", womanReserveStats.getReserveCount());
		map.put("age10ReserveStats", age10ReserveStats.getReserveCount());
		map.put("age20ReserveStats", age20ReserveStats.getReserveCount());
		map.put("age30ReserveStats", age30ReserveStats.getReserveCount());
		map.put("age40ReserveStats", age40ReserveStats.getReserveCount());
		map.put("age50ReserveStats", age50ReserveStats.getReserveCount());
		
		return map;
	}
	
	@GetMapping("/add/showHallInfo.do")
	public @ResponseBody HallInfo getHallInfoById(@RequestParam("hallId") int hallId) {				
		return performanceService.getHallInfoById(hallId);
	}
	
	@GetMapping("/update/getGenres.do")
	public @ResponseBody String[] getGenresByCategory(@RequestParam("category") String category) {
		
		System.out.println(category);
		
		String genreCat = "";
		if (category.equals("콘서트")) {
			genreCat = "콘서트";
		} else if(category.equals("뮤지컬") || category.equals("연극")) {
			genreCat = "뮤지컬/연극";
		}
				
		//Map<String, Object> map = new HashMap<>();
		//map.put("categoryGenres", performanceService.getGenreByCategory(genreCat));
		
		String[] genres = performanceService.getGenreByCategory(genreCat);
		
		//System.out.println(genres[0]);
		
		return genres;
	}

	@GetMapping("/insertLikes.do")
	public @ResponseBody Map<String, Object> insertLikes(@RequestParam("id") int performanceId,
			@RequestParam("userId") String userId) {
	
		UserLikes userLikes = new UserLikes();
		userLikes.setId(userId);
		userLikes.setPerformanceInfoId(performanceId);
		
		PerformanceDetailDto performanceOrigin = performanceService.getPerformanceDetailById(performanceId);
		Performance newPerformance = new Performance();
		newPerformance.setId(performanceOrigin.getId());
		newPerformance.setLikes(performanceOrigin.getLikes()+1);
		
		// 이부분 서비스에 가서 트랜잭션 처리한다.
		//performanceService.insertPerformanceLikes(userLikes);
		//performanceService.updatePerformanceLikes(newPerformance);
		performanceService.insertPerformanceLikes(userLikes, newPerformance);
		
		
		
		Map<String, Object> map = new HashMap<>();
		map.put("successYn", "Y");
		return map;
	}
	
	@GetMapping("/deleteLikes.do")
	public @ResponseBody Map<String, Object> deleteLikes(@RequestParam("id") int performanceId,
			@RequestParam("userId") String userId) {
	
		UserLikes userLikes = new UserLikes();
		userLikes.setId(userId);
		userLikes.setPerformanceInfoId(performanceId);
		
		PerformanceDetailDto performanceOrigin = performanceService.getPerformanceDetailById(performanceId);
		Performance newPerformance = new Performance();
		newPerformance.setId(performanceOrigin.getId());
		newPerformance.setLikes(performanceOrigin.getLikes()-1);
		
		// 이부분 서비스에서 트랜젝션 처리한다.
		//performanceService.deletePerformanceLikes(userLikes);
		//performanceService.updatePerformanceLikes(newPerformance);
		performanceService.deletePerformanceLikes(userLikes, newPerformance);
		
		
		Map<String, Object> map = new HashMap<>();
		map.put("successYn", "Y");
		return map;
	}
	
	
}
