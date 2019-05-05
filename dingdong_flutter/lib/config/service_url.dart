//const serviceUrl = 'http://192.168.31.234:8080/'; // 开发环境url
//const serviceUrl = 'http://192.168.43.120:8080/'; // 开发环境url
const serviceUrl = 'http://47.107.118.14:8080/'; // 生产环境
const servicePath = {
    'homePageContext': serviceUrl + 'redis/get', // 获取 building 下的设备信息
    'building': serviceUrl + 'building', // 获取所有building, 按照离定位位子的距离排序
    'citycode_get': serviceUrl + 'citycode/get', // 检查citycode是否存在
    'allCity': serviceUrl + 'allCity', // 获取所有 city
    'autoLogin': serviceUrl + 'autoLogin', // 自动登陆
    'login': serviceUrl + 'login', // 登陆
    'signUp': serviceUrl + 'signUp', // 注册
    'followBuildingCount': serviceUrl + 'user/followBuildingCount', // 查询该building是否已关注
    'followBuilding': serviceUrl + 'user/followBuilding', // 关注building
    'unFollowBuilding': serviceUrl + 'user/unFollowBuilding', // 取消关注building
    'allFollowBuilding': serviceUrl + 'user/allFollowBuilding', // 获取所有关注building
};