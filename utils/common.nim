import osproc
import strformat
import strutils
import tables

proc getSysctlInt*(key: string): int =
  let output = string(execProcess(fmt"sysctl -n {key}"))
  return parseInt(strip(output))

proc getRcConfItem*(key: string): string =
  let 
    rcconf = open("/etc/rc.conf")
    conf = newTable[string, string]()

  defer: rcconf.close()
  for ctn in rcconf.lines:
    if ctn.startsWith("#") == false:
      let cot = ctn.split("=")
      if len(cot) == 2:
        conf[cot[0]] = cot[1].replace("\"", "")

  return conf.getOrDefault(key, "")
