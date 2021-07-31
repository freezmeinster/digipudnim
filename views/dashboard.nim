import prologue
import ../utils/host

proc index*(ctx: Context) {.async.} =
    var res = %*
      {
        "total_cpu": getHostCpu(),
        "total_memory": getHostMemory(),
        "available_memory": getHostAvailMemory(),
        "vm_path": getHostVmPath(),

      }
    resp jsonResponse(res)
