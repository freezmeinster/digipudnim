import osproc
import strformat
import strutils
import tables

proc getSysctlInt*(key: string): int =
  let output = execProcess(fmt"sysctl -n {key}")
  return parseInt(strip(output))

proc getConfig*(path: string): Table[string, string] = 
  let 
    rcconf = open(path)
  var
    conf = initTable[string, string]()

  defer: rcconf.close()
  for ctn in rcconf.lines:
    if ctn.startsWith("#") == false:
      let cot = ctn.split("=")
      if len(cot) == 2:
        conf[cot[0]] = cot[1].replace("\"", "")
  return conf


proc getRcConfItem*(key: string): string =
  let conf = getConfig("/etc/rc.conf")
  return conf.getOrDefault(key, "")
