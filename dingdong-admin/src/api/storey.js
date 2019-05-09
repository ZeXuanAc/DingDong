import request from '../utils/request'

export function storeyInfo() {
  return request({
    url: '/storey',
    method: 'get'
  })
}
