package Git::Cmdr::Server;

use Dancer ':syntax';

prefix '/git_cmdr';

get '/update' => sub {
    template 'index';
};


1;
