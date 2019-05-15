<template>
  <div>
    <div class="dashboard-container">
      <div class="dashboard-text">欢迎您: {{ name }}</div>
      <panel-group />
      <div class="chart-container" style="background:#fff;">
        <div class="filter-container" style="margin-top: 20px; padding-top: 20px; padding-left: 20px">
          <el-select v-model="buildingName" filterable placeholder="buildingName" clearable style="width: 200px" class="filter-item">
            <el-option v-for="item in buildingSet" :key="item.name" :label="item.name" :value="item.name" />
          </el-select>
          <el-button class="filter-item" type="primary" icon="el-icon-search" @click="getList" style="padding-left: 20px">
            搜索
          </el-button>
        </div>
        <div id="chart" style="width: 100%; height:350px;" />
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import PanelGroup from './components/PanelGroup'
import store from '../../store'
import echarts from 'echarts'
import { getStoreyOccupancyRate, buildingList } from '../../api/building'

export default {
  name: 'Home',
  components: {
    PanelGroup
  },
  data() {
    return {
      chart: null,
      buildingName: '',
      buildingId: '',
      buildingSet: new Set([]),
      list: [],
      storeyNameData: [],
      xAxisData: [],
      latestTime: '',
      intervalId: 0
    }
  },
  computed: {
    ...mapGetters([
      'name'
    ])
  },
  created: function() {
    if (store.getters.userNum === 0) {
      store.dispatch('user/getUserNum')
    }
    if (store.getters.buildingNum === 0) {
      store.dispatch('building/getBuildingNum')
    }
    if (store.getters.storeyNum === 0) {
      store.dispatch('storey/getStoreyNum')
    }
    if (store.getters.equipmentNum === 0) {
      store.dispatch('equipment/getEquipmentNum')
    }
    this.setInitDate()
    buildingList({ pageNum: 1, pageSize: 2147483647, adminId: this.$store.getters.id }).then(response => {
      response.data.list.forEach(item => this.buildingSet.add(item))
      this.buildingName = this.buildingSet.values().next().value.name
      this.getList()
    }).catch(() => {
      this.$message({
        message: '获取buildingSet失败',
        type: 'danger'
      })
    })
  },
  beforeDestroy() {
    this.destroyChat()
    clearInterval(this.intervalId)
  },
  methods: {
    setInitDate() {
      const date = new Date()
      const Y = date.getFullYear() + '-'
      const M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-'
      const D = date.getDate() + ' '
      const h = '00:'
      const m = '00:'
      const s = '00'
      this.latestTime = Y + M + D + h + m + s
      this.list = []
      this.xAxisData = []
      this.storeyNameData = []
    },
    getList() {
      this.destroyChat()
      clearInterval(this.intervalId)
      this.setBuildingId(this.buildingName)
      this.setInitDate()
      getStoreyOccupancyRate({ buildingId: this.buildingId, latestTime: this.latestTime }).then(response => {
        this.list.push.apply(this.list, response.data.list)
        this.list.forEach(item => {
          this.storeyNameData.push(item.name)
          item.type = 'line'
          item.smooth = 'true'
          item.showSymbol = false
        })
        this.latestTime = response.data.latestTime
        this.xAxisData.push.apply(this.xAxisData, response.data.xAxisData)
        this.initChart()
        this.intervalId = setInterval(() => {
          this.getUpdateData()
        }, 10000)
      })
    },
    getUpdateData() {
      getStoreyOccupancyRate({ buildingId: this.buildingId, latestTime: this.latestTime }).then(response => {
        this.list.forEach(item => {
          response.data.list.forEach(item2 => {
            if (item2.name === item.name) {
              item.data.push.apply(item.data, item2.data)
            }
          })
        })
        this.latestTime = response.data.latestTime
        this.xAxisData.push.apply(this.xAxisData, response.data.xAxisData)
        this.setChartOption()
      })
    },
    setBuildingId(buildingName) {
      this.buildingSet.forEach(item => {
        if (item.name === buildingName) {
          this.buildingId = item.id
        }
      })
    },
    initChart() {
      this.chart = echarts.init(document.getElementById('chart'))
      this.setChartOption()
    },
    setChartOption() {
      this.chart.setOption({
        // backgroundColor: '#00CED1',
        title: {
          top: 20,
          left: 20,
          text: this.buildingName + '的实时占有率曲线'
        },
        tooltip: {
          trigger: 'axis'
        },
        legend: {
          data: this.storeyNameData,
          top: 40,
          right: '4%'
        },
        grid: {
          top: 125,
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        toolbox: {
          right: '4%',
          feature: {
            dataZoom: {
              yAxisIndex: 'none'
            },
            restore: {},
            saveAsImage: {}
          }
        },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: this.xAxisData
        },
        yAxis: {
          type: 'value',
          name: '(%)'
        },
        dataZoom: [{
          type: 'inside',
          start: 97,
          end: 100
        }, {
          start: 97,
          end: 100,
          handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
          handleSize: '80%',
          handleStyle: {
            color: '#fff',
            shadowBlur: 3,
            shadowColor: 'rgba(0, 0, 0, 0.6)',
            shadowOffsetX: 2,
            shadowOffsetY: 2
          }
        }],
        series: this.list
      })
    },
    destroyChat() {
      if (!this.chart) {
        return
      }
      this.chart.dispose()
      this.chart = null
    }
  }

}
</script>

<style lang="scss" scoped>
.dashboard {
  &-container {
    margin: 25px;
    padding: 32px;
    background-color: rgb(240, 242, 245);
  }
  &-text {
    font-size: 30px;
    line-height: 46px;
  }
}
</style>
