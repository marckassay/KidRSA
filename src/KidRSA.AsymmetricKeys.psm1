class AsymmetricKeys {
    [int]$n
    [int]$e
    [int]$d

    AsymmetricKeys([int]$a, [int]$b, [int]$a_, [int]$b_) {
        $M = ($a * $b) - 1
        $this.e = ($a_ * $M) + $a
        $this.d = ($b_ * $M) + $b
        $this.n = (($this.e * $this.d) - 1) / $M
    }
}
