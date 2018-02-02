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
    [AsymmetricKeys]::new($a, $b, $a_, $b_)
}

function Encrypt-PlainText {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[a-zA-Z]+$")]
        [string]$Value,

        [hashtable]$Key
    )

    $c = ConvertTo-CipherInt -PlainText $Value

    $ciphertext = ($Key.e * $c) % $Key.n
    $ciphertext
}

function Decrypt-CipherText {
    Param(
        [int]$cipherext,
        [hashtable]$Key
    )
    $plaintext = ($Key.d * $cipherext) % $Key.n
    $plaintext
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
    $Value * 10
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