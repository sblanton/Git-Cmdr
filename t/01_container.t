#!/usr/bin/perl

use Git::Cmdr::Container;

my $cntr = Git::Cmdr::Container->new();

my $svc = $cntr->resolve(service => 'git_cmdr');

$svc->exec('status -sb');
