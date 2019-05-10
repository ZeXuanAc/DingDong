const getters = {
  sidebar: state => state.app.sidebar,
  device: state => state.app.device,
  id: state => state.user.id,
  token: state => state.user.token,
  avatar: state => state.user.avatar,
  name: state => state.user.name,
  roles: state => state.user.roles,
  userNum: state => parseInt(state.user.userNum),
  buildingNum: state => parseInt(state.building.buildingNum),
  storeyNum: state => parseInt(state.storey.storeyNum),
  equipmentNum: state => parseInt(state.equipment.equipmentNum),
  permission_routes: state => state.permission.routes
}
export default getters
