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

Describe "Test ConvertTo-CipherInt" {
    Context "with PlainText parameter being 'BOB'" {
        InModuleScope KidRSA {
            It "Should return ciphertext in the value of: 10410" -TestCases @(
                @{  PlainText = "BOB" }) {
                Param($PlainText)

                $Results = ConvertTo-CipherInt $PlainText
                $Results | Should -Be 10410
            }
        }
    }
}

Describe "Test Get-RSAKey" {
    Context "with auto-generated parameters" {
        InModuleScope KidRSA {
            It "Should return AsymmetricKeys type" {
                $Results = Get-RSAKey -Verbose
                $Results.GetType().Name | Should -Be 'AsymmetricKeys'
                $Results.e | Should -BeOfType int
                $Results.d | Should -BeOfType int
                $Results.n | Should -BeOfType int
            }
        }
    }
}

Describe "Test Get-RSAKey" {
    Context "with predefined parameters. These are the same values from: ckingdev/kidrsa/kidrsa_test.go. :D" {
        It "Should return AsymmetricKeys type" {
            $Results = Get-RSAKey 9 11 5 8 -Verbose
            $Results.GetType().Name | Should -Be 'AsymmetricKeys'
            $Results.e | Should -Be 499
            $Results.d | Should -Be 795
            $Results.n | Should -Be 4048
        }
    }
}


Describe "Test Step-PrivateKeyModN" {
    Context "Bob is going to send Alice his digital-sig.  He is chooses the value of 'BOB' 
    and sends it to the Step-PrivateKeyModN function with his PrivateKey and N." {
        It "Should return semiencryptedtext in the value of: 13058891" -TestCases @(
            @{  Value      = 'BOB'
                PrivateKey = $script:BobsKeys.d
                N          = $script:BobsKeys.n
            }) {
            Param($Value, $PrivateKey, $N)

            $Results = Step-PrivateKeyModN -Value $Value -PrivateKey $PrivateKey -N $N -Verbose
            $Results | Should -Be 13058891
        }
    }
}

Describe "Test Step-PublicKeyModN" {
    Context "Bob then takes the value from Step-PrivateKeyModN and uses Alice's public key and N
    to encrypt this message and sends it to Alice." {
        It "Should return semiencryptedtext in the value of: 7705" -TestCases @(
            @{  Value     = 13058891
                PublicKey = $script:AlicesKeys.e
                N         = $script:AlicesKeys.n
            }) {
            Param($Value, $PublicKey, $N)

            $Results = Step-PublicKeyModN -Value $Value -PublicKey $PublicKey -N $N -Verbose
            $Results | Should -Be 7705
        }
    }
}


Describe "Test Step-PrivateKeyModN" {
    Context "Alice recieves Bob's encrypted message.  She takes this message and along with her
    private key and N, and calls Step-PrivateKeyModN function " {
        It "Should return in the value of: 4059" -TestCases @(
            @{  EncyptedValue = 7705
                PrivateKey    = $script:AlicesKeys.d
                N             = $script:AlicesKeys.n
            }) {
            Param($EncyptedValue, $PrivateKey, $N)

            $Results = Step-PrivateKeyModN -EncyptedValue $EncyptedValue -PrivateKey $PrivateKey -N $N -Verbose
            $Results | Should -Be 4059
        }
    }
}


Describe "Test Step-PublicKeyModN" {
    Context "Alice takes the value from Step-PrivateKeyModN and uses Bob's Public key and N to call
    Step-PublicKeyModN to decrypt the message" {
        It "Should return semiencryptedtext in the value of: 10410" -TestCases @(
            @{  Value     = 4059
                PublicKey = $script:BobsKeys.e
                N         = $script:BobsKeys.n
            }) {
            Param($Value, $PublicKey, $N)

            $Results = Step-PublicKeyModN -Value $Value -PublicKey $PublicKey -N $N -Verbose
            $Results | Should -Be 10410
        }
    }
}
