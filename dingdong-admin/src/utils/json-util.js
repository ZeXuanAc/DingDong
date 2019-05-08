
export function strMapToJson(strMap) {
  const obj = Object.create(null)

  for (const [k, v] of strMap) {
    obj[k] = v
  }

  const JsonStr = JSON.stringify(obj)

  return JsonStr
}
