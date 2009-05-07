#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Catalyst::Authentication::Credential::RPX' );
}

diag( "Testing Catalyst::Authentication::Credential::RPX $Catalyst::Authentication::Credential::RPX::VERSION, Perl $], $^X" );
