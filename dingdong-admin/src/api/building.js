import request from '../utils/request'

export function buildingInfo(params) {
  return request({
    url: '/building',
    method: 'get',
    params
  })
}

export function buildingList(params) {
  return request({
    url: '/admin/building',
    method: 'get',
    params
  })
}

export function buildingInsert(params) {
  return request({
    url: '/admin/building/insert',
    method: 'get',
    params: params
  })
}

export function buildingUpdate(params) {
  return request({
    url: '/admin/building/update',
    method: 'get',
    params: params
  })
}

export function buildingDelete(params) {
  return request({
    url: '/admin/building/delete',
    method: 'get',
    params: params
  })
}

export function buildingStoreyList(params) {
  return request({
    url: '/admin/building/storeyInfo',
    method: 'get',
    params
  })
}

export function getStoreyOccupancyRate(params) {
  return request({
    url: '/admin/building/storeyOccupancyRate',
    method: 'get',
    params
  })
}

export function getStoreyUseCount(params) {
  return request({
    url: '/admin/building/storeyUseCount',
    method: 'get',
    params
  })
}
