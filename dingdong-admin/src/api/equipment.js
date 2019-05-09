import request from '../utils/request'

export function equipmentInfo() {
  return request({
    url: '/equipment/all',
    method: 'get'
  })
}
