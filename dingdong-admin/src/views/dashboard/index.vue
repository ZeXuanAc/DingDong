<template>
  <div class="dashboard-container">
    <div class="dashboard-text">name: {{ name }}</div>

    <panel-group @handleSetLineChartData="handleSetLineChartData" />

  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import PanelGroup from './components/PanelGroup'
import store from '../../store'

const lineChartData = {
  newVisitis: {
    expectedData: [100, 120, 161, 134, 105, 160, 165],
    actualData: [120, 82, 91, 154, 162, 140, 145]
  },
  messages: {
    expectedData: [200, 192, 120, 144, 160, 130, 140],
    actualData: [180, 160, 151, 106, 145, 150, 130]
  },
  purchases: {
    expectedData: [80, 100, 121, 104, 105, 90, 100],
    actualData: [120, 90, 100, 138, 142, 130, 130]
  },
  shoppings: {
    expectedData: [130, 140, 141, 142, 145, 150, 160],
    actualData: [120, 82, 91, 154, 162, 140, 130]
  }
}

export default {
  name: '',
  components: {
    PanelGroup
  },
  data() {
    return {
      lineChartData: lineChartData.newVisitis
    }
  },
  computed: {
    ...mapGetters([
      'name'
    ])
  },
  created: function() {
    console.log('store.getters.userNum: ' + store.getters.userNum)
    if (store.getters.userNum === 0) {
      store.dispatch('user/getUserNum')
    }
    console.log('store.getters.buildingNum: ' + store.getters.buildingNum)
    if (store.getters.buildingNum === 0) {
      store.dispatch('building/getBuildingNum')
    }
    console.log('store.getters.storeyNum: ' + store.getters.storeyNum)
    if (store.getters.storeyNum === 0) {
      store.dispatch('storey/getStoreyNum')
    }
    console.log('store.getters.equipmentNum: ' + store.getters.equipmentNum)
    if (store.getters.equipmentNum === 0) {
      store.dispatch('equipment/getEquipmentNum')
    }
  },
  methods: {
    handleSetLineChartData(type) {
      this.lineChartData = lineChartData[type]
    }
  }

}
</script>

<style lang="scss" scoped>
.dashboard {
  &-container {
    margin: 30px;
    padding: 32px;
    background-color: rgb(240, 242, 245);
  }
  &-text {
    font-size: 30px;
    line-height: 46px;
  }
}
</style>
