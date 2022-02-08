[![Actions Status](https://github.com/lizmat/as-cli-arguments/workflows/test/badge.svg)](https://github.com/lizmat/as-cli-arguments/actions)

NAME
====

as-cli-arguments - stringify a Capture as command-line arguments

SYNOPSIS
========

```raku
use as-cli-arguments;
sub MAIN(|c) { say as-cli-arguments c, :named-anywhere }
```

```raku
use as-cli-arguments;
my %*SUB-MAIN-OPTS = :named-anywhere;
sub MAIN(|c) { say as-cli-arguments c }
```

DESCRIPTION
===========

as-cli-arguments exports a single subroutine `as-cli-arguments` that takes a `Capture` object, and returns a string that represents the contents of the `Capture` as command line arguments.

The subroutine also takes an optional named arguments `:named-anywhere` to indicate whether or not the "named arguments anywhere" mode should be assumed. By default, this will use the `%*SUB-MAIN-OPTS<named-anywhere>` setting, if available. Else it will default to `False`.

This is mainly intended as a helper subroutine for command-line scripts and modules that want to give feedback about the given (or perceived) arguments.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/as-cli-arguments . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

