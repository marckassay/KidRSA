# KidRSA

After watching [How to Break Cryptography](https://www.youtube.com/watch?v=12Q3Mrh03Gk) and [This Video was Not Encrypted with RSA](https://www.youtube.com/watch?v=4Tb1q8dSIlI) my curiosity motivated me to demystify RSA cryptography.  Inspired by [Neal Koblitz](https://sites.math.washington.edu/~koblitz/)'s article [Cryptography As a Teaching Tool](https://sites.math.washington.edu/~koblitz/crlogia.html) this module was programmed following his 'Kid-RSA' example.

The beauty of this demonstration is the simplicity of arithmetic operations to encrypt and decrypt with minimal computational steps.

This demonstration (just as the article's example) explains the following two procedures:

* How to convert plain text message into simple-substitution cipher that gets encrypted by the sender and then decrypted by the recipient.  The recipient then runs, the now decrypted cipher, thru an inverse simple-substitution algorithm to retrieve the plain text message.

* How a digital signature is created and sent.

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/marckassay/KidRSA/blob/master/LICENSE)  [![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/KidRSA/)

## Caveat

This is a demonstration, not suitable for production.  The messages that can be ciphered is limited
due to this being a simple demonstration.

## Instructions

To install, run the following command in PowerShell.

```powershell
$ Install-Module KidRSA
```

## Explanation

Copy-and-paste the first five lines of code into PowerShell after installing this module.  `Shift + Enter` to paste multiple lines of code such as below.  Use the `Up Arrow` to repeat previous command followed by an `Enter` and see that the generated RSA keys are different than previously.  With a new generated set of (asymmetric) keys will have a different encrypted value but the `ConvertTo-PlainText` (simple-substitution cipher) function will output the same plain text value.

```powershell
C:\>
$AlicesKeys = Get-RSAKey -Verbose
$PlainText = ‘HI’
$CipherText = ConvertTo-CipherText $PlainText -Verbose
$EncryptedCipherText = ConvertTo-PublicEncryptionValue -CipherText $CipherText -PublicKey $AlicesKeys.e -N $AlicesKeys.n -Verbose
$CipherText = ConvertTo-PrivateDecryptionValue -EncryptedCipherText $EncryptedCipherText -PrivateKey $AlicesKeys.d -N $AlicesKeys.n -Verbose
ConvertTo-PlainText $CipherText -Verbose
VERBOSE: The value for 'a' is: 15
VERBOSE: The value for 'b' is: 30
VERBOSE: The value for 'a_' is: 44
VERBOSE: The value for 'b_' is: 90
VERBOSE: The value of Private key 'e' (encrypt) is: 19771
VERBOSE: The value of Public key 'd' (decrypt) is: 40440
VERBOSE: The value of 'n' is: 1780711
VERBOSE: Ciphertext value is : 1900
VERBOSE: Encrypted cipher value is : 169969
VERBOSE: Decrypted cipher value is : 1900
VERBOSE: PlainText value is : HI
HI
C:\>
```