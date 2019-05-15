<template>
  <div class="chart-container">
    <div class="filter-container" style="margin-top: 20px;margin-left: 20px;">
      <el-time-select
        v-model="endTime"
        placeholder="起始时间"
        :picker-options="{
          start: '00:00',
          step: '01:00',
          end: '23:00'
        }"
      />
      <el-select v-model="buildingName" filterable placeholder="buildingName" clearable style="width: 200px" class="filter-item">
        <el-option v-for="item in buildingSet" :key="item.name" :label="item.name" :value="item.name" />
      </el-select>
      <el-button class="filter-item" type="primary" icon="el-icon-search" @click="getList">
        搜索
      </el-button>
    </div>
    <div id="chart" style="width: 100%; height:80%;" />
  </div>
</template>

<script>
import echarts from 'echarts'
import { buildingList, getStoreyUseCount } from '../../api/building'

export default {
  name: 'StoreyUseCount',
  data() {
    return {
      chart: null,
      buildingName: '',
      buildingId: '',
      buildingSet: new Set([]),
      seriesData: [],
      legendData: [],
      xAxisData: [],
      endTime: '',
      finalEndTime: ''
    }
  },
  created() {
    this.setInitData()
    this.setEndTimeInitValue()
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
    setEndTimeInitValue() {
      const date = new Date()
      const h = date.getHours() + ':'
      const m = '00'
      this.endTime = h + m
    },
    setInitData() {
      this.seriesData = []
      this.xAxisData = []
      this.legendData = []
    },
    setEndTime() {
      const date = new Date()
      const Y = date.getFullYear() + '-'
      const M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-'
      const D = date.getDate() + ' '
      this.finalEndTime = Y + M + D + this.endTime + ':00'
    },
    getList() {
      this.destroyChat()
      this.setBuildingId(this.buildingName)
      this.setInitData()
      this.setEndTime()
      getStoreyUseCount({ buildingId: this.buildingId, endTime: this.finalEndTime }).then(response => {
        this.seriesData = response.data.series
        var totalUseCountList = []
        this.seriesData.forEach(item => {
          item.type = 'bar'
          if (item.stack !== undefined && item.stack === 'storey') {
            item.barWidth = 15
            item.label = { show: true }
          } else {
            item.barWidth = 24
            item.label = { show: true }
            totalUseCountList = item.data
          }
        })
        this.seriesData.push({
          name: 'ALL-Line',
          type: 'line',
          data: totalUseCountList,
          label: {
            show: true
          }
        })
        this.legendData = response.data.legend
        this.legendData.push('ALL-Line')
        this.xAxisData = response.data.xAxisData
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
          text: this.buildingName + '的今日访问量'
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: { // 坐标轴指示器，坐标轴触发有效
            type: 'shadow' // 默认为直线，可选为：'line' | 'shadow'
          }
        },
        legend: {
          data: this.legendData,
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
          data: this.xAxisData,
          nameTextStyle: {
            width: 20
          }
        },
        yAxis: {
          type: 'value',
          name: '次数'
        },
        series: this.seriesData
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

