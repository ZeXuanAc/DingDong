<template>
  <div class="chart-container">
    <div class="filter-container" style="margin-top: 20px;margin-left: 20px;">
      <el-date-picker
        v-model="datePickerValue"
        type="datetimerange"
        :picker-options="pickerOptions"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        align="right"
      />
      <el-select v-model="buildingName" filterable placeholder="buildingName" clearable style="width: 200px" class="filter-item">
        <el-option v-for="item in buildingSet" :key="item.name" :label="item.name" :value="item.name" />
      </el-select>
      <el-button class="filter-item" type="primary" icon="el-icon-search" @click="getList">
        搜索
      </el-button>
    </div>
    <div id="chart" style="width: 100%; height:60%;" />
  </div>
</template>

<script>
import echarts from 'echarts'
import { getStoreyOccupancyRate, buildingList } from '../../api/building'
import { dateFormat } from '../../utils/index'

export default {
  name: 'OccupancyRateChart',
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
      endTime: '',
      datePickerValue: [],
      pickerOptions: {
        shortcuts: [{
          text: '最近1小时',
          onClick(picker) {
            const end = new Date()
            const start = new Date()
            start.setTime(start.getTime() - 3600 * 1000)
            picker.$emit('pick', [start, end])
          }
        }, {
          text: '最近3小时',
          onClick(picker) {
            const end = new Date()
            const start = new Date()
            start.setTime(start.getTime() - 3600 * 1000 * 3)
            picker.$emit('pick', [start, end])
          }
        }, {
          text: '最近12小时',
          onClick(picker) {
            const end = new Date()
            const start = new Date()
            start.setTime(start.getTime() - 3600 * 1000 * 12)
            picker.$emit('pick', [start, end])
          }
        }, {
          text: '最近3天',
          onClick(picker) {
            const end = new Date()
            const start = new Date()
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 3)
            picker.$emit('pick', [start, end])
          }
        }]
      }
    }
  },
  created() {
    this.setInitData()
    this.setDatePikerValue()
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
  },
  methods: {
    setDatePikerValue() {
      const date = new Date()
      const Y = date.getFullYear() + '-'
      const M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-'
      const D = date.getDate() + ' '
      const h = (date.getHours() - 2 < 10 ? '0' + (date.getHours() - 2) : date.getHours() - 2) + ':'
      const nowH = date.getHours() + ':'
      const m = date.getMinutes() + ':'
      const s = date.getSeconds()
      this.latestTime = Y + M + D + h + m + s
      this.endTime = Y + M + D + nowH + m + s
      this.datePickerValue = [this.latestTime, this.endTime]
    },
    setInitData() {
      this.list = []
      this.xAxisData = []
      this.storeyNameData = []
    },
    getList() {
      this.destroyChat()
      clearInterval(this.intervalId)
      this.setBuildingId(this.buildingName)
      this.setInitData()
      console.log('1---> latestTime: ' + this.latestTime + ' , endTime: ' + this.endTime)
      this.latestTime = dateFormat(this.datePickerValue[0])
      this.endTime = dateFormat(this.datePickerValue[1])
      console.log('2---> latestTime: ' + this.latestTime + ' , endTime: ' + this.endTime)
      getStoreyOccupancyRate({ buildingId: this.buildingId, latestTime: this.latestTime, endTime: this.endTime }).then(response => {
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
          text: this.buildingName + '的历史占有率曲线'
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
          start: 0,
          end: 100
        }, {
          start: 0,
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

<style scoped>
.chart-container{
  position: relative;
  width: 100%;
  height: calc(100vh - 84px);
}
</style>

