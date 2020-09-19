package com.sample.web.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sample.dao.ReserveDao;
import com.sample.dto.JsonHallSeat;
import com.sample.dto.MateList;
import com.sample.dto.PerformanceDetailDto;
import com.sample.service.MateManagerService;
import com.sample.service.MateService;
import com.sample.service.PerformanceService;
import com.sample.service.ReserveService;
import com.sample.web.form.MateForm;
import com.sample.web.view.Pagination;
import com.sample.web.view.PerformanceMain;
import com.sample.web.view.Reserve;

@Controller
@RequestMapping("/managerMate")
public class MateManageController {

	@Autowired
	PerformanceService performanceService;
	
	@Autowired
	MateManagerService mateManagerService;
	
	@Autowired
	MateService mateService;
	
	@Autowired
	ReserveService reserveService;
	
	@GetMapping("/mateManager.do")
	public String MateManager() {
		return "mate/mateManager";
	}
	@RequestMapping("/mateManagerJson.do")
	public @ResponseBody Map<String, Object> MateManagerAjax() {
		
		Map<String, Object> map = new HashMap<String, Object>();
		List<PerformanceDetailDto> performanceList = performanceService.getAllPerformances();
		List<Map<Integer, String>> categories = mateService.getMateAllCategory();
		map.put("performanceList", performanceList);
		map.put("categories", categories);
		return map;
	}
	@RequestMapping("/addMate.do")
	public @ResponseBody void addMate(@RequestBody MateForm mateForm) {
		mateManagerService.addMate(mateForm);
		
	}
	@RequestMapping("/addCat.do")
	public @ResponseBody String addMateCat(@RequestParam("id") int id,
										@RequestParam("category") String category) {
		
		mateManagerService.addMateCat(id, category);
		return "redirect:/manager/mateList.do";
	}
	@RequestMapping("/countMate.do")
	public @ResponseBody int countMate(@RequestBody MateForm mateForm) {
		
		return mateManagerService.countMate(mateForm.getSeats());
	}
	@RequestMapping("/updateMate.do")
	public @ResponseBody void updateMate(@RequestBody MateForm mateForm) {
		mateManagerService.updateMate(mateForm);
	}
	
	
	
	@GetMapping("/mateManagerUpdate.do")
	public String mateManagerUpdate(@RequestParam("performanceId") int performanceId, Model model) {
		model.addAttribute("performanceId", performanceId);
		return "mate/mateManagerUpdate";
	}
	@RequestMapping("/mateManagerUpdateJson.do")
	public @ResponseBody Map<String, Object> mateManagerUpdateJson(@RequestParam("performanceId") int performanceId){
		Map<String, Object> map = new HashMap<>();
		
		List<JsonHallSeat> seats = mateManagerService.getHallSeats(performanceId);
		PerformanceMain main = performanceService.getPerformanceMainByPerformanceId(performanceId);
		PerformanceDetailDto performance = performanceService.getPerformanceByPerformanceMainId(performanceId);
		List<Map<Integer, String>> categories = mateService.getMateAllCategory();
		List<PerformanceDetailDto> performanceList = performanceService.getAllPerformances();
		int totalMateSeat = mateManagerService.countMate(seats);
		
		map.put("totalMate", totalMateSeat);
		map.put("seats", seats);
		map.put("main", main);
		map.put("performance", performance);
		map.put("performanceList", performanceList);
		map.put("categories", categories);
		
		return map;
	}
	@RequestMapping("/deleteMate.do")
	@ResponseBody
	public Map<String, Object> deleteMate(@RequestParam("performanceId") int performanceId) {
		List<Reserve> reserves = reserveService.getReserveByPerformanceId(performanceId);
		Map<String, Object> map = new HashMap<>();
		if(reserves.isEmpty()) {
			mateManagerService.deleteMate(performanceId);
			map.put("message", "삭제가 완료되었습니다.");
		} else {
			map.put("message", "이미 예약된 고객이 있는 공연입니다. 예약취소 처리가 필요합니다.");
		}
		
	
		return map;
	}
	
	
	
	
	@RequestMapping("/mateManagementJson.do")
	public @ResponseBody Map<String, Object> mateManagementList(@RequestParam(value="pageNo", defaultValue="1") int pageNo) {
		Map<String, Object> map = new HashMap<>();
		Map<String, Object> queryMap = new HashMap<>();
		int totalRows = mateService.getAllMateTotalRows();

		
		//pagination
		int rowsPerPage = 5;
		int pagesPerBlock = 5;
		Pagination pagination = new Pagination(rowsPerPage, pagesPerBlock, pageNo, totalRows);
		int beginIndex = pagination.getBeginIndex() - 1;
		int endIndex = 5;
		queryMap.put("beginIndex", beginIndex);
		queryMap.put("endIndex", endIndex);
		
		List<MateList> list = mateService.getAllMateListForManagement(queryMap);
		
		map.put("pagination", pagination);
		map.put("mateList", list);
		return map;
	}
	@RequestMapping("/mateList.do")
	public String mateManagerList() {
		return "mate/mateManagerList";
	}
	@RequestMapping("/mateManagementDetail.do")
	public @ResponseBody Map<String, Object> mateManagementDetail(@RequestParam("performanceId") int performanceId){
		Map<String, Object> map = new HashMap<>();
		
		
		Map<String, Object> param = new HashMap<>();
		param.put("performanceId", performanceId);
		List<MateList> detail = mateService.getAllMateDetailForManagement(param);

		
		map.put("detail", detail);
		return map;
	}
}
