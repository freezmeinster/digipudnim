import ../utils/host
import ../utils/common
import tables
import os
import nre
import strutils

type
  Vm* = object
    name*: string
    path*: string
    loader*: string
    datastore*: string
    memory*: int
    vnc*: int
    vcpu*: int
    autostart*: bool
    state*: string
    conf*: Table[string, string]

proc parseMemString(mem: string): int =
  let lowmem = mem.toLowerAscii()  
  var 
    match = lowmem.match(re"(?P<val>[\d+]*)(?P<pred>[k,m,g,t])")
    prd: string
    val: string
  if match.isNone:
    match = lowmem.match(re"(?P<val>[\d+]*)")
    prd = ""
    val = match.get.captures["val"]
  else:
    prd = match.get.captures["pred"]
    val = match.get.captures["val"]
  let 
    valInt = parseInt(strip(val))
    vactor = case prd:
    of "k":
       1024
    of "m":
      1024 * 1024
    of "g":
      1024 * 1024 * 1024
    of "t":
      1024 * 1024 * 1024
    else:
      1024 * 1024
  return vactor * valInt

proc parseVnc(vm: var Vm) =
  let consolePath = vm.path & "/console"
  vm.vnc = 0
  if fileExists(consolePath):
    let cslConf = getConfig(consolePath)
    let vnc = cslConf.getOrDefault("vnc", "")
    if vnc != "":
      let port = vnc.split(":")[1]
      vm.vnc = parseInt(port)

proc parseConfig(vm: var Vm) =
  let confPath = vm.path & "/" & vm.name & ".conf"
  if fileExists(confPath):
    let conf = getConfig(confPath)
    vm.memory = parseMemString(strip(conf.getOrDefault("memory", "0G")))
    vm.vcpu = parseInt(strip(conf.getOrDefault("cpu", "0")))
    vm.loader = conf.getOrDefault("loader", "bhyveload")
    vm.conf = conf
    vm.parseVnc()


proc newVm*(name: string): Vm =
  let vmBasePath = getHostVmPath()
  let vmPath = vmBasePath & "/" & name
  var vm = Vm(name: name, path: vmPath)
  vm.parseConfig()
  return vm
  

proc start*(vm: var Vm) =
  vm.state = "started"

proc stop*(vm: var Vm) =
  vm.state = "stoped"
