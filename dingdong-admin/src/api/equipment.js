import request from '../utils/request'

export function equipmentInfo() {
  return request({
    url: '/admin/equipment/all',
    method: 'get'
  })
}
