using Pkg; Pkg.activate(".")
using Toolips
using ToolipsSession
using AllExtensions

IP = "127.0.0.1"
PORT = 8000
extensions = [Logger(), Files("public"), Session()]
AllExtensionsServer = AllExtensions.start(IP, PORT, extensions)
