import prologue
import json
import utils/host

from prologue/openapi import serveDocs

proc dashboard*(ctx: Context) {.async.} =
    var res = %*
      {
        "total_cpu": getHostCpu(),
        "total_memory": getHostMemory(),
        "available_memory": getHostAvailMemory(),
        "vm_path": getHostVmPath(),

      }
    resp jsonResponse(res)

let
  env = loadPrologueEnv(".env")
  settings = newSettings(appName = env.getOrDefault("appName", "Prologue"),
                         debug = env.getOrDefault("debug", true),
                         address = env.getOrDefault("address", ""),
                         port = Port(env.getOrDefault("port", 8080)),
                         secretKey = env.getOrDefault("secretKey", "nguk")
    )


let app = newApp(settings=settings)
app.get("/", dashboard)
app.serveDocs("docs/openapi.json")
app.run()
