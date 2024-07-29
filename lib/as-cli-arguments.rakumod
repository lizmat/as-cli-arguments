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

=begin pod

=head1 NAME

as-cli-arguments - stringify a Capture as command-line arguments

=head1 SYNOPSIS

=begin code :lang<raku>

use as-cli-arguments;
sub MAIN(|c) { say as-cli-arguments c, :named-anywhere }

=end code

=begin code :lang<raku>

use as-cli-arguments;
my %*SUB-MAIN-OPTS = :named-anywhere;
sub MAIN(|c) { say as-cli-arguments c }

sub MAIN(*@pos, :$foo, :$bar, *%_) {
    die "Found unexpected named arguments: &as-cli-arguments(%_)"
      if %_;
}

=end code

=begin code :lang<raku>

say as-cli-arguments { :42a, :666b }  # --a=42 --b=666

say as-cli-arguments (:42a, :666b)    # --a=42 --b=666

say as-cli-arguments "a" => 42;       # --a=42

=end code

=head1 DESCRIPTION

as-cli-arguments exports a single subroutine C<as-cli-arguments> that
takes either a C<Capture> object, a hash with named arguments, a C<Pair>
or a list of C<Pair>s and returns a string that represents the contents
of the argument given as if they were command line arguments.

If a C<Capture> object is specified, then the subroutine also takes
an optional named arguments C<:named-anywhere> to indicate whether or
not the "named arguments anywhere" mode should be assumed.  By default,
this will use the C<%*SUB-MAIN-OPTS<named-anywhere>> setting, if
available.  Else it will default to C<False>.

This is mainly intended as a helper subroutine for command-line scripts
and modules that want to give feedback about the given or perceived or
unexpected command line parameters.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/as-cli-arguments .
Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a
L<small sponsorship|https://github.com/sponsors/lizmat/>  would mean a great
deal to me!

=head1 COPYRIGHT AND LICENSE

Copyright 2022, 2024 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
