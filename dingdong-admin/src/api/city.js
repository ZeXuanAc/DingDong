import request from '../utils/request'

export function cityInfo(params) {
  return request({
    url: '/admin/getCityList',
    method: 'get',
    params: params
  })
}

export function cityInsert(params) {
  return request({
    url: '/admin/city/insert',
    method: 'get',
    params: params
  })
}

export function cityUpdate(params) {
  return request({
    url: '/admin/city/update',
    method: 'get',
    params: params
  })
}

export function cityDelete(params) {
  return request({
    url: '/admin/city/delete',
    method: 'get',
    params: params
  })
}

