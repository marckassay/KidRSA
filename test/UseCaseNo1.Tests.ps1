Import-Module -Name $PSScriptRoot\..\KidRSA.psm1 -Verbose -Force

<#
AlicesKeys
VERBOSE: The value for 'a' is: 672
VERBOSE: The value for 'b' is: 263
VERBOSE: The value for 'a_' is: 342
VERBOSE: The value for 'b_' is: 543
VERBOSE: The value of Private key 'e' (encrypt) is: 60444042
VERBOSE: The value of Public key 'd' (decrypt) is: 95967368
VERBOSE: The value of 'n' is: 32821204753
#>
$script:AlicesKeys = $(Get-RSAKey -a 672 -b 263 -a_ 342 -b_ 543)
$script:PlainText = "HELLO"
$script:CipherText = 32768720
$script:EncryptedCipherText = 12644736949

Describe "Alice gives Bob her public key for that he can send her an encrypted message." {

    It "Bob types his message ('<PlainText>') in plaintext and runs it thru a simple-substitution
    cipher algorithm. Should return ciphertext value of: <ExpectedResult>" -TestCases @(@{
            PlainText      = $script:PlainText
            ExpectedResult = $script:CipherText
        }) {
        Param($PlainText, $ExpectedResult)

        $Results = ConvertTo-CipherText $PlainText
        $Results | Should -Be $ExpectedResult
    }

    It "Bob then takes ciphertext (<CipherText>) and runs it thru the RSA encryption algorithm with
     Alice's public key (e and n). Should return encrypted ciphertext in the value 
     of: <ExpectedResult>" -TestCases @(@{
            CipherText     = $script:CipherText
            PublicKey      = $script:AlicesKeys.e
            N              = $script:AlicesKeys.n
            ExpectedResult = $script:EncryptedCipherText
        }) {
        Param($CipherText, $PublicKey, $N, $ExpectedResult)

        $Results = ConvertTo-PublicEncryptionValue -CipherText $CipherText `
            -PublicKey $PublicKey -N $N -Verbose
        $Results | Should -Be $ExpectedResult
    }

    It "Alice receives Bob's encrypted message (<EncryptedCipherText>) and sends it thru the RSA
     decryption algorithm.  Should return Bob's ciphertext value which is:
     <ExpectedResult>" -TestCases @(@{
            EncryptedCipherText = $script:EncryptedCipherText
            PrivateKey          = $script:AlicesKeys.d
            N                   = $script:AlicesKeys.n
            ExpectedResult      = $script:CipherText
        }) {
        Param($EncryptedCipherText, $PrivateKey, $N, $ExpectedResult)

        $Results = ConvertTo-PrivateDecryptionValue -EncryptedCipherText $EncryptedCipherText `
            -PrivateKey $PrivateKey -N $N -Verbose
        $Results | Should -Be $ExpectedResult
    }

    It "Alice takes the ciphertext (<CipherText>) and runs it thru the simple-substitution cipher's 
    decode (inverse) algorithm to get the plaintext message of: '<ExpectedResult>'" -TestCases @(@{
            CipherText     = $script:CipherText
            ExpectedResult = $script:PlainText
        }) {
        Param($CipherText, $ExpectedResult)

        ConvertTo-PlainText $CipherText -Verbose | Should -Be $ExpectedResult
    }
}