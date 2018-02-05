# KidRSA

After watching [How to Break Cryptography](https://www.youtube.com/watch?v=12Q3Mrh03Gk) and [This Video was Not Encrypted with RSA](https://www.youtube.com/watch?v=4Tb1q8dSIlI) my curiosity motivated me to demystify RSA cryptography.  Inspired by [Neal Koblitz](https://sites.math.washington.edu/~koblitz/)'s article [Cryptography As a Teaching Tool](https://sites.math.washington.edu/~koblitz/crlogia.html) this module was programmed following his 'Kid-RSA' example.

The beauty of this demonstration is the simplicity of arithmetic operations to encrypt and decrypt with a few computational steps.

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/marckassay/KidRSA/blob/master/LICENSE)  [![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/KidRSA/)

## Caveat

This is a demonstration, not suitable for production.

## Instructions

To install, run the following command in PowerShell.

```powershell
$ Install-Module KidRSA
```

## Usage

Copy-and-paste the first five lines of code into PowerShell after installing this module.  `Shift + Enter` to paste multiple lines of code such as below.  Use the `Up Arrow` to repeat previous command followed by an `Enter` and see that the generated RSA keys are different.  With a new generated set of (asymetric) keys will have a different encrypted value but the `ConvertTo-PlainText` function will output the same plain text value.

```powershell
C:\>
$AlicesKeys = Get-RSAKey -Verbose
$BobsCipherText = ConvertTo-CipherText 'BOB' -Verbose
$EncryptedMessage = ConvertTo-PublicEncryptionValue -CipherText $BobsCipherText -PublicKey $AlicesKeys.e -N $AlicesKeys.n -Verbose
$AlicesCipherText = ConvertTo-PrivateDecryptionValue -EncryptedCipherText $EncryptedMessage -PrivateKey $AlicesKeys.d -N $AlicesKeys.n -Verbose
ConvertTo-PlainText $AlicesCipherText -Verbose
VERBOSE: The value for 'a' is: 1
VERBOSE: The value for 'b' is: 58
VERBOSE: The value for 'a_' is: 35
VERBOSE: The value for 'b_' is: 62
VERBOSE: The value of Private key 'e' (encrypt) is: 1996
VERBOSE: The value of Public key 'd' (decrypt) is: 3592
VERBOSE: The value of 'n' is: 125783
VERBOSE: Ciphertext value is : 10410
VERBOSE: Encrypted cipher value is : 24165
VERBOSE: PlainTextValue value is : 10410
BOB
C:\>
```
