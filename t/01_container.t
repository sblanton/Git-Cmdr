#!/usr/bin/perl

use Test::More qw(no_plan);
use Git::Cmdr::Container;

my $cntr = Git::Cmdr::Container->new();
ok( $cntr, "created container");

my $svc = $cntr->resolve(service => 'git_cmdr');

ok( $svc, "created service");
ok( $svc->exec('status -sb'), "exec ok");
