import prologue
import ../utils/host
import ../utils/vm

proc my*(ctx: Context) {.async.} =
    var res = %*
      {
        "total_cpu": getHostCpu(),
        "total_memory": getHostMemory(),
        "available_memory": getHostAvailMemory(),
        "vm_path": getHostVmPath(),

      }
    resp jsonResponse(res)

proc detail*(ctx: Context) {.async.} =
    let name = ctx.getPathParams("name", "")
    let vm = newVm(name)
    resp jsonResponse(%vm)

proc start*(ctx: Context) {.async.} =
    let id = ctx.getPathParams("id", "")
    var vm = Vm(name: id)
    vm.start()
    var res = %*
      {
        "total_cpu": vm.vcpu,
        "total_memory": vm.memory,
        "available_memory": vm.memory,
        "vm_path": vm.path,
        "id": vm.state
      }
    resp jsonResponse(res)
