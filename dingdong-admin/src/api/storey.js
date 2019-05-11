import request from '../utils/request'

export function storeyInfo() {
  return request({
    url: 'admin/storey',
    method: 'get'
  })
}

export function storeyDtoInfo(params) {
  return request({
    url: 'admin/storeyDto',
    method: 'get',
    params: params
  })
}

export function storeyInsert(params) {
  return request({
    url: '/admin/storey/insert',
    method: 'get',
    params: params
  })
}

export function storeyUpdate(params) {
  return request({
    url: '/admin/storey/update',
    method: 'get',
    params: params
  })
}

export function storeyDelete(params) {
  return request({
    url: '/admin/storey/delete',
    method: 'get',
    params: params
  })
}
