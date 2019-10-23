package com.spring.learn.service;

import com.spring.learn.dao.UserMapper;
import com.spring.learn.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by baiguantao on 2017/5/22.
 */
@Service
public class UserService {
    @Autowired
    private UserMapper userMapper;
    public User getUserById(String id){
       return  userMapper.selectByPrimaryKey(id);
    }
}
