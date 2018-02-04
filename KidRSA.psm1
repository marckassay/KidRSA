using module .\src\KidRSA.AsymmetricKeys.psm1

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

function Step-PrivateDecryptKey {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [int]$EncryptedCipherText,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [int]$PrivateKey,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [int]$N
    )

    $PlainTextValue = ($PrivateKey * $EncryptedCipherText) % $N
    Write-Verbose -Message "PlainTextValue value is : $($PlainTextValue)"
    $PlainTextValue
}

function Step-PublicEncryptKey {
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [int]$CipherText,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [int]$PublicKey,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [int]$N
    )
    $EncryptedCipherText = ($PublicKey * $CipherText) % $N
    Write-Verbose -Message "Encrypted cipher value is : $($EncryptedCipherText)"
    $EncryptedCipherText
}

function ConvertTo-CipherInt {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
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


#>
<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER CipherText
Parameter description

.EXAMPLE
An example

.NOTES
Referenced def alphabet_encode:https://github.com/isaaguilar/alphabet-encode-python/blob/master/alphabet_cipher.py
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
        }
        
        $Base += $($Base26[$R.Value - 1])
    }
    $Base
}