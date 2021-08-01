import common
import zfs
import strutils

proc getHostMemory*(): int = 
  return getSysctlInt("hw.physmem")

proc getHostAvailMemory*(): int =
  let pgsize = getSysctlInt("hw.pagesize")
  let inactive = getSysctlInt("vm.stats.vm.v_inactive_count") * pgsize
  let cache = getSysctlInt("vm.stats.vm.v_cache_count") * pgsize
  let free = getSysctlInt("vm.stats.vm.v_free_count") * pgsize
  return inactive + cache + free

proc getHostCpu*(): int =
  return getSysctlInt("hw.ncpu")

proc getHostVmPath*(): string =
  if getRcConfItem("vm_enable").toLowerAscii().contains("yes"):
    let vm_dir = getRcConfItem("vm_dir")
    if vm_dir.contains("zfs"):
      let dataset = vm_dir.split(":")[1]
      return getZFSPropertyStr(dataset, "mountpoint")
  else:
    return ""


