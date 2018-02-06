using module .\src\KidRSA.AsymmetricKeys.psm1

<#
.SYNOPSIS
Returns asymetric keys; Public Key and Private Key

.DESCRIPTION
To be used to encrypt and decrypt cipher text values.

.PARAMETER a
Any integer in the range of 1-100.

.PARAMETER b
Any integer in the range of 1-100.

.PARAMETER a_
Any integer in the range of 1-100.

.PARAMETER b_
Any integer in the range of 1-100.

.EXAMPLE
C:\> $AlicesKeys = Get-RSAKey -a 67 -b 63 -a_ 2 -b_ 3
VERBOSE: The value for 'a' is: 67
VERBOSE: The value for 'b' is: 63
VERBOSE: The value for 'a_' is: 2
VERBOSE: The value for 'b_' is: 3
VERBOSE: The value of Private key 'e' (encrypt) is: 8507
VERBOSE: The value of Public key 'd' (decrypt) is: 12723
VERBOSE: The value of 'n' is: 25648

.NOTES
General notes
#>
function Get-RSAKey {
    [CmdletBinding()]
    [OutputType([AsymmetricKeys])]
    Param(
        [Parameter(Mandatory = $false)]
        [int]$a = $(Get-Random -Minimum -1 -Maximum 100),

        [Parameter(Mandatory = $false)]
        [int]$b = $(Get-Random -Minimum -1 -Maximum 100),

        [Parameter(Mandatory = $false)]
        [int]$a_ = $(Get-Random -Minimum -1 -Maximum 100),

        [Parameter(Mandatory = $false)]
        [int]$b_ = $(Get-Random -Minimum -1 -Maximum 100)
    )

    Write-Verbose -Message "The value for 'a' is: $($a)"
    Write-Verbose -Message "The value for 'b' is: $($b)"
    Write-Verbose -Message "The value for 'a_' is: $($a_)"
    Write-Verbose -Message "The value for 'b_' is: $($b_)"

    $Keys = [AsymmetricKeys]::new($a, $b, $a_, $b_)

    Write-Verbose -Message "The value of Private key 'e' (encrypt) is: $($Keys.e)"
    Write-Verbose -Message "The value of Public key 'd' (decrypt) is: $($Keys.d)"
    Write-Verbose -Message "The value of 'n' is: $($Keys.n)"

    $Keys
}

<#
.SYNOPSIS
Decrypts the value from ConvertTo-PublicEncryptionValue function

.DESCRIPTION
Given a private and public key from Get-RSAKey function, the public key is used to encrypt a cipher 
text via ConvertTo-PublicEncryptionValue function.  The value from that function is used in this 
function to decrypt it using the private (d) key.

.PARAMETER EncryptedCipherText
The value from ConvertTo-PublicEncryptionValue

.PARAMETER PrivateKey
The private key to decrypt EncryptedCipherText parameter.  This is typically represented in 
mathematical operations as the letter 'd'.

.PARAMETER N
The key modulus of PrivateKey parameter value. This is typically represented in mathematical 
operations as the letter 'n'.

.EXAMPLE
An example

.NOTES
General notes
#>
function ConvertTo-PrivateDecryptionValue {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [int]$EncryptedCipherText,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Alias("DecryptionKey")]
        [int]$PrivateKey,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [int]$N
    )
    $CipherText = ($PrivateKey * $EncryptedCipherText) % $N
    Write-Verbose -Message "Decrypted cipher value is : $($CipherText)"
    $CipherText
}

<#
.SYNOPSIS
Encrypts the value from ConvertTo-CipherText function

.DESCRIPTION
Given a private and public key from Get-RSAKey function, the public key is used to encrypt cipher 
text.  The value returned from this function is used in the ConvertTo-PrivateDecryptionValue 
function to decrypt it.

.PARAMETER CipherText
The value from ConvertTo-PublicEncryptionValue

.PARAMETER PublicKey
The public key to encrypt CipherText parameter.  This is typically represented in mathematical 
operations as the letter 'e'.

.PARAMETER N
The key modulus of PublicKey parameter value. This is typically represented in mathematical 
operations as the letter 'n'.

.EXAMPLE
An example

.NOTES
General notes
#>
function ConvertTo-PublicEncryptionValue {
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [int]$CipherText,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Alias("EncryptionKey")]
        [int]$PublicKey,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [int]$N
    )
    $EncryptedCipherText = ($PublicKey * $CipherText) % $N
    Write-Verbose -Message "Encrypted cipher value is : $($EncryptedCipherText)"
    $EncryptedCipherText
}

<#
.SYNOPSIS
Returns a morphic map of alpha and numeric values.

.DESCRIPTION
Used as a lookup table to encode plain text or decode cipher text

.PARAMETER KeyType
Determines the type value for the keys of map.  Validate set of: "Alpha" or "Numeric".

.NOTES
General notes
#>
function Get-IsomorphicMap {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Alpha", "Numeric")]
        [string]$KeyType
    )
    
    $Base26Table = @{}
    0..25 | ForEach-Object {
        $Alpha = [System.Convert]::ToChar($_ + 65)
        if ($KeyType -eq "Alpha") {
            $Base26Table.Add($Alpha, $_)
        }
        else {
            $Base26Table.Add($_, $Alpha)
        }
    }
    $Base26Table
}

<#
.SYNOPSIS
Returns cipher text from plain text.

.DESCRIPTION
Pass an alphabetic, with a length no greater then 6 to this function to get a cipher text value.  In
cryptography, this algorithm is referred to more specifically as 'simple-substitution' cipher.

.PARAMETER PlainText
Message to convert to cipher text

.EXAMPLE
C:\> ConvertTo-PlainText 'BOB'
C:\> 10410

.NOTES
This function will multiple the value by 10 before returning.
#>
function ConvertTo-CipherText {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $false)]
        [ValidateLength(1, 6)]
        [ValidateScript( {$_[0] -ne 'A'})]
        [ValidatePattern("[A-Z]")]
        [string]$PlainText
    )

    $Base26 = Get-IsomorphicMap -KeyType Alpha
    $Pointer = 0
    $Value = 0
    
    while ($Pointer -lt $PlainText.Length) {
        $Character = $PlainText[$Pointer]
        $Value += $Base26[$Character] * [System.Math]::Pow(26, $($PlainText.Length - $Pointer - 1))
        $Pointer++
    }
    $Value = $Value * 10
    Write-Verbose -Message "Ciphertext value is : $Value"
    $Value
}

<#
.SYNOPSIS
Returns plain text from cipher text.

.DESCRIPTION
The ConvertTo-CipherText takes plain text and returns cipher text.  To reverse cipher text this 
function is used.

.PARAMETER CipherText
For instance, the plain text value of 'BOB' has a cipher text value of 10410 (This repo converts 
text to Hexavigesimal values times 10).

.EXAMPLE
C:\> ConvertTo-PlainText 10410
C:\> BOB

.NOTES
Due to the simplicity of this demonstration ciphertext that start with 'A' will fail in this
function.

This function follows referenced alphabet_encode in alphabet-encode-python repo:
    https://github.com/isaaguilar/alphabet-encode-python/blob/master/alphabet_cipher.py
#>
function ConvertTo-PlainText {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [int]$CipherText
    )
    
    [int]$Q = $($CipherText / 10)
    [ref]$R = 0

    $Base26 = Get-IsomorphicMap -KeyType Numeric
    while ($Q -ne 0) {
        $Q = [System.Math]::DivRem($Q + 1, $Base26.Count, $R)

        if ($R.Value -eq 0) {
            $Q = $Q - 1
            $Base += $($Base26[$Base26.Count - 1])
        }
        else {
            $Base += $($Base26[$R.Value - 1])
        }
    }

    if ($Base.Length -gt 1) {
        # reverse the order of chars
        $BaseChar = $Base.ToCharArray()
        [array]::Reverse($BaseChar)
        $Base = -join ($BaseChar)
    }

    Write-Verbose -Message "PlainText value is : $Base"

    $Base
}