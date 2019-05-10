<template>
  <div class="app-container">
    <div class="filter-container" style="margin-bottom: 18px">
      <el-select v-model="listQuery.citycode" filterable placeholder="citycode" clearable style="width: 150px" class="filter-item">
        <el-option v-for="item in list" :key="item.citycode" :label="item.citycode" :value="item.citycode" />
      </el-select>
      <el-input v-model="listQuery.name" placeholder="cityName" style="width: 150px;" class="filter-item" @keyup.enter.native="handleFilter" />
      <el-input v-model="listQuery.province" placeholder="province" style="width: 150px;" class="filter-item" @keyup.enter.native="handleFilter" />
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
      <el-table-column label="citycode" width="120">
        <template slot-scope="{row}">
          <span>{{ row.citycode }}</span>
        </template>
      </el-table-column>
      <el-table-column width="200px" label="name">
        <template slot-scope="{row}">
          <span>{{ row.name }}</span>
        </template>
      </el-table-column>
      <el-table-column label="province" align="center">
        <template slot-scope="scope">
          <span>{{ scope.row.province }}</span>
        </template>
      </el-table-column>
      <el-table-column label="优先级">
        <template slot-scope="{row}">
          <template v-if="row.edit">
            <el-input v-model="row.priority" size="mini" type="number" />
            <el-button class="cancel-btn" size="mini" icon="el-icon-refresh" type="warning" @click="cancelEdit(row)">
              cancel
            </el-button>
          </template>
          <span v-else>{{ row.priority }}</span>
        </template>
      </el-table-column>
      <el-table-column label="最近更新时间" align="center" width="200px">
        <template slot-scope="scope">
          <span>{{ scope.row.updateTime }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="230" class-name="small-padding fixed-width">
        <template slot-scope="{row}">
          <el-button v-if="row.edit" type="success" size="mini" icon="el-icon-circle-check-outline" @click="confirmEdit(row)">
            Ok
          </el-button>
          <el-button v-else type="primary" size="mini" icon="el-icon-edit" @click="row.edit=!row.edit">
            Edit
          </el-button>
          <el-button size="mini" type="danger" icon="el-icon-circle-close-outline" @click="doDeleteCity(row)">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.pageNum" :limit.sync="listQuery.pageSize" @pagination="getList" />

    <el-dialog title="新增city" :visible.sync="dialogInsertVisible">
      <el-form ref="insertForm" :rules="rules" :model="temp" label-position="left" label-width="70px" style="width: 400px; margin-left:50px;">
        <el-form-item label="name" prop="name">
          <el-input v-model="temp.name" placeholder="城市名称" />
        </el-form-item>
        <el-form-item label="citycode" prop="citycode">
          <el-input v-model="temp.citycode" placeholder="城市代码" />
        </el-form-item>
        <el-form-item label="province" prop="province">
          <el-input v-model="temp.province" placeholder="所在城市" />
        </el-form-item>
        <el-form-item label="priority" prop="priority">
          <el-input v-model="temp.priority" placeholder="优先级" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" size="mini">
            <a href="https://a.amap.com/lbs/static/file/AMap_adcode_citycode.xlsx.zip">citycode编码表下载</a>
          </el-button>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogInsertVisible = false">
          取消
        </el-button>
        <el-button type="primary" @click="createData()">
          确定
        </el-button>
      </div>
    </el-dialog>

    <!--<el-dialog :visible.sync="dialogDeleteVisible" title="确定删除吗？">-->
      <!--<div slot="footer" class="dialog-footer" style="width: 300px;">-->
        <!--<el-button @click="dialogDeleteVisible = false">-->
          <!--取消-->
        <!--</el-button>-->
        <!--<el-button type="danger" @click="deleteData()">-->
          <!--确定-->
        <!--</el-button>-->
      <!--</div>-->
    <!--</el-dialog>-->
  </div>
</template>

<script>
import { cityInfo, cityInsert, cityUpdate, cityDelete } from '../../api/city'
import Pagination from '../../components/Pagination' // secondary package based on el-pagination

export default {
  name: 'CityTable',
  components: { Pagination },
  data() {
    return {
      tableKey: 0,
      list: null,
      total: 0,
      listLoading: true,
      listQuery: {
        pageNum: 1,
        pageSize: 20,
        name: undefined,
        citycode: undefined,
        province: undefined
      },
      rules: {
        name: [
          { required: true, message: 'name is required', trigger: 'change' }
        ],
        citycode: [
          { required: true, message: 'citycode is required', trigger: 'change' },
          { type: 'string', max: 10, message: 'citycode不能大于10位', trigger: 'blur' }
        ]
      },
      temp: {},
      dialogDeleteVisible: false,
      dialogInsertVisible: false
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.listLoading = true
      cityInfo(this.listQuery).then(response => {
        this.list = response.data.list.map(v => {
          this.$set(v, 'edit', false) // https://vuejs.org/v2/guide/reactivity.html
          v.originalPriority = v.priority //  will be used when user click the cancel botton
          return v
        })
        this.total = response.data.total
        this.listLoading = false
      })
    },
    handleFilter() {
      this.listQuery.page = 1
      this.getList()
    },
    handleCreate() {
      this.temp = {
        citycode: '',
        name: '',
        province: '',
        priority: 0
      }
      this.dialogInsertVisible = true
      this.$nextTick(() => {
        this.$refs['insertForm'].clearValidate()
      })
    },
    doDeleteCity(row) {
      this.$confirm('确认删除？')
        .then(_ => {
          cityDelete({ citycode: row.citycode }).then(response => {
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
          console.log('验证通过')
          cityInsert(this.temp).then(response => {
            this.getList()
            this.$notify({
              title: '成功',
              message: response.msg,
              type: 'success',
              duration: 1500
            })
          })
          this.dialogInsertVisible = false
        } else {
          console.log('表单数据验证失败')
          this.$message({
            message: '请填写正确完整的表单',
            type: 'warning'
          })
        }
      })
    },
    cancelEdit(row) {
      row.priority = row.originalPriority
      row.edit = false
      this.$message({
        message: 'The title has been restored to the original value',
        type: 'warning'
      })
    },
    confirmEdit(row) {
      row.edit = false
      cityUpdate({ id: row.id, citycode: row.citycode, priority: row.priority }).then(response => {
        row.originalPriority = row.priority
        this.$notify({
          title: '成功',
          message: response.msg,
          type: 'success',
          duration: 1500
        })
      }).catch(e => {
        row.priority = row.originalPriority
      })
    }
  }
}
</script>
