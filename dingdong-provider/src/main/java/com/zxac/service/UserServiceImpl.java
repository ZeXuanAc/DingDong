package com.zxac.service;


import com.alibaba.dubbo.config.annotation.Service;
import com.zxac.dao.BuildingFollowMapper;
import com.zxac.dao.UserMapper;
import com.zxac.dto.BuildingFollowDto;
import com.zxac.dto.UserDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.BuildingFollow;
import com.zxac.model.Result;
import com.zxac.model.User;
import com.zxac.utils.DistanceUtil;
import com.zxac.utils.ObjectUtil;
import com.zxac.utils.RedisUtil;
import com.zxac.utils.UuidUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import redis.clients.jedis.Jedis;

import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service(interfaceClass = UserService.class)
@Component
@Slf4j
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private BuildingFollowMapper buildingFollowMapper;

    @Override
    public Result autoLogin(String token) {
        Jedis jedis = null;
        Map<String, String> userMap;
        if (token == null) {
            return Result.failure(FailureCode.CODE710);
        }
        try {
            jedis = RedisUtil.getJedis();
            if (jedis != null) {
                if (jedis.exists(token)) {
                    userMap = jedis.hgetAll(token);
                } else {
                    return Result.failure(FailureCode.CODE701);
                }
            } else {
                log.error("jedis is null");
                return Result.failure(FailureCode.CODE600);
            }
        } catch (Exception e) {
            log.error("自动登陆异常, 用户token: {}", token);
            return Result.failure(FailureCode.CODE706);
        } finally {
            RedisUtil.close(jedis);
        }
        return Result.success("自动登陆成功", userMap);
    }


    /**
     * 登陆，查询数据库是否存在此用户，不存在则返回注册，存在则存token到redis并返回用户信息
     * @param phone
     * @param password
     * @return
     */
    @Override
    public Result login(String phone, String password) {
        Jedis jedis = null;
        Pattern r = Pattern.compile("0?(13|14|15|18|17)[0-9]{9}");
        Map<String, String> userInfoMap;
        if (password == null) {
            return Result.failure(FailureCode.CODE707);
        }
        if (phone != null && r.matcher(phone).matches()) {
            String token = UuidUtil.getUUID();
            UserDto userDto = UserDto.accept(userMapper.selectByPhonePassword(phone, password));
            if (userDto == null) {
                return Result.failure(FailureCode.CODE703);
            }
            try {
                jedis = RedisUtil.getJedis();
                if (jedis != null) {
                    userInfoMap = ObjectUtil.toMap(userDto, String.class, "token");
                    jedis.hmset(token, userInfoMap);
                    jedis.expire(token, RedisUtil.tokenExpire);
                    userInfoMap.put("token", token);
                } else {
                    log.error("jedis is null");
                    return Result.failure(FailureCode.CODE600);
                }
            } catch (Exception e) {
                log.error("登陆异常, 用户phone: {}, password: {}", phone, password);
                return Result.failure(FailureCode.CODE700);
            } finally {
                RedisUtil.close(jedis);
            }
            return Result.success("登陆成功", userInfoMap);
        } else {
            return Result.failure(FailureCode.CODE702);
        }
    }


    /**
     * 注册：1、验证数据完整性。2、插入数据库。3、生成token存redis, 返回用户信息
     * @param dto
     * @return
     */
    @Override
    @Transactional
    public Result signUp(UserDto dto) {
        Jedis jedis = null;
        Map<String, String> userInfoMap;
        Pattern r = Pattern.compile("0?(13|14|15|18|17)[0-9]{9}");
        if (dto == null || dto.getPhone() == null || dto.getName() == null || dto.getGender() == null || dto.getPassword() == null) {
            return Result.failure(FailureCode.CODE704);
        }
        if (!r.matcher(dto.getPhone()).matches()) {
            return Result.failure(FailureCode.CODE702);
        }
        if (userMapper.selectCountByPhone(dto.getPhone()) > 0) {
            return Result.failure(FailureCode.CODE708);
        }
        User user = User.accept(dto);
        int result = userMapper.insertSelective(user);
        if (result == 1) {
            dto.setId(user.getId());
            userInfoMap = ObjectUtil.toMap(dto, String.class, "token");
            String token = UuidUtil.getUUID();
            try {
                jedis = RedisUtil.getJedis();
                if (jedis != null) {
                    jedis.hmset(token, userInfoMap);
                    jedis.expire(token, RedisUtil.tokenExpire);
                    userInfoMap.put("token", token);
                } else {
                    log.error("jedis is null");
                    return Result.failure(FailureCode.CODE600);
                }
            } catch (Exception e) {
                log.error("注册异常, 用户phone: {}, name: {}", dto.getPhone(), dto.getName());
                throw new BusinessException(FailureCode.CODE705);
            } finally {
                RedisUtil.close(jedis);
            }
            return Result.success("注册成功", userInfoMap);
        }
        throw new BusinessException(FailureCode.CODE709);
    }


    /**
     * 修改用户信息，数据库修改，token数据修改
     * @param dto
     * @return
     */
    @Override
    @Transactional
    public Result editInfo(UserDto dto) {
        Jedis jedis = null;
        if (dto.getId() == null) {
            return Result.failure(FailureCode.CODE752);
        }
        int result = userMapper.updateByPrimaryKeySelective(User.accept(dto));
        if (result == 1) {
            log.info("mysql 用户信息修改成功");
            try {
                jedis = RedisUtil.getJedis();
                if (jedis != null) {
                    if (dto.getToken() == null) {
                        log.warn("请携带用户token, 用户id为：{}", dto.getId());
                        throw new BusinessException(FailureCode.CODE754);
                    }
                    if (jedis.exists(dto.getToken())) {
                        UserDto newDto = UserDto.accept(userMapper.selectByPrimaryKey(dto.getId()));
                        jedis.hmset(dto.getToken(), ObjectUtil.toMap(newDto, String.class, "token"));
                        newDto.setToken(dto.getToken());
                        return Result.success("用户信息修改成功", newDto);
                    } else {
                        throw new BusinessException(FailureCode.CODE701);
                    }
                } else {
                    log.error("jedis is null");
                    throw new BusinessException(FailureCode.CODE600);
                }
            } catch (Exception e) {
                log.error("修改用户信息异常, 用户id: {}", dto.getId());
                throw new BusinessException(FailureCode.CODE753);
            } finally {
                RedisUtil.close(jedis);
            }
        } else {
            throw new BusinessException(FailureCode.CODE751);
        }
    }


    @Override
    public Result followBuildingCount(Integer uid, Integer buildingId) {
        if (uid == null || buildingId == null) {
            return Result.failure(FailureCode.CODE779);
        }
        return Result.success(buildingFollowMapper.selectCountByUidBuildingId(uid, buildingId));
    }

    @Override
    @Transactional
    public Result followBuilding(Integer uid, String phone, Integer buildingId) {
        if (uid == null || phone == null || buildingId == null) {
            return Result.failure(FailureCode.CODE770);
        }
        int count = buildingFollowMapper.selectCountByUidBuildingId(uid, buildingId);
        if (count < 1) {
            int result = buildingFollowMapper.insertSelective(BuildingFollow.builder().uid(uid)
                    .phone(phone).buildingId(buildingId).build());
            if (result == 1) {
                return Result.success("关注成功");
            } else {
                throw new BusinessException(FailureCode.CODE771);
            }
        } else {
            return Result.failure(FailureCode.CODE772);
        }
    }


    @Override
    @Transactional
    public Result unFollowBuilding(Integer uid, Integer buildingId) {
        if (uid == null || buildingId == null) {
            return Result.failure(FailureCode.CODE775);
        }
        int count = buildingFollowMapper.selectCountByUidBuildingId(uid, buildingId);
        if (count == 1) {
            int result = buildingFollowMapper.deleteByUidBuildingId(uid, buildingId);
            if (result == 1) {
                return Result.success("取消关注成功");
            } else {
                throw new BusinessException(FailureCode.CODE777);
            }
        } else {
            return Result.failure(FailureCode.CODE776);
        }
    }


    /**
     *
     * @param uid
     * @param location 经纬度, 纬度在前, 经度在后, 用逗号相隔, 如 30.1123,23232
     * @return
     */
    @Override
    public Result allFollowBuilding(Integer uid, String location) {
        if (uid == null) {
            return Result.failure(FailureCode.CODE786);
        }
        List<BuildingFollowDto> dtoList = buildingFollowMapper.allFollowBuilding(uid);
        if (location != null && !location.equals("")) {
            String[] locations = location.split(",");
            if (locations.length == 2) {
                dtoList.forEach(dto -> {
                    Double distance = DistanceUtil.GetDistance(locations[0], locations[1], dto.getLatitude(), dto.getLongitude());
                    dto.setDistance(distance);
                    dto.setDistanceStr(DistanceUtil.format2decimal(distance));
                });
            }
        } else {
            return Result.failure(FailureCode.CODE501);
        }
        Map<String, List<BuildingFollowDto>> dtoListMap = dtoList.stream().collect(Collectors.groupingBy(BuildingFollowDto::getCityName));
        dtoListMap.values().forEach(list -> list.sort(Comparator.comparing(BuildingFollowDto::getCreateTime).reversed()));
        Map<String, List<BuildingFollowDto>> finalMap = new LinkedHashMap<>();
        dtoListMap.entrySet().stream().sorted(Comparator.comparing(map -> map.getValue().get(0).getDistance())).forEach(e -> finalMap.put(e.getKey(), e.getValue()));
//        dtoListMap.entrySet().stream().sorted((map1, map2) -> map2.getValue().get(0).getCreateTime().compareTo(map1.getValue().get(0).getCreateTime())).forEach(e -> finalMap.put(e.getKey(), e.getValue()));
        return Result.success(finalMap);
    }
}
