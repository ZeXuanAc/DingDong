<template>
  <div class="app-container">
    <div class="filter-container" style="margin-bottom: 18px">
      <el-select v-model="listQuery.buildingName" filterable placeholder="buildingName" clearable style="width: 200px" class="filter-item">
        <el-option v-for="item in buildingSet" :key="item.name" :label="item.name" :value="item.name" />
      </el-select>
      <el-input v-model="listQuery.name" placeholder="name" style="width: 150px;" class="filter-item" @keyup.enter.native="handleFilter" />
      <el-select v-model="listQuery.floor" filterable placeholder="floor" clearable style="width: 150px" class="filter-item">
        <el-option v-for="item in floorSet" :key="item" :label="item" :value="item" />
      </el-select>
      <el-select v-model="listQuery.gender" filterable placeholder="性别" clearable style="width: 150px" class="filter-item">
        <el-option label="男" value="1" />
        <el-option label="女" value="2" />
        <el-option label="不确定" value="0" />
      </el-select>
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
      <el-table-column label="洗手间名称" width="140" align="center">
        <template slot-scope="{row}">
          <span>{{ row.name }}</span>
        </template>
      </el-table-column>
      <el-table-column label="buildingName">
        <template slot-scope="{row}">
          <span>{{ row.buildingName }}</span>
        </template>
      </el-table-column>
      <el-table-column label="楼层" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.floor }}</span>
        </template>
      </el-table-column>
      <el-table-column label="性别" align="center">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.gender === '1'" type="primary">男</el-tag>
          <el-tag v-if="scope.row.gender === '2'" type="danger">女</el-tag>
          <el-tag v-if="scope.row.gender === '0'" type="warning">不确定</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="设备数" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.eqNum }}</span>
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
          <el-button size="mini" type="danger" icon="el-icon-circle-close-outline" @click="doDeleteStorey(row)">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="listQuery.pageNum" :limit.sync="listQuery.pageSize" @pagination="getList" />

    <el-dialog :title="textMap[dialogStatus]" :visible.sync="dialogInsertOrUpdateVisible">
      <el-form ref="insertForm" :rules="rules" :model="temp" label-position="left" label-width="120px" style="width: 400px; margin-left:50px;">
        <el-form-item label="洗手间名称" prop="name">
          <el-input v-model="temp.name" placeholder="洗手间名称" />
        </el-form-item>
        <el-form-item label="buildingName" prop="buildingName">
          <el-select v-model="temp.buildingName" filterable placeholder="buildingName" clearable class="filter-item">
            <el-option v-for="item in buildingSet" :key="item.name" :label="item.name" :value="item.name" />
          </el-select>
        </el-form-item>
        <el-form-item label="楼层" prop="floor">
          <el-input v-model="temp.floor" placeholder="所在楼层" />
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-select v-model="temp.gender" filterable placeholder="性别" clearable class="filter-item">
            <el-option label="男" value="1" />
            <el-option label="女" value="2" />
            <el-option label="不确定" value="0" />
          </el-select>
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
  </div>
</template>

<script>
import { storeyDtoInfo, storeyInsert, storeyUpdate, storeyDelete } from '../../../api/storey'
import { buildingList } from '../../../api/building'
import Pagination from '../../../components/Pagination' // secondary package based on el-pagination
import store from '../../../store'

export default {
  name: 'StoreyTable',
  components: { Pagination },
  data() {
    return {
      tableKey: 0,
      list: null,
      total: 0,
      buildingSet: new Set([]),
      floorSet: new Set([]),
      listLoading: true,
      listQuery: {
        pageNum: 1,
        pageSize: 10,
        adminId: this.$store.getters.id,
        name: undefined,
        buildingName: undefined,
        floor: undefined,
        gender: undefined
      },
      rules: {
        name: [
          { required: true, message: 'name is required', trigger: 'change' }
        ],
        buildingName: [
          { required: true, message: 'buildingName is required', trigger: 'change' }
        ],
        floor: [
          { required: true, message: 'floor is required', trigger: 'change' }
        ],
        latitude: [
          { required: true, message: 'latitude is required', trigger: 'change' }
        ],
        longitude: [
          { required: true, message: 'longitude is required', trigger: 'change' }
        ]
      },
      temp: {
        id: 0,
        name: '',
        buildingId: 0,
        buildingName: '',
        floor: '',
        gender: '',
        eqNum: 0,
        latitude: '',
        longitude: '',
        priority: 0
      },
      dialogInsertOrUpdateVisible: false,
      textMap: {
        update: '编辑storey信息',
        create: '新增storey信息'
      },
      dialogStatus: ''
    }
  },
  created() {
    console.log('storey index create。。。。')
    buildingList({ pageNum: 1, pageSize: 2147483647, adminId: this.$store.getters.id }).then(response => {
      response.data.list.forEach(item => this.buildingSet.add(item))
      this.getList()
    }).catch(e => {
      this.$message({
        message: '获取buildingSet失败',
        type: 'danger'
      })
    })
  },
  methods: {
    getList() {
      this.listLoading = true
      this.floorSet.clear()
      storeyDtoInfo(this.listQuery).then(response => {
        this.list = response.data.list
        this.list.forEach(item => this.floorSet.add(item.floor))
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
    handleUpdate(row) {
      console.log('start handleUpdate。。。。')
      this.temp.id = row.id
      this.temp.name = row.name
      this.temp.buildingId = row.buildingId
      this.temp.buildingName = row.buildingName
      this.temp.floor = row.floor
      this.temp.gender = row.gender
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
        buildingId: undefined,
        name: '',
        floor: '',
        gender: '',
        eqNum: 0,
        priority: 0,
        latitude: '',
        longitude: ''
      }
      this.dialogInsertOrUpdateVisible = true
      this.dialogStatus = 'create'
      this.$nextTick(() => {
        this.$refs['insertForm'].clearValidate()
      })
    },
    doDeleteStorey(row) {
      this.$confirm('确认删除？')
        .then(_ => {
          storeyDelete({ id: row.id }).then(response => {
            store.dispatch('storey/getStoreyNum')
            this.getList()
            this.$notify({
              title: '成功',
              message: response.msg,
              type: 'success',
              duration: 1500
            })
          })
        })
        .catch(_ => {})
    },
    createData() {
      this.$refs['insertForm'].validate((valid) => {
        if (valid) {
          this.temp.adminId = this.$store.getters.id
          this.setBuildingId(this.temp.buildingName)
          console.log('storey insert temp : ' + JSON.stringify(this.temp))
          storeyInsert(this.temp).then(response => {
            store.dispatch('storey/getStoreyNum')
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
    setBuildingId(buildingName) {
      this.buildingSet.forEach(item => {
        if (item.name === buildingName) {
          this.temp.buildingId = item.id
        }
      })
    },
    updateData() {
      this.$refs['insertForm'].validate((valid) => {
        if (valid) {
          console.log('update storey 参数: ' + JSON.stringify(this.temp))
          this.setBuildingId(this.temp.buildingName)
          storeyUpdate(this.temp).then(response => {
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
