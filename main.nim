import prologue
import json
import std/with
import views/dashboard
import views/vm

from prologue/openapi import serveDocs


let
  env = loadPrologueEnv(".env")
  settings = newSettings(appName = env.getOrDefault("appName", "Digipud"),
                         debug = env.getOrDefault("debug", true),
                         address = env.getOrDefault("address", ""),
                         port = Port(env.getOrDefault("port", 2107)),
                         secretKey = env.getOrDefault("secretKey", "nguk")
    )
  app = newApp(settings=settings)
  vm_route = newGroup(app, "/vm", @[])

with vm_route:
  get("/", vm.my)

app.get("/", dashboard.index)
app.serveDocs("docs/openapi.json")
app.run()
