<template>
  <div class="app-container">
    <div class="filter-container" style="margin-bottom: 18px">
      <el-select v-model="listQuery.citycode" filterable placeholder="citycode" clearable style="width: 150px" class="filter-item">
        <el-option v-for="item in citycodeSet" :key="item" :label="item" :value="item" />
      </el-select>
      <el-input v-model="listQuery.name" placeholder="buildingName" style="width: 150px;" class="filter-item" @keyup.enter.native="handleFilter" />
      <el-input v-model="listQuery.cityName" placeholder="cityName" style="width: 150px;" class="filter-item" @keyup.enter.native="handleFilter" />
      <el-button class="filter-item" type="primary" icon="el-icon-search" @click="handleFilter">
        搜索
      </el-button>
      <el-button class="filter-item" style="margin-left: 10px;" type="primary" icon="el-icon-edit" @click="handleCreate">
        添加
      </el-button>
    </div>

    <el-table
      :key="tableKey"
      v-loading="listLoading"
      :data="list"
      border
      fit
      highlight-current-row
      style="width: 100%;"
    >
      <el-table-column label="序号" type="index" width="50" />
      <el-table-column label="buildingName" width="120">
        <template slot-scope="{row}">
          <span>{{ row.name }}</span>
        </template>
      </el-table-column>
      <el-table-column label="citycode">
        <template slot-scope="{row}">
          <span>{{ row.citycode }}</span>
        </template>
      </el-table-column>
      <el-table-column label="cityName" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.cityName }}</span>
        </template>
      </el-table-column>
      <el-table-column label="设备数" align="center">
        <template slot-scope="scope">
          <el-tag type="primary" style="cursor:pointer" @click="handleEqNum(scope.row.id)">{{ scope.row.eqNum }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="优先级" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.priority }}</span>
        </template>
      </el-table-column>
      <el-table-column label="纬度" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.latitude }}</span>
        </template>
      </el-table-column>
      <el-table-column label="经度" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.longitude }}</span>
        </template>
      </el-table-column>
      <el-table-column label="最近更新时间" align="center" width="200px">
        <template slot-scope="scope">
          <span>{{ scope.row.updateTime }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="230" class-name="small-padding fixed-width">
        <template slot-scope="{row}">
          <el-button type="primary" size="mini" icon="el-icon-edit" @click="handleUpdate(row)">
            编辑
          </el-button>
          <el-button size="mini" type="danger" icon="el-icon-circle-close-outline" @click="doDeleteBuilding(row)">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="listQuery.pageNum" :limit.sync="listQuery.pageSize" @pagination="getList" />

    <el-dialog :title="textMap[dialogStatus]" :visible.sync="dialogInsertOrUpdateVisible">
      <el-form ref="insertForm" :rules="rules" :model="temp" label-position="left" label-width="120px" style="width: 400px; margin-left:50px;">
        <el-form-item label="building名称" prop="name">
          <el-input v-model="temp.name" placeholder="building名称" />
        </el-form-item>
        <el-form-item label="城市代码" prop="citycode">
          <el-input v-model="temp.citycode" placeholder="citycode" />
        </el-form-item>
        <el-form-item label="所在城市" prop="cityName">
          <el-input v-model="temp.cityName" placeholder="cityName" />
        </el-form-item>
        <el-form-item label="设备数量" prop="eqNum">
          <el-input v-model="temp.eqNum" placeholder="eqNum" type="number" />
        </el-form-item>
        <el-form-item label="优先级" prop="priority">
          <el-input v-model="temp.priority" placeholder="priority" type="number" />
        </el-form-item>
        <el-form-item label="纬度" prop="latitude">
          <el-input v-model="temp.latitude" placeholder="latitude" onkeyup="value=value.replace(/[^\d.]/g,'')" />
        </el-form-item>
        <el-form-item label="经度" prop="longitude">
          <el-input v-model="temp.longitude" placeholder="longitude" onkeyup="value=value.replace(/[^\d.]/g,'')" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" size="mini">
            <a href="https://a.amap.com/lbs/static/file/AMap_adcode_citycode.xlsx.zip">citycode编码表下载</a>
          </el-button>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogInsertOrUpdateVisible = false">
          取消
        </el-button>
        <el-button type="primary" @click="dialogStatus === 'create' ? createData(): updateData()">
          确定
        </el-button>
      </div>
    </el-dialog>

    <el-dialog :visible.sync="dialogStoreyVisible" title="detail">
      <el-table :data="storeyList" border fit highlight-current-row style="width: 100%">
        <el-table-column prop="name" label="洗手间名称" />
        <el-table-column prop="eqNum" label="数量" />
      </el-table>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="dialogStoreyVisible = false">确认</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { buildingList, buildingStoreyList, buildingInsert, buildingUpdate, buildingDelete } from '../../../api/building'
import Pagination from '../../../components/Pagination' // secondary package based on el-pagination
import store from '../../../store'

export default {
  name: 'BuildingTable',
  components: { Pagination },
  data() {
    return {
      tableKey: 0,
      list: null,
      total: 0,
      citycodeSet: new Set([]),
      storeyList: null,
      listLoading: true,
      listQuery: {
        pageNum: 1,
        pageSize: 10,
        adminId: this.$store.getters.id,
        name: undefined,
        citycode: undefined,
        cityName: undefined
      },
      rules: {
        name: [
          { required: true, message: 'name is required', trigger: 'change' }
        ],
        citycode: [
          { required: true, message: 'citycode is required', trigger: 'change' },
          { type: 'string', max: 10, message: 'citycode不能大于10位', trigger: 'blur' }
        ],
        cityName: [
          { required: true, message: 'cityName is required', trigger: 'change' }
        ]
      },
      temp: {},
      dialogInsertOrUpdateVisible: false,
      dialogStoreyVisible: false,
      textMap: {
        update: '编辑building信息',
        create: '新增building信息'
      },
      dialogStatus: ''
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.listLoading = true
      this.citycodeSet.clear()
      buildingList(this.listQuery).then(response => {
        this.list = response.data.list
        this.list.forEach(item => this.citycodeSet.add(item.citycode))
        this.total = response.data.total
        this.listLoading = false
      }).catch(() => {
        this.listLoading = false
      })
    },
    handleFilter() {
      this.listQuery.pageNum = 1
      this.getList()
    },
    handleEqNum(id) {
      buildingStoreyList({ id: id }).then(response => {
        this.storeyList = response.data
        this.dialogStoreyVisible = true
      })
    },
    handleUpdate(row) {
      console.log('start handleUpdate。。。。')
      this.temp.id = row.id
      this.temp.name = row.name
      this.temp.citycode = row.citycode
      this.temp.cityName = row.cityName
      this.temp.eqNum = row.eqNum
      this.temp.latitude = row.latitude
      this.temp.longitude = row.longitude
      this.temp.priority = row.priority
      this.dialogInsertOrUpdateVisible = true
      this.dialogStatus = 'update'
      this.$nextTick(() => {
        this.$refs['insertForm'].clearValidate()
      })
    },
    handleCreate() {
      this.temp = {
        citycode: '',
        name: '',
        cityName: '',
        priority: 0,
        eqNum: 0,
        latitude: '',
        longitude: ''
      }
      this.dialogInsertOrUpdateVisible = true
      this.dialogStatus = 'create'
      this.$nextTick(() => {
        this.$refs['insertForm'].clearValidate()
      })
    },
    doDeleteBuilding(row) {
      this.$confirm('确认删除？')
        .then(_ => {
          buildingDelete({ id: row.id }).then(response => {
            store.dispatch('building/getBuildingNum')
            this.$notify({
              title: '成功',
              message: response.msg,
              type: 'success',
              duration: 1500
            })
          })
          this.getList()
        })
        .catch(_ => {})
    },
    createData() {
      this.$refs['insertForm'].validate((valid) => {
        if (valid) {
          this.temp.adminId = this.$store.getters.id
          buildingInsert(this.temp).then(response => {
            store.dispatch('building/getBuildingNum')
            this.getList()
            this.$notify({
              title: '成功',
              message: response.msg,
              type: 'success',
              duration: 1500
            })
          })
          this.dialogInsertOrUpdateVisible = false
        } else {
          console.log('表单数据验证失败')
          this.$message({
            message: '请填写正确完整的表单',
            type: 'warning'
          })
        }
      })
    },
    updateData() {
      this.$refs['insertForm'].validate((valid) => {
        if (valid) {
          console.log('update building 参数: ' + JSON.stringify(this.temp))
          buildingUpdate(this.temp).then(response => {
            this.getList()
            this.$notify({
              title: '成功',
              message: response.msg,
              type: 'success',
              duration: 1500
            })
          })
          this.dialogInsertOrUpdateVisible = false
        } else {
          console.log('表单数据验证失败')
          this.$message({
            message: '请填写正确完整的表单',
            type: 'warning'
          })
        }
      })
    }
  }
}
</script>
