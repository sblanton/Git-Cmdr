package gc_server;
use Dancer ':syntax';
use Git::Cmdr::Server;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

true;
