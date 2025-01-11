my multi sub stringify($_ --> Str:D) {
    .defined
      ?? .contains(/ \s | ':' /)
        ?? "'$_'"
        !! $_
      !! ""
}
my sub named(Pair:D $pair) {
    my str $name = stringify $pair.key;
    my $value   := $pair.value;

    $value ~~ Bool
      ?? $value
        ?? "--$name"
        !! "--/$name"
      !! "--$name=&stringify($value)"
}
my sub nameds(%nameds --> Str:D) {
    %nameds.sort.map(&named).join(" ")
}

my proto sub as-cli-arguments($, |) is export {*}
my multi sub as-cli-arguments(
  Capture:D  $c,
     Bool:D :$named-anywhere = %*SUB-MAIN-OPTS<named-anywhere> // False,
--> Str:D) {

    my str $positionals = $c.list.map(*.&stringify).join(" ");
    my str $nameds      = nameds $c.hash;
    my str $space       = $positionals && $nameds ?? " " !! "";

    $named-anywhere
      ?? $positionals ~ $space ~ $nameds
      !! $nameds ~ $space ~ $positionals
}

my multi sub as-cli-arguments(%nameds --> Str:D) {
    nameds %nameds
}
my multi sub as-cli-arguments(@nameds --> Str:D) {
    @nameds.map(&named).join(" ")
}
my multi sub as-cli-arguments(Pair:D $named --> Str:D) {
    named $named
}

# vim: expandtab shiftwidth=4
