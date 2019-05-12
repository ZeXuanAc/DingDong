import request from '../utils/request'

export function equipmentInfo() {
  return request({
    url: '/admin/equipment/all',
    method: 'get'
  })
}

export function equipmentDtoInfo(params) {
  return request({
    url: 'admin/equipmentDto',
    method: 'get',
    params: params
  })
}

export function equipmentInsert(params) {
  return request({
    url: '/admin/equipment/insert',
    method: 'get',
    params: params
  })
}

export function equipmentUpdate(params) {
  return request({
    url: '/admin/equipment/update',
    method: 'get',
    params: params
  })
}

export function equipmentDelete(params) {
  return request({
    url: '/admin/equipment/delete',
    method: 'get',
    params: params
  })
}

export function equipmentInit(params) {
  return request({
    url: '/admin/equipment/init',
    method: 'post',
    params: params
  })
}
