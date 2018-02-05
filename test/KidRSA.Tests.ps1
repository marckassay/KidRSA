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

Describe "Test ConvertTo-CipherText" {
    Context "with PlainText parameter being 'BO'" {
        InModuleScope KidRSA {
            It "Should return ciphertext in the value of: 400" -TestCases @(
                @{  PlainText = "BO" }) {
                Param($PlainText)
    
                $Results = ConvertTo-CipherText $PlainText
                $Results | Should -Be 400
            }
        }
    }
}
Describe "Test ConvertTo-CipherText" {
    Context "with PlainText parameter being 'BOB'" {
        InModuleScope KidRSA {
            It "Should return ciphertext in the value of: 10410" -TestCases @(
                @{  PlainText = "BOB" }) {
                Param($PlainText)

                $Results = ConvertTo-CipherText $PlainText
                $Results | Should -Be 10410
            }
        }
    }
}

Describe "Test ConvertTo-PlainText" {
    Context "with CipherText parameter being 'BOB'" {
        InModuleScope KidRSA {
            It "Should return plaintext in the value of: 10410" -TestCases @(
                @{  CipherText = 10410 }) {
                Param($CipherText)

                $Results = ConvertTo-PlainText $CipherText -Verbose
                $Results | Should -Be 'BOB'
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