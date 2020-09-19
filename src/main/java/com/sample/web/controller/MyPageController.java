package com.sample.web.controller;
 
import java.util.*;
import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.HttpSession;

import com.sample.service.*;
import com.sample.utils.NumberUtil;
import com.sample.web.view.*;

import oracle.jdbc.proxy.annotation.Post;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.sample.web.security.Auth;

@Controller
@RequestMapping("/mypage")
public class MyPageController {
    private final
    ReserveService reserveService;
    private final
    UserService userService;
    private final
    PerformanceService performanceService;
    private final
    QnaService qnaService;
    private final
    PaymentService paymentService;
    private final
    MateService mateService;

    @Autowired
    public MyPageController(ReserveService reserveService, UserService userService, PerformanceService performanceService, QnaService qnaService, PaymentService paymentService, MateService mateService) {
        this.reserveService = reserveService;
        this.userService = userService;
        this.performanceService = performanceService;
        this.qnaService = qnaService;
        this.paymentService = paymentService;
        this.mateService = mateService;
    }


    @Auth
    @RequestMapping("/mypagemain.do")
    public String main(HttpSession session, Model model) {
        User user = (User) session.getAttribute("LOGIN_USER");
        user = userService.getUserDetail(user.getId());
        user.setLikes(performanceService.getPerformanceByUserId(user.getId()));
        Reserve reserve = reserveService.getLastestReserveByUserId(user.getId());
        List<Qna> qnaList = qnaService.getQnasByUserId(user.getId());

        model.addAttribute("user", user);

        model.addAttribute("lastReserve", reserve);
        
        model.addAttribute("qnaList", qnaList);
        
        return "mypage/mypagemain";
    }

    @Auth
    @GetMapping("/myperformance.do")
    public String myPerformance() {
        System.out.println("load myperformance page");
        return "mypage/myperformance";
    }

    @PostMapping("/myperformance.do")
    @ResponseBody
    public Map<String, Object> myPerformance(@RequestBody User user) {
     
        List<Reserve> reserves = reserveService.getReservesByUserId(user.getPoint(), user.getId());
        Map<String, Object> map = new HashMap<>();


        map.put("reserves", reserves);


        return map;
    }

    @Auth
    @RequestMapping("/myperformanceDetail.do")
    public String myPerformanceDetail(@RequestParam("reserveId") String reserveId, HttpSession session, Model model) {
        int id = NumberUtil.stringToInt(reserveId);
        // user
        User user = (User) session.getAttribute("LOGIN_USER");
        user = userService.getUserDetail(user.getId());
        model.addAttribute("user", user);
        // reserve
        Reserve reserve = reserveService.getReserveDetail(id);
        model.addAttribute("reserve", reserve);
        model.addAttribute("performance", reserve.getPerformance());
        model.addAttribute("hall", reserve.getPerformance().getSchedule().get(0).getHallinfo());
        if (reserve.getMate() != null) {
            model.addAttribute("mate", reserve.getMate());
            System.out.println(reserve.getMate().getCategory());
            System.out.println(reserve.getMate().getMateTags().size());
        }
        model.addAttribute("PerformanceMain", reserveService.getPerformanceMainByReserveId(reserve.getId()));
        // payment
        Payment payment = paymentService.getPaymentByReserveId(id);
        model.addAttribute("payment", payment);
        return "mypage/myperformanceDetail";
    }
    @Auth
    @RequestMapping("/mymateroom.do")
    public String myMateRoom() {
        return "mypage/mymateroom";
    }
    
    @PostMapping("/mymateroom.do")
    @ResponseBody
    public Map<String, Object> myMateRoom(HttpSession session){
        Map<String, Object> map = new HashMap<>();
        User user = (User) session.getAttribute("LOGIN_USER");
        List<Mate> mates = mateService.mateListForMypage(user.getId());
        for(Mate mate : mates) {
        	System.out.println(mate);
        }
        map.put("mateList" , mates);
        return map;
    }

    @RequestMapping("/myProfileUpdate.do")
    @ResponseBody
    public Map<String, Object> myProfile(HttpSession session, @RequestBody Map<String, Object> param){
        Map<String, Object> map = new HashMap<>();
        User user = (User) session.getAttribute("LOGIN_USER");
        String id = user.getId();
        if("intro".equals(param.get("req"))){
        	 List<String> list = new ArrayList<>();
             String introText = param.get("tags").toString();
             if(!"".equals(introText)){
                 Arrays.stream(introText.substring(1).split("#")).forEach(s ->list.add("#" + s));
                 Map<String, Object> introParam = new HashMap<>();
                 userService.deleteUserIntro(id);
                 introParam.put("id", id);
                 introParam.put("list", list);
                 userService.updateUserIntro(introParam);
             }
        }else if("interest".equals(param.get("req"))){
        	 List<UserIntrest> list = new ArrayList<>();
             Map<String, Object> interestParam = new HashMap<>();
            String genreStr =  param.get("genre").toString();
            String artistStr = param.get("artist").toString();
            String performanceStr = param.get("performance").toString();

            if(!"".equals(genreStr)) {
            	 Arrays.stream(genreStr.substring(1).split("#")).forEach(s -> list.add(new UserIntrest(id,"#"+s,"genre")));
            }
            System.out.println();
            if(!"".equals(artistStr)) {
            	 Arrays.stream(artistStr.substring(1).split("#")).forEach(s -> list.add(new UserIntrest(id,"#"+s,"artist")));
            }
            System.out.println();
            if(!"".equals(performanceStr)) {
            	 Arrays.stream(performanceStr.substring(1).split("#")).forEach(s -> list.add(new UserIntrest(id,"#"+s,"performance")));

            }
            userService.deleteUserInterest(id);
            interestParam.put("list", list);
            userService.updateUserInterest(interestParam);
        }

        return map;
    }


    @Auth
    @RequestMapping("/myprofile.do")
    public String myProfile(Model model, HttpSession session) {
        User user = (User) session.getAttribute("LOGIN_USER");
        if (user != null) {
            userService.getUserDetail(user.getId());
        }

        model.addAttribute("user", user);
        return "mypage/myprofile";
    }

    @PostMapping("/myprofile.do")
    @ResponseBody
    public Map<String, Object> myProfile(HttpSession session) {
        User user = (User) session.getAttribute("LOGIN_USER");
        user = userService.getUserDetail(user.getId());
        Map<String, Object> map = new HashMap<>();
        map.put("user", user);
        System.out.println(user.getInterest().size());
        System.out.println(user.getIntro().size());
        return map;
    }

    @Auth
    @RequestMapping("/myLikes.do")
    public String myLikes() {
        return "mypage/myLikes";
    }

    @PostMapping("/myLikes.do")
    @ResponseBody
    public Map<String, Object> myLikes(@RequestBody User user) {
        Map<String, Object> map = new HashMap<>();
        List<Performance> likes = performanceService.getUserLikeList(user.getPoint(), user.getId());
        System.out.println(likes.size());
        map.put("likes", likes);
        return map;
    }

    @Auth
    @RequestMapping("/myCoupon.do")
    public String myCoupon() {
        return "mypage/myCoupon";
    }

    @ResponseBody
    @PostMapping("/myCoupon.do")
    public Map<String, Object> myCoupon(HttpSession session, @RequestBody Map<String, Object> param) {
        Map<String, Object> map = new HashMap<>();
        //get all coupons count
        User user = (User) session.getAttribute("LOGIN_USER");
        String userId = user.getId();
        user = userService.getUserDetail(userId);
        param.put("userId",userId);
        user.setCoupons(userService.getCouponByUserIdForPagination(param));

        map.put("coupons", user.getCoupons());
        map.put("totalRows", userService.getAllUsersCouponCount(userId));
        return map;
    }

    @Auth
    @RequestMapping("/myPoint.do")
    public String myPoint() {
        return "mypage/myPoint";
    }

    @ResponseBody
    @PostMapping("/myPoint.do")
    public Map<String, Object> myPoint(HttpSession session, @RequestBody Map<String, Object> param) {
        Map<String, Object> map = new HashMap<>();
        User user = (User) session.getAttribute("LOGIN_USER");
        String userId = user.getId();
        user = userService.getUserDetail(userId);
        param.put("userId", userId);
        user.setUserPointHistory(userService.getUserPointHistoryForPagination(param));
        map.put("pointHistory", user.getUserPointHistory());
        map.put("currPoint", user.getPoint());
        map.put("totalRows", userService.getAllPointHistoryCount(userId));
        return map;
    }
}
