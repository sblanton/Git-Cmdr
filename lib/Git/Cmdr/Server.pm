package Git::Cmdr::Server;

use Dancer ':syntax';

our $VERSION = '0.1';

prefix '/git_cmdr';

get '/update' => sub {
    template 'index';
};


1;
