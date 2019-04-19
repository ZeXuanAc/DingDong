const serviceUrl = 'http://192.168.31.234:8080/'; // 开发环境url
//const serviceUrl = 'http://192.168.43.120:8080/'; // 开发环境url
const servicePath = {
    'homePageContext': serviceUrl + 'redis/get', // 获取 building 下的设备信息
    'building': serviceUrl + 'building', // 获取所有building, 按照离定位位子的距离排序
    'citycode_get': serviceUrl + 'citycode/get', // 检查citycode是否存在
    'allCity': serviceUrl + 'allCity', // 获取所有 city
};