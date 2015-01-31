package App::tabify;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

use Getopt::Long::Complete qw(GetOptionsWithCompletion);
use POSIX qw(ceil);

my %Opts = (
    tab_width      => 8,
    in_place       => 0,
    #backup_ext     => undef,
);

sub parse_cmdline {
    my $res = GetOptionsWithCompletion(
        sub {},
        'tab-width|w=i' => \$Opts{tab_width},
        #'in-place|i'  => sub { # XXX in-place|i:s doesn't work?
        #    $Opts{in_place} = 1;
        #    #$Opts{backup_ext} = $_[1] if defined $_[1];
        #},
        'version|v'     => sub {
            no warnings 'once';
            say "tabify version $main::VERSION";
            exit 0;
        },
        'help|h'        => sub {
            print <<USAGE;
Usage:
  (un)tabify [OPTIONS] <FILE...>
  (un)tabify --help|-h
  (un)tabify --version|-v
Options:
  --tab-width=i, -w  Set tab width (default: 8).
For more details, see the manpage/documentation.
USAGE
            exit 0;
        },
    );
    exit 99 if !$res;
}

sub run {
    my $which = shift; # either 'tabify' or 'untabify'

    my $oldargv = '';
    my $argvout;

    my $tw = $Opts{tab_width};

  LINE:
    while (<>) {
        #if ($ARGV ne $oldargv) {
        #    if (defined($Opts{backup_ext}) && $Opts{backup_ext} ne '') {
        #        rename $ARGV, "$ARGV$Opts{backup_ext}";
        #        open $argvout, ">", $ARGV;
        #        select $argvout;
        #        $oldargv = $ARGV;
        #    }
        #}
        if ($which eq 'untabify') {
            1 while s|^(.*?)\t|$1 .
                (" " x (ceil((length($1)+1)/$tw)*$tw - length($1)))|em;
        } else {
            s|^([ ]{2,})|
                ("\t" x int(length($1)/$tw)) .
                     (" " x (length($1) - int(length($1)/$tw)*$tw))|em;
        }
    } continue {
        print;
    }
    #select STDOUT;
}

1;
# ABSTRACT: Convert spaces to tabs (tabify), or tabs to spaces (untabify)

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

See the command-line scripts L<tabify> and L<untabify>.

=cut
