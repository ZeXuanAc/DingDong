<template>
  <div class="app-container">
    <div class="filter-container" style="margin-bottom: 18px">
      <el-select v-model="listQuery.buildingName" filterable placeholder="buildingName" clearable style="width: 200px" class="filter-item">
        <el-option v-for="item in buildingSet" :key="item" :label="item" :value="item" />
      </el-select>
      <el-select v-model="listQuery.storeyName" filterable placeholder="洗手间名称" clearable style="width: 200px" class="filter-item">
        <el-option v-for="item in storeySet" :key="item.name" :label="item.name" :value="item.name" />
      </el-select>
      <el-input v-model="listQuery.eqName" placeholder="设备名称" style="width: 150px;" class="filter-item" @keyup.enter.native="handleFilter" />
      <el-select v-model="listQuery.floor" filterable placeholder="楼层" clearable style="width: 100px" class="filter-item">
        <el-option v-for="item in floorSet" :key="item" :label="item" :value="item" />
      </el-select>
      <el-select v-model="listQuery.condition" filterable placeholder="状态" clearable style="width: 120px" class="filter-item">
        <el-option label="正常" value="1" />
        <el-option label="维护中" value="0" />
      </el-select>
      <el-select v-model="listQuery.storeyGender" filterable placeholder="性别" clearable style="width: 120px" class="filter-item">
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
      <el-table-column label="设备名称" width="80" align="center">
        <template slot-scope="{row}">
          <span>{{ row.eqName }}</span>
        </template>
      </el-table-column>
      <el-table-column label="洗手间名称" width="140" align="center">
        <template slot-scope="{row}">
          <span>{{ row.storeyName }}</span>
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
      <el-table-column label="状况" align="center">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.condition === '1'" type="primary">正常</el-tag>
          <el-tag v-if="scope.row.condition === '0'" type="warning">维护中</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="洗手间性别" align="center">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.storeyGender === '1'" type="primary">男</el-tag>
          <el-tag v-if="scope.row.storeyGender === '2'" type="danger">女</el-tag>
          <el-tag v-if="scope.row.storeyGender === '0'" type="warning">不确定</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="优先级" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.priority }}</span>
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
          <el-button size="mini" type="danger" icon="el-icon-circle-close-outline" @click="doDelete(row)">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="listQuery.pageNum" :limit.sync="listQuery.pageSize" @pagination="getList" />

    <el-dialog :title="textMap[dialogStatus]" :visible.sync="dialogInsertOrUpdateVisible">
      <el-form ref="insertForm" :rules="rules" :model="temp" label-position="left" label-width="120px" style="width: 400px; margin-left:50px;">
        <el-form-item label="设备名称" prop="eqName">
          <el-input v-model="temp.eqName" placeholder="设备名称" />
        </el-form-item>
        <el-form-item label="洗手间名称" prop="storeyName">
          <el-select v-model="temp.storeyName" filterable placeholder="洗手间名称" clearable class="filter-item">
            <el-option v-for="item in storeySet" :key="item.name" :label="item.name" :value="item.name" />
          </el-select>
        </el-form-item>
        <el-form-item label="状况" prop="condition">
          <el-select v-model="temp.condition" filterable placeholder="状态" clearable style="width: 150px" class="filter-item">
            <el-option label="正常" value="1" />
            <el-option label="维护中" value="0" />
          </el-select>
        </el-form-item>
        <el-form-item label="优先级" prop="priority">
          <el-input v-model="temp.priority" placeholder="priority" type="number" />
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
import { equipmentDtoInfo, equipmentInsert, equipmentUpdate, equipmentDelete } from '../../../api/equipment'
import { storeyDtoInfo } from '../../../api/storey'
import Pagination from '../../../components/Pagination' // secondary package based on el-pagination
import store from '../../../store'

export default {
  name: 'EquipmentTable',
  components: { Pagination },
  data() {
    return {
      tableKey: 0,
      list: null,
      total: 0,
      buildingSet: new Set([]),
      storeySet: new Set([]),
      floorSet: new Set([]),
      listLoading: true,
      listQuery: {
        pageNum: 1,
        pageSize: 50,
        adminId: this.$store.getters.id,
        eqName: '',
        storeyName: '',
        buildingName: '',
        floor: '',
        condition: '',
        storeyGender: undefined
      },
      rules: {
        eqName: [
          { required: true, message: 'name is required', trigger: 'change' }
        ]
      },
      temp: {
        eqId: 0,
        eqName: '',
        storeyId: 0,
        storeyName: '',
        buildingName: '',
        condition: '',
        priority: 0
      },
      dialogInsertOrUpdateVisible: false,
      textMap: {
        update: '编辑equipment信息',
        create: '新增equipment信息'
      },
      dialogStatus: ''
    }
  },
  created() {
    console.log('equipment index create。。。。')
    storeyDtoInfo({ pageNum: 1, pageSize: 2147483647, adminId: this.$store.getters.id }).then(response => {
      response.data.list.forEach(item => this.storeySet.add(item))
      this.getList()
    }).catch(e => {
      this.$message({
        message: '获取storeySet失败',
        type: 'danger'
      })
    })
  },
  methods: {
    getList() {
      this.listLoading = true
      this.floorSet.clear()
      this.buildingSet.clear()
      equipmentDtoInfo(this.listQuery).then(response => {
        this.list = response.data.list
        this.list.forEach(item => this.buildingSet.add(item.buildingName))
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
      this.temp.eqId = row.eqId
      this.temp.eqName = row.eqName
      this.temp.storeyId = row.storeyId
      this.temp.storeyName = row.storeyName
      this.temp.condition = row.condition
      this.temp.priority = row.priority
      this.dialogInsertOrUpdateVisible = true
      this.dialogStatus = 'update'
      this.$nextTick(() => {
        this.$refs['insertForm'].clearValidate()
      })
    },
    handleCreate() {
      this.temp = {
        storeyId: undefined,
        eqName: '',
        storeyName: '',
        condition: '',
        priority: 0
      }
      this.dialogInsertOrUpdateVisible = true
      this.dialogStatus = 'create'
      this.$nextTick(() => {
        this.$refs['insertForm'].clearValidate()
      })
    },
    doDelete(row) {
      this.$confirm('确认删除？')
        .then(_ => {
          equipmentDelete({ eqId: row.eqId }).then(response => {
            store.dispatch('equipment/getEquipmentNum')
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
          this.setStoreyId(this.temp.storeyName)
          console.log('equipment insert temp : ' + JSON.stringify(this.temp))
          equipmentInsert(this.temp).then(response => {
            store.dispatch('equipment/getEquipmentNum')
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
    setStoreyId(storeyName) {
      this.storeySet.forEach(item => {
        if (item.name === storeyName) {
          this.temp.storeyId = item.id
        }
      })
    },
    updateData() {
      this.$refs['insertForm'].validate((valid) => {
        if (valid) {
          console.log('update storey 参数: ' + JSON.stringify(this.temp))
          this.setStoreyId(this.temp.storeyName)
          equipmentUpdate(this.temp).then(response => {
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
