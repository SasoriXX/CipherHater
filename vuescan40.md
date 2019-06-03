---
title: "VueScan"
permalink: vuescan40/
---

# [Valid license for VueScan 9 x64]()

<center>
	<p><b>
		For version v9.6.38/39/40 and only for Linux x86_64
	</b></p>
</center>

#### License key required: YES

---

![VUESCAN](images/vuescan_40.jpg)


## [Detailed explanation]()


**License key for 9.6.38/39/40 Professional**


- [DOWNLOAD LICENSE FILE 1](orig/license1/vuescanrc)

- [DOWNLOAD LICENSE FILE 2](orig/license2/vuescanrc)


- If you have previously installed this program with a license,
  **remove the file** `/home/<user>/.vuescanrc`

- Copy file `vuescanrc` to path `/home/<user>`
  and rename to name `.vuescanrc`

---

#### [First Step:]()

- [DOWNLOAD ORIGINAL VUESCAN v9.6.38](orig/vuex6496_9638.tgz)

- [DOWNLOAD ORIGINAL VUESCAN v9.6.39](orig/vuex6496_9639.tgz)

- [DOWNLOAD ORIGINAL VUESCAN v9.6.40](orig/vuex6496_9640.tgz)

Unzip the package to `/home/<user>/VueScan`:

```
$ tar zxf vuex6496_<version>.tgz
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
