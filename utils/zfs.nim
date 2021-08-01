import osproc
import strformat
import strutils

proc getZFSProperty(dataset: string, prop: string): string = 
  var output = execProcess(fmt"zfs get -H -o value {prop} {dataset}").string
  stripLineEnd(output)
  return output

proc getZFSPropertyInt*(dataset: string, prop: string): int =
  return parseInt(getZFSProperty(dataset, prop))

proc getZFSPropertyStr*(dataset: string, prop: string): string = 
  return getZFSProperty(dataset, prop)


