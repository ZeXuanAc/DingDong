import { equipmentInfo } from '../../api/equipment'

const state = {
  equipmentNum: '0'
}

const mutations = {
  SET_EQUIPMENTNUM: (state, equipmentNum) => {
    state.equipmentNum = equipmentNum
  }
}

const actions = {
  getEquipmentNum({ commit }) {
    console.log('start store getEquipmentNum')
    return new Promise((resolve, reject) => {
      equipmentInfo().then(response => {
        commit('SET_EQUIPMENTNUM', response.data.length)
        console.log('get api getEquipmentNum : ' + response.data.length)
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

