package com.spring.learn.controller;

import com.spring.learn.model.User;
import com.spring.learn.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by baiguantao on 2017/5/22.
 */
@Controller
@RequestMapping("/t/")
public class FirstController {
    @Autowired
    UserService userService;
    @RequestMapping("index")
    public String index(ModelMap map){
        User user=userService.getUserById("1");
        System.out.println(user.getUserName());
        map.put("user",user);
        return "test";
    }
}
