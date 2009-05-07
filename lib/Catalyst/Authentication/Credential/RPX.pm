package Catalyst::Authentication::Credential::RPX;

use Moose;
use Net::API::RPX;

our $VERSION = '0.01';

sub BUILDARGS {
    my $self = shift;
    my ($conf, $c, $realm) = @_;
    #return { config => $conf, c => $c, realm => $realm };

    my $apikey = $realm->{config}{apikey};

    return { apikey => $apikey };
}

has 'apikey' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

# not sure how to handle api for this
has '_ua';

has '_rpx' => (
    is => 'ro',
    isa => 'Net::API::RPX',
    lazy_build => 1,
);

sub _build__rpx {
    my ($self) = @_;
    return Net::API::RPX->new({ apikey => $self->apikey() });
}

sub authenticate {
    my ($self, $c, $realm, $authinfo) = @_;

    $c->log->debug("authenticate() called from " . $c->request->uri) if $self->debug;

    my $field = $realm->{config}{token_field} || 'token';
    my $token = $authinfo->{ $field };

    if(!$token){
        Catalyst::Exception->throw("No RPX token supplied (token_field: '$field').");
    }

    eval {
        if( my $user = $self->_rpx->auth_info({ token => $token }) ){
            my $user_obj = $realm->find_user($user, $c);
            
            if ( ref $user_obj ){
                return $user_obj;
            } else {
                $c->log->debug("Verified RPX login failed to load with find_user; bad user_class? Try 'Null.'") if $c->debug;
                return;
            }
        }
        Catalyst::Exception->throw("Error validating RPX login");
    };

    return;
}


=head1 NAME

Catalyst::Authentication::Credential::RPX - The great new Catalyst::Authentication::Credential::RPX!

=head1 VERSION

Version 0.01

=cut



=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Catalyst::Authentication::Credential::RPX;

    my $foo = Catalyst::Authentication::Credential::RPX->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Scott McWhirter, C<< <konobi at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-catalyst-authentication-credential-rpx at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-Authentication-Credential-RPX>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Catalyst::Authentication::Credential::RPX


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Catalyst-Authentication-Credential-RPX>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Catalyst-Authentication-Credential-RPX>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Catalyst-Authentication-Credential-RPX>

=item * Search CPAN

L<http://search.cpan.org/dist/Catalyst-Authentication-Credential-RPX>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Scott McWhirter, all rights reserved.

This program is released under the following license: bsd


=cut

1; # End of Catalyst::Authentication::Credential::RPX
