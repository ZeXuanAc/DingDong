import request from '../utils/request'

export function getUserNum() {
  return request({
    url: '/admin/user/num',
    method: 'get'
  })
}

export function login(params) {
  return request({
    url: '/backEnd/login',
    method: 'get',
    params: params
  })
}

export function getInfo(token) {
  return request({
    url: '/admin/userInfo',
    method: 'get',
    params: { token }
  })
}

export function logout() {
  return request({
    url: '/backEnd/logout',
    method: 'get'
  })
}
