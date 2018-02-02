Import-Module -Name $PSScriptRoot\..\KidRSA.psm1 -Verbose -Force

Describe "Test ConvertTo-CipherInt" {
    Context "with small strings" {
        InModuleScope KidRSA {
            It "Should return ciphertext as an Int" -TestCases @(
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
                $Results = Get-RSAKey
                $Results | Should -BeOfType AsymmetricKeys
            }
        }
    }
}

Describe "Test Encrypt-PlainText" {
    Context "with small strings" {
        InModuleScope KidRSA {
            It "Should return ciphertext as an Int" -TestCases @(
                @{  Value = "BOB" }) {
                Param($Value)

                $Results = Encrypt-PlainText $Value
                $Results | Should -Be 10410
            }
        }
    }
}
