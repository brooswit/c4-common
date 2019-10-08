collection of computercraft programs and APIs

To get started, create and run this script:
```
local request = http.get("https://raw.githubusercontent.com/brooswit/ccc/master/startup")
local file = fs.open("startup", "w")
file.write(request.readAll())
file.close()
```
