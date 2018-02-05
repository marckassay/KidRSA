# KidRSA

After watching [How to Break Cryptography](https://www.youtube.com/watch?v=12Q3Mrh03Gk) and [This Video was Not Encrypted with RSA](https://www.youtube.com/watch?v=4Tb1q8dSIlI) my curiosity motivated me to demystify RSA cryptography.  Inspired by [Neal Koblitz](https://sites.math.washington.edu/~koblitz/)'s article [Cryptography As a Teaching Tool](https://sites.math.washington.edu/~koblitz/crlogia.html) I programmed this module following his 'Kid-RSA' example.

The beauty of this demonstration is the simplicity of arithmetic operations to encrypt and decrypt effortlessly.

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/marckassay/KidRSA/blob/master/LICENSE)  [![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/KidRSA/)

## Caveat

This is a demonstration, not suitable for production.

## Instructions

To install, run the following command in PowerShell.

```powershell
$ Install-Module KidRSA
```

## Usage

Copy-and-paste the first five lines of code into PowerShell after installing this module.  `Shift + Enter` to paste multiple lines of code such as below.  Use the `Up Arrow` to repeat previous command and see that the RSA key changes.  With a new generated set of (asymetric) keys will have a different encrypted value but the `ConvertTo-PlainTextValue` function will output the same value.

```powershell
C:\>
 $AlicesKeys = Get-RSAKey -Verbose
 $BobsCipheredText = ConvertTo-CipheredTextValue 'BOB' -Verbose
 $EncryptedMessage = ConvertTo-PublicEncryptionValue -CipherText $BobsCipheredText -PublicKey $AlicesKeys.e -N $AlicesKeys.n -Verbose
 $AlicesCipheredText = ConvertTo-PrivateDecryptionValue -EncryptedCipherText $EncryptedMessage -PrivateKey $AlicesKeys.d -N $AlicesKeys.n -Verbose
 ConvertTo-PlainTextValue $AlicesCipheredText -Verbose
VERBOSE: The value for 'a' is: 80
VERBOSE: The value for 'b' is: 2
VERBOSE: The value for 'a_' is: 48
VERBOSE: The value for 'b_' is: 26
VERBOSE: The value of Private key 'e' (encrypt) is: 7712
VERBOSE: The value of Public key 'd' (decrypt) is: 4136
VERBOSE: The value of 'n' is: 200609
VERBOSE: Ciphertext value is : 10410
10410
VERBOSE: Encrypted cipher value is : 38320
38320
VERBOSE: PlainTextValue value is : 10410
10410
BOB
C:\>
```
