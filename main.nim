import json
import std/with
import prologue
from prologue/middlewares/staticfile import staticFileMiddleware
from prologue/openapi import serveDocs

import views/dashboard
import views/vm



let
  env = loadPrologueEnv(".env")
  settings = newSettings(appName = env.getOrDefault("appName", "Digipud"),
                         debug = env.getOrDefault("debug", true),
                         address = env.getOrDefault("address", ""),
                         port = Port(env.getOrDefault("port", 2107)),
                         secretKey = env.getOrDefault("secretKey", "nguk")
    )

var 
  app = newApp(settings=settings)
  vm_route = newGroup(app, "/vm", @[])

with vm_route:
  get("/", vm.my)

app.use(staticFileMiddleware(env.getOrDefault("staticDir", "static/")))
app.get("/", dashboard.home)
app.get("/dashboard", dashboard.index)
app.serveDocs("docs/openapi.json")
app.run()
