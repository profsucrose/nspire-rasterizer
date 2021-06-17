# nspire-rasterizer

Lua script for rasterizing OBJ files on the TI-Nspire

## Screenshots
<image src="screenshots/bust.png">
<image src="screenshots/teapot.png">

## Usage

IO on the Nspire is a bit abysmal and a mess, so therefore I hackily inject an OBJ in Lua's table format using a Bash script

To generate a script for rendering a given obj file, run 
```bash
./gen_script.sh [name of file containing OBJ in Lua table without the extension]
```

e.g., to generate a script for rendering the OBJ in `bust.txt` run `./gen_script.sh bust`