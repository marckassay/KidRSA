class AsymmetricKeys {
    [long]$e
    [long]$d
    [long]$n

    AsymmetricKeys([long]$a, [long]$b, [long]$a_, [long]$b_) {
        [long]$M = ($a * $b) - 1
        $this.e = ($a_ * $M) + $a
        $this.d = ($b_ * $M) + $b
        $this.n = (($this.e * $this.d) - 1) / $M
    }
}
