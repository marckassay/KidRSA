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

Describe "Bob sends Alice his digital signature." {
    Context "Bob uses the plain text value of 'BOB' to be his digital signature.  A 
    simple-substitution cipher is acheived by ConvertTo-CipherText.  The output of passing the value
    'BOB' is 10410." {
        It "Should return cipher value of: 10410" -TestCases @(
            @{  PlainText = "BOB" }) {
            Param($PlainText)

            $Results = ConvertTo-CipherText $PlainText
            $Results | Should -Be 10410
        }
    }

    Context "Since he is creating a digital signature, Bob then takes this cipher text and multiples
    it with his private key and modulate with n.  And with that value he multiples it by 'e mod n'. 
    So the equation is:
     d'*s modulo n' * (e modulo n)." {
        It "Should return encrypted cipher text in the value of: 111091985737" -TestCases @(
            @{  CipherText  = 10410
                APublicKey  = $script:AlicesKeys.e
                AN          = $script:AlicesKeys.n
                BPrivateKey = $script:BobsKeys.d
                BN          = $script:BobsKeys.n
            }) {
            Param($CipherText, $APublicKey, $AN, $BPrivateKey, $BN)
            $Result1 = ($BPrivateKey * $CipherText) % $BN
            $Results = $Result1 * $($APublicKey % $AN)

            $Results | Should -Be 111091985737
        }
    }

    Context "Alice recieves Bob's encrypted message (digital signature) and does similar computation
     steps. The value that is returned is Bob's digital signature." {
        It "Should return cipher text in the value of: 55358729197065" -TestCases @(
            @{  EncryptedCipherText = 111091985737
                APrivateKey         = $script:AlicesKeys.d
                AN                  = $script:AlicesKeys.n
                BPublicKey          = $script:BobsKeys.e
                BN                  = $script:BobsKeys.n
            }) {
            Param($EncryptedCipherText, $APrivateKey, $AN, $BPublicKey, $BN)
            $Result1 = $APrivateKey * $($APrivateKey % $AN)
            $Results = $Result1 * $($BPublicKey % $BN)

            $Results | Should -Be 55358729197065
        }
    }
}