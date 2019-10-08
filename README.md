collection of computercraft programs and APIs

To get started, create and run this script:
```
local request = http.get("https://raw.githubusercontent.com/brooswit/ccc/master/startup")
local file = fs.open("startup", "w")
file.write(request.readAll())
file.close()
```

Computercraft supports pasting using `ctrl+v`, but its a little funky.

If you hit `ctrl` while editing you will bring up the option to save or quit.
If you hit `ctrl` again it will bring you back to edit mode.
So if you press `ctrl` to bring up the options, then press and hold `ctrl` then press `v` you can paste.
You can only paste one line at a time.