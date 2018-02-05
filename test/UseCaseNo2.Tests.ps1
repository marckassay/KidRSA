Import-Module -Name $PSScriptRoot\..\KidRSA.psm1 -Verbose -Force

<#
AlicesKeys
VERBOSE: The value for 'a' is: 67
VERBOSE: The value for 'b' is: 63
VERBOSE: The value for 'a_' is: 2
VERBOSE: The value for 'b_' is: 3
VERBOSE: The value of Private key 'e' (encrypt) is: 8507
VERBOSE: The value of Public key 'd' (decrypt) is: 12723
VERBOSE: The value of 'n' is: 25648
#>
$script:AlicesKeys = $(Get-RSAKey -a 67 -b 63 -a_ 2 -b_ 3)

<#
BobsKeys
VERBOSE: The value for 'a' is: 80
VERBOSE: The value for 'b' is: 45
VERBOSE: The value for 'a_' is: 95
VERBOSE: The value for 'b_' is: 69
VERBOSE: The value of Private key 'e' (encrypt) is: 341985
VERBOSE: The value of Public key 'd' (decrypt) is: 248376
VERBOSE: The value of 'n' is: 23601241
#>
$script:BobsKeys = $(Get-RSAKey -a 80 -b 45 -a_ 95 -b_ 69)

Describe "Alice gives Bob her public key for that he can send her an encrypt message." {
    Context "Bob types his message in plain text and runs it thru an algorithm to be cipher." {
        It "Should return cipher value of: 10410" -TestCases @(
            @{  PlainText = "BOB" }) {
            Param($PlainText)

            $Results = ConvertTo-CipherText $PlainText
            $Results | Should -Be 10410
        }
    }

    Context "Bob then takes cipher text and runs it thru another algorithm with Alice's public key (e and n)." {
        It "Should return encrypted cipher text in the value of: 20974" -TestCases @(
            @{  CipherText = 10410
                PublicKey  = $script:AlicesKeys.e
                N          = $script:AlicesKeys.n
            }) {
            Param($CipherText, $PublicKey, $N)

            $Results = ConvertTo-PublicEncryptionValue -CipherText $CipherText -PublicKey $PublicKey -N $N -Verbose
            $Results | Should -Be 20974
        }
    }

    Context "Alice recieves Bob's encrypted message and runs it thru an algorithm to decrypt it with her private key." {
        It "Should return cipher text in the value of: 10410" -TestCases @(
            @{  EncryptedCipherText = 20974
                PrivateKey          = $script:AlicesKeys.d
                N                   = $script:AlicesKeys.n
            }) {
            Param($EncryptedCipherText, $PrivateKey, $N)

            $Results = ConvertTo-PrivateDecryptionValue -EncryptedCipherText $EncryptedCipherText -PrivateKey $PrivateKey -N $N -Verbose
            $Results | Should -Be 10410
        }
    }
}