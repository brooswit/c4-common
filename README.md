# CCC

ComputerCraftCode, a ComputerCraft dependancy manager

## Getting Started

1. Open a brand-new computer. You should see a command-line interface.
2. Type `edit bootstrap.lua`. You should be taken to a text editor.
3. Copy/paste the following into the text editor:

```
local request = http.get("https://raw.githubusercontent.com/brooswit/ccc/master/startup.lua")
local file = fs.open("startup.lua", "w")
file.write(request.readAll())
file.close()
os.loadAPI("startup.lua")
```

* Note, you may need to copy/paste the code one line at a time, unfortunately.

4. Press `ctrl`. You should see `Save` and `Exit` along the bottom.
5. Make sure `Save` is selected and press the `enter` key. This will save the file.
6. Press `ctrl` again, and select Exit. You should now be taken back to the command-line interface.
7. Type `bootstrap`. This will get CCC installed.

## Usage

`ccc`

Downloads and updates all dependencies in `ccconfig.json`

`ccc install`

## Configuration
