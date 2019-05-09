import { buildingInfo } from '../../api/building'

const state = {
  buildingNum: '0'
}

const mutations = {
  SET_BUILDINGNUM: (state, buildingNum) => {
    state.buildingNum = buildingNum
  }
}

const actions = {
  getBuildingNum({ commit }) {
    console.log('start store getBuildingNum')
    return new Promise((resolve, reject) => {
      buildingInfo({ citycode: '' }).then(response => {
        commit('SET_BUILDINGNUM', response.data.length)
        console.log('get api getBuildingNum : ' + response.data.length)
        resolve(response.data)
      }).catch(error => {
        reject(error)
      })
    })
  }

}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}

