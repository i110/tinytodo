use strict;
use warnings;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'extlib', 'lib', 'perl5');
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Amon2::Lite;

use JSON;

our $VERSION = '0.13';

# FIXME
use Data::Dumper;
use feature qw/say/;

my $dbname = 'tinytodo';
sub load_config {
    +{
        'DBI' => [ "dbi:SQLite:dbname=$dbname.db", '', '' ],
    }
}

get '/' => sub {
    my $c = shift;
    my $dbh = $c->dbh;
    my $rows = $dbh->selectall_arrayref('SELECT * FROM items', {Slice => {}});
    $_->{done} = _to_bool($_->{done}) for @$rows;
    $c->render_json($rows);
};

get '/:id' => sub {
    my ($c, $p) = @_;
    my $row = $c->dbh->selectrow_hashref('SELECT * FROM items WHERE id = ?', undef, $p->{id})
        or return $c->res_404;
    $row->{done} = _to_bool($row->{done});
    $c->render_json($row);
};

post '/' => sub {
    my $c = shift;
    my $item = decode_json($c->req->content);
    $c->dbh->do('INSERT INTO items (text) VALUES (?)', undef, $item->{text});
    my $id = $c->dbh->last_insert_id($dbname, $dbname, 'items', 'id');
    my $res = $c->render_json(+{
        id => $id,
        text => $item->{text},
        done => JSON::false,
    });
    $res->header('Location' => '/' . $id);
    $res;
};

any [qw/delete/], '/:id' => sub {
    my ($c, $p) = @_;
    $c->dbh->do('DELETE FROM items WHERE id = ?', undef, $p->{id})
        or return $c->res_404;
    $c->create_response(204)
};

sub _to_bool { shift ? JSON::true : JSON::false }

__PACKAGE__->load_plugin('DBI');
__PACKAGE__->load_plugin('Web::JSON');

__PACKAGE__->to_app;

