import request from '../utils/request'

export function storeyInfo() {
  return request({
    url: 'admin/storey',
    method: 'get'
  })
}
