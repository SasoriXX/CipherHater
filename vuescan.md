---
title: "VueScan"
permalink: vuescan/
---

# [Script for patching VueScan 9 x64]()

<center>
	<p><b>
		Only for version v9.6.38/v9.6.39 and only for Linux x86_64
	</b></p>
</center>

#### License key required: NO

---

![VUESCAN](images/vuescan.jpg)


## [Detailed explanation]()

```
Since now the license key is not needed and is not used by the program, 
it is not possible to send scanned images the e-mail via the VueScan
interface, due to the not present of the sender's address that is in the
licenses when purchasing the program.
```

---

#### [First Step:]()
 
- [DOWNLOAD MAGIC SCRIPT](https://raw.githubusercontent.com/cipherhater/CipherHater/master/vuescan_patch.sh)

- [DOWNLOAD ORIGINAL VUESCAN v9.6.38](orig/vuex6496_9638.tgz)

- [DOWNLOAD ORIGINAL VUESCAN v9.6.39](orig/vuex6496_9639.tgz)

Unzip the package to `/home/<user>/VueScan`:

```
$ tar zxf vuex6496_<version>.tgz
```

- If you have previously installed this program with a license,
  **remove the file** `/home/<user>/.vuescanrc`


#### How to patch the executable? Copy/Paste this script and run:

```bash
$ sudo chmod +x ./vuescan_patch.sh
$ sudo ./vuescan_patch.sh
```

---

#### [Second Step:]()

 - ```$ sudo nano /etc/hosts``` (you can use other text editor)

Entries REMOVE from /etc/hosts:

```
 hamrick.com
 www.hamrick.com
 static.hamrick.com
 stats.hamrick.com
```
 
Click Enter to save file
 
**You can not add *hamrick* hosts to the hosts file!**

**The VueScan program parses /etc/host for the presence of their hosts in the file!**

---

#### [Third Step:]()


```bash
$ sudo apt install firejail
```

 **Start VueScan command**

```bash
$ firejail --dns=10.10.10.10  ~/VueScan/vuescan
```

---

 Run VueScan & appreciate the magic ^^

## [Discussion and thanks here](https://gist.github.com/cipherhater/4e75d4e4551db171de03e9618456a7ea)

<center>
    <p><b>
	"We do not pay for programs that you do not know how to protect..." &copy; CipherHater
    </b></p>
</center>

<center>
    <p>
	Copyright &copy; 2019 CipherHater All rights reserved.
    </p>
</center>
