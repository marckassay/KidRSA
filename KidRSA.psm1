using module .\src\KidRSA.AsymmetricKeys.psm1

$script:Base26Table
function Get-IsomorphicMap {
    if ($script:Base26Table -eq $null) {
        $script:Base26Table = @{}
        0..25 | ForEach-Object {
            $LetterKey = [System.Convert]::ToChar($_ + 65)
            $script:Base26Table.Add($LetterKey, $_)
        }
    }

    $script:Base26Table
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

    $Base26 = Get-IsomorphicMap
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

function ConvertTo-PlainText {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [int]$CipherText
    )
}