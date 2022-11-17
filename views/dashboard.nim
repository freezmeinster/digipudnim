import prologue
import strutils
import ../utils/host

proc home*(ctx: Context) {.async.} =
    await ctx.staticFileResponse("static/index.html", "")


proc index*(ctx: Context) {.async.} =
    let totalMem = getHostMemory()
    let availMem = getHostAvailMemory()
    var res = %*
      {
        "total_cpu": getHostCpu(),
        "vm": {
          "total": 12,
          "running": 4,
          "off": 9,
        },
        "memory": {
          "total_int": totalMem,
          "available_int": availMem,
          "total_str": totalMem.formatSize(),
          "available_str": availMem.formatSize(),
          "percent": ((availMem / totalMem ) * 100).int
        },
        "vm_path": getHostVmPath(),

      }
    resp jsonResponse(res)
