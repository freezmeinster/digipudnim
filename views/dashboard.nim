import prologue
import strutils
import ../utils/host

proc home*(ctx: Context) {.async.} =
    await ctx.staticFileResponse("static/index.html", "")


proc index*(ctx: Context) {.async.} =
    let total_mem = getHostMemory()
    let avail_mem = getHostAvailMemory()
    var res = %*
      {
        "total_cpu": getHostCpu(),
        "vm": {
          "total": 12,
          "running": 4,
          "off": 9,
        },
        "memory": {
          "total_int": total_mem,
          "available_int": avail_mem,
          "total_str": total_mem.formatSize(),
          "available_str": avail_mem.formatSize(),
          "percent": ((avail_mem / total_mem ) * 100).int
        },
        "vm_path": getHostVmPath(),

      }
    resp jsonResponse(res)
