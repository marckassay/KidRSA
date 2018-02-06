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

Describe "Test asymetric key generation" {
    Context "Invoke Get-RSAKey" {
        It "Should auto-generate keys" {
            $Results = Get-RSAKey
            $Results.GetType().Name | Should -Be 'AsymmetricKeys'
            $Results.e | Should -BeOfType int
            $Results.d | Should -BeOfType int
            $Results.n | Should -BeOfType int
        }
        It "Should return an encryption key of '<e>' and a decryption key of '<d>'." -TestCases @(@{
                a  = 9
                b  = 11
                a_ = 5
                b_ = 8
                e  = 499
                d  = 795
                n  = 4048
            }) {
            Param($a, $b, $a_, $b_, $e, $d, $n)
            $Results = Get-RSAKey $a $b $a_ $b_
            $Results.GetType().Name | Should -Be 'AsymmetricKeys'
            $Results.e | Should -Be $e
            $Results.d | Should -Be $d
            $Results.n | Should -Be $n
        }
    }
}

Describe "Test Encoding and Decoding" {
    Context "Invoke ConvertTo-CipherText and ConvertTo-PlainText" {
        It "Should encode '<PlainText>' to '<CipherText>' and decode that value to 'BCD'.  This 
        discrepancy is expected due to the simplicity of this demonstration which isn't designed to 
        handle first character being 'A'." -TestCases @(@{
                PlainText  = 'ABCD'
                CipherText = 7310
            }) {
            Param($PlainText, $CipherText)
            #$OriginalPlainText = $PlainText
            #$OriginalCipherText = $CipherText
            {ConvertTo-CipherText $PlainText} | Should -Throw
            #$CipherText | Should -Be $OriginalCipherText

            #$PlainText = ConvertTo-PlainText $CipherText
            #$PlainText | Should -Be 'BCD'
        }
        It "Should encode '<PlainText>' to '<CipherText>' and decode that value back to 
        '<PlainText>'." -TestCases @(@{
                PlainText  = 'BCDE'
                CipherText = 190100
            }) {
            Param($PlainText, $CipherText)
            $OriginalPlainText = $PlainText
            $OriginalCipherText = $CipherText
            $CipherText = ConvertTo-CipherText $PlainText
            $CipherText | Should -Be $OriginalCipherText

            $PlainText = ConvertTo-PlainText $CipherText
            $PlainText | Should -Be $OriginalPlainText
        }
        It "Should encode '<PlainText>' to '<CipherText>' and decode that value back to 
        '<PlainText>'." -TestCases @(@{
                PlainText  = 'WXYZ'
                CipherText = 4028690
            }) {
            Param($PlainText, $CipherText)
            $OriginalPlainText = $PlainText
            $OriginalCipherText = $CipherText
            $CipherText = ConvertTo-CipherText $PlainText
            $CipherText | Should -Be $OriginalCipherText

            $PlainText = ConvertTo-PlainText $CipherText
            $PlainText | Should -Be $OriginalPlainText
        }
        It "Should encode '<PlainText>' to '<CipherText>' and decode that value back to 
        '<PlainText>'." -TestCases @(@{
                PlainText  = 'B'
                CipherText = 10
            }) {
            Param($PlainText, $CipherText)
            $OriginalPlainText = $PlainText
            $OriginalCipherText = $CipherText
            $CipherText = ConvertTo-CipherText $PlainText
            $CipherText | Should -Be $OriginalCipherText

            $PlainText = ConvertTo-PlainText $CipherText
            $PlainText | Should -Be $OriginalPlainText
        }
        It "Should encode '<PlainText>' to '<CipherText>' and decode that value back to 
        '<PlainText>'." -TestCases @(@{
                PlainText  = 'BO'
                CipherText = 400
            }) {
            Param($PlainText, $CipherText)
            $OriginalPlainText = $PlainText
            $OriginalCipherText = $CipherText
            $CipherText = ConvertTo-CipherText $PlainText
            $CipherText | Should -Be $OriginalCipherText

            $PlainText = ConvertTo-PlainText $CipherText
            $PlainText | Should -Be $OriginalPlainText
        }
        It "Should encode '<PlainText>' to '<CipherText>' and decode that value back to 
        '<PlainText>'." -TestCases @(@{
                PlainText  = 'BOB'
                CipherText = 10410
            }) {
            Param($PlainText, $CipherText)
            $OriginalPlainText = $PlainText
            $OriginalCipherText = $CipherText
            $CipherText = ConvertTo-CipherText $PlainText
            $CipherText | Should -Be $OriginalCipherText

            $PlainText = ConvertTo-PlainText $CipherText
            $PlainText | Should -Be $OriginalPlainText
        }
        It "Should encode '<PlainText>' to '<CipherText>' and decode that value back to 
        '<PlainText>'." -TestCases @(@{
                PlainText  = 'BOBB'
                CipherText = 270670
            }) {
            Param($PlainText, $CipherText)
            $OriginalPlainText = $PlainText
            $OriginalCipherText = $CipherText
            $CipherText = ConvertTo-CipherText $PlainText
            $CipherText | Should -Be $OriginalCipherText

            $PlainText = ConvertTo-PlainText $CipherText
            $PlainText | Should -Be $OriginalPlainText
        }
        It "Should encode '<PlainText>' to '<CipherText>' and decode that value back to 
        '<PlainText>'." -TestCases @(@{
                PlainText  = 'BOBBY'
                CipherText = 7037660
            }) {
            Param($PlainText, $CipherText)
            $OriginalPlainText = $PlainText
            $OriginalCipherText = $CipherText
            $CipherText = ConvertTo-CipherText $PlainText
            $CipherText | Should -Be $OriginalCipherText

            $PlainText = ConvertTo-PlainText $CipherText
            $PlainText | Should -Be $OriginalPlainText
        }
        It "Should encode '<PlainText>' to '<CipherText>' and decode that value back to 
        '<PlainText>'." -TestCases @(@{
                PlainText  = 'HELLOA'
                CipherText = 851986720
            }) {
            Param($PlainText, $CipherText)
            $OriginalPlainText = $PlainText
            $OriginalCipherText = $CipherText
            $CipherText = ConvertTo-CipherText $PlainText
            $CipherText | Should -Be $OriginalCipherText

            $PlainText = ConvertTo-PlainText $CipherText
            $PlainText | Should -Be $OriginalPlainText
        }
    }
}