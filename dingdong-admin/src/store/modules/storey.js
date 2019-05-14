import { storeyInfo } from '../../api/storey'

const state = {
  storeyNum: '0'
}

const mutations = {
  SET_STOREYNUM: (state, storeyNum) => {
    state.storeyNum = storeyNum
  }
}

const actions = {
  getStoreyNum({ commit }) {
    return new Promise((resolve, reject) => {
      storeyInfo().then(response => {
        commit('SET_STOREYNUM', response.data.length)
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

