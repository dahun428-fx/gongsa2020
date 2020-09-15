package com.sample.web.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sample.dto.MateList;
import com.sample.dto.PerformanceDetailDto;
import com.sample.dto.PerformanceDto;
import com.sample.service.MateService;
import com.sample.service.PerformanceService;

@Controller
public class HomeController {

	@Autowired
	PerformanceService performanceService;
	
	@Autowired
	MateService mateService;
	
	@GetMapping("/home.do")
	public String home(Model model) {
		
		String concert = "콘서트";
		String musical = "뮤지컬";
		String theater = "연극";
		
		List<PerformanceDetailDto> conserts =  performanceService.getPerformanceByCategoryLimit(concert);
		List<PerformanceDetailDto> musicals =  performanceService.getPerformanceByCategoryLimit(musical);
		List<PerformanceDetailDto> theaters =  performanceService.getPerformanceByCategoryLimit(theater);		
	
		List<Object> consertSeatList = new ArrayList<>();
		List<Object> musicalsSeatList = new ArrayList<>();
		List<Object> theatersSeatList = new ArrayList<>();
		for(PerformanceDetailDto dto : conserts) {
			int performanceId = dto.getPerformanceMainId();
			consertSeatList.add(mateService.getMateSeatsAllCnt(performanceId));
		}
		for(PerformanceDetailDto dto : musicals) {
			int performanceId = dto.getPerformanceMainId();
			musicalsSeatList.add(mateService.getMateSeatsAllCnt(performanceId));
		}
		for(PerformanceDetailDto dto : theaters) {
			int performanceId = dto.getPerformanceMainId();
			theatersSeatList.add(mateService.getMateSeatsAllCnt(performanceId));
		}

		model.addAttribute("consertSeatList", consertSeatList);
		model.addAttribute("musicalsSeatList", musicalsSeatList);
		model.addAttribute("theatersSeatList", theatersSeatList);
		
		model.addAttribute("conserts", conserts);
		model.addAttribute("musicals", musicals);
		model.addAttribute("theaters", theaters);
	
		
		return "home";
	}
	@GetMapping("/")
	public String homeGongsa(Model model) {
		
		String concert = "콘서트";
		String musical = "뮤지컬";
		String theater = "연극";
		
		List<PerformanceDetailDto> conserts =  performanceService.getPerformanceByCategoryLimit(concert);
		List<PerformanceDetailDto> musicals =  performanceService.getPerformanceByCategoryLimit(musical);
		List<PerformanceDetailDto> theaters =  performanceService.getPerformanceByCategoryLimit(theater);		
	
		List<Object> consertSeatList = new ArrayList<>();
		List<Object> musicalsSeatList = new ArrayList<>();
		List<Object> theatersSeatList = new ArrayList<>();
		for(PerformanceDetailDto dto : conserts) {
			int performanceId = dto.getPerformanceMainId();
			consertSeatList.add(mateService.getMateSeatsAllCnt(performanceId));
		}
		for(PerformanceDetailDto dto : musicals) {
			int performanceId = dto.getPerformanceMainId();
			musicalsSeatList.add(mateService.getMateSeatsAllCnt(performanceId));
		}
		for(PerformanceDetailDto dto : theaters) {
			int performanceId = dto.getPerformanceMainId();
			theatersSeatList.add(mateService.getMateSeatsAllCnt(performanceId));
		}

		model.addAttribute("consertSeatList", consertSeatList);
		model.addAttribute("musicalsSeatList", musicalsSeatList);
		model.addAttribute("theatersSeatList", theatersSeatList);
		
		model.addAttribute("conserts", conserts);
		model.addAttribute("musicals", musicals);
		model.addAttribute("theaters", theaters);
	
		
		return "redirect:/home.do";
	}
	
}
