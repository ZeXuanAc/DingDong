<template>
  <div class="app-container">
    <el-form ref="form" :rules="rules" :model="form" label-width="120px">
      <el-form-item label="设备名称" prop="eqName">
        <el-input v-model="form.eqName" style="width: 300px" />
      </el-form-item>
      <el-form-item label="citycode" prop="citycode">
        <el-input v-model="form.citycode" style="width: 300px" />
      </el-form-item>
      <el-form-item label="城市名称" prop="cityName">
        <el-input v-model="form.cityName" style="width: 500px" />
      </el-form-item>
      <el-form-item label="buildingName" prop="buildingName">
        <el-input v-model="form.buildingName" style="width: 500px" />
      </el-form-item>
      <el-form-item label="洗手间名称" prop="storeyName">
        <el-input v-model="form.storeyName" style="width: 500px" />
      </el-form-item>
      <el-form-item label="所在楼层" prop="floor">
        <el-input v-model="form.floor" style="width: 300px" />
      </el-form-item>
      <el-form-item label="洗手间性别" style="width: 300px" prop="storeyGender">
        <el-select v-model="form.storeyGender" filterable placeholder="性别" clearable class="filter-item">
          <el-option label="男" value="1" />
          <el-option label="女" value="2" />
          <el-option label="不确定" value="0" />
        </el-select>
      </el-form-item>
      <el-form-item label="纬度" prop="latitude">
        <el-input v-model="form.latitude" style="width: 300px" />
      </el-form-item>
      <el-form-item label="经度" prop="longitude">
        <el-input v-model="form.longitude" style="width: 300px" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">Create</el-button>
        <el-button @click="onCancel">Cancel</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import { equipmentInit } from '../../api/equipment'
import store from '../../store'
export default {
  data() {
    return {
      rules: {
        eqName: [
          { required: true, message: '请输入设备名称', trigger: 'change' },
          { type: 'string', max: 50, message: '设备名称不能大于50位', trigger: 'blur' }
        ],
        citycode: [
          { required: true, message: 'citycode is required', trigger: 'change' },
          { type: 'string', max: 10, message: 'citycode不能大于10位', trigger: 'blur' }
        ],
        cityName: [
          { required: true, message: '请输入城市名称', trigger: 'change' }
        ],
        buildingName: [
          { required: true, message: '请输入buildingName', trigger: 'change' },
          { type: 'string', max: 100, message: 'buildingName不能大于100位', trigger: 'blur' }
        ],
        storeyName: [
          { required: true, message: '请输入洗手间', trigger: 'change' },
          { type: 'string', max: 50, message: '设备名称不能大于50位', trigger: 'blur' }
        ],
        floor: [
          { required: true, message: 'floor is required', trigger: 'change' },
          { type: 'string', max: 10, message: 'floor不能大于10位', trigger: 'blur' }
        ],
        storeyGender: [
          { required: true, message: 'gender is required', trigger: 'change' }
        ],
        latitude: [
          { required: true, message: 'latitude is required', trigger: 'change' },
          { type: 'string', max: 30, message: '纬度不能大于30位', trigger: 'blur' }
        ],
        longitude: [
          { required: true, message: 'longitude is required', trigger: 'change' },
          { type: 'string', max: 30, message: '经度不能大于30位', trigger: 'blur' }
        ]
      },
      form: {
        eqName: '',
        citycode: '',
        cityName: '',
        province: '',
        buildingName: '',
        storeyName: '',
        floor: '',
        storeyGender: '',
        latitude: '',
        longitude: ''
      }
    }
  },
  methods: {
    onSubmit() {
      this.$refs['form'].validate((valid) => {
        if (valid) {
          equipmentInit(this.form).then(response => {
            store.dispatch('equipment/getEquipmentNum')
            this.$notify({
              title: '成功',
              message: response.msg,
              type: 'success',
              duration: 1500
            })
          })
        } else {
          console.log('表单数据验证失败')
          this.$message({
            message: '请填写正确完整的表单',
            type: 'warning'
          })
        }
      })
    },
    onCancel() {
      this.$message({
        message: 'cancel!',
        type: 'warning'
      })
    }
  }
}
</script>

<style scoped>
.line{
  text-align: center;
}
</style>

