const serviceUrl = 'http://192.168.31.234:8080/';// 开发环境url
const servicePath = {
    'homePageContext': serviceUrl + 'redis/get', // 获取 building 下的设备信息
    'homePageContext-test': 'https://www.easy-mock.com/mock/5cad67b142f74a7dcde9a030/example/redis/get', // 获取 building 下的设备信息
    'building': serviceUrl + 'building', // 获取所有building, 按照离定位位子的距离排序
};