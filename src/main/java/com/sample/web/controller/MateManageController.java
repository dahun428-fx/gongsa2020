package com.sample.web.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sample.dto.JsonHallSeat;
import com.sample.dto.JsonPerformance;
import com.sample.dto.MateList;
import com.sample.dto.PerformanceDetailDto;
import com.sample.dto.PerformanceDto;
import com.sample.service.MateManagerService;
import com.sample.service.MateService;
import com.sample.service.PerformanceService;
import com.sample.web.form.MateForm;
import com.sample.web.view.Mate;
import com.sample.web.view.Performance;

@Controller
@RequestMapping("/manager")
public class MateManageController {

	@Autowired
	PerformanceService performanceService;
	
	@Autowired
	MateManagerService mateManagerService;
	
	@Autowired
	MateService mateService;
	
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
	public @ResponseBody void addMateCat(@RequestParam("id") int id,
										@RequestParam("category") String category) {
		
		mateManagerService.addMateCat(id, category);
	}
	@RequestMapping("/countMate.do")
	public @ResponseBody int countMate(@RequestBody MateForm mateForm) {
		
		return mateManagerService.countMate(mateForm.getSeats());
	}
	@RequestMapping("/mateManagementJson.do")
	public @ResponseBody Map<String, Object> mateManagementList() {
		Map<String, Object> map = new HashMap<>();
		List<MateList> list = mateService.getAllMateListForManagement();
		map.put("mateList", list);
		return map;
	}
	@RequestMapping("/mateList.do")
	public String mateManagerList() {
		return "mate/mateManagerList";
	}
	
}
