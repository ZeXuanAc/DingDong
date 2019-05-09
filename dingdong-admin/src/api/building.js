import request from '../utils/request'

export function buildingInfo(params) {
  return request({
    url: '/building',
    method: 'get',
    params
  })
}
