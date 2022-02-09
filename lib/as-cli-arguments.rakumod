
my sub stringify(str $_ --> Str:D) {
    .contains(/ \s /) ?? "'$_'" !! $_.Str
}

my sub as-cli-arguments(
  Capture:D  $c,
  Bool:D    :$named-anywhere = %*SUB-MAIN-OPTS<named-anywhere> // False,
--> Str:D) is export {

    my str $positionals = $c.list.map(*.&stringify).join(" ");

    my str $nameds = $c.hash.kv.map(-> $key, $value {
        my str $name = stringify $key;
        $value ~~ Bool
          ?? $value
            ?? "--$name"
            !! "--/$name"
          !! "--$name=&stringify($value)"
    }).join(" ");

    my str $space = $positionals && $nameds ?? " " !! "";
    $named-anywhere
      ?? "$positionals$space$nameds"
      !! "$nameds$space$positionals"
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

=end code

=head1 DESCRIPTION

as-cli-arguments exports a single subroutine C<as-cli-arguments> that takes
a C<Capture> object, and returns a string that represents the contents of
the C<Capture> as command line arguments.

The subroutine also takes an optional named arguments C<:named-anywhere> to
indicate whether or not the "named arguments anywhere" mode should be assumed.
By default, this will use the C<%*SUB-MAIN-OPTS<named-anywhere>> setting,
if available.  Else it will default to C<False>.

This is mainly intended as a helper subroutine for command-line scripts and
modules that want to give feedback about the given (or perceived) arguments.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/as-cli-arguments .
Comments and Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
