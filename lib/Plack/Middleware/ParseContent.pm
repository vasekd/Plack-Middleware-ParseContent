package Plack::Middleware::ParseContent;

use 5.006;
use strict;
use warnings FATAL => 'all';

use parent qw( Plack::Middleware );

use Plack::Request;

use HTTP::Exception '4XX';

use JSON::XS;
use YAML::Syck;

=head1 NAME

Plack::Middleware::ParseContent - Parse content of input data by Content-Type header.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.02';


=head1 SYNOPSIS

	use Plack::Middleware::ParseContent;

	builder {
		enable 'ParseContent', 'application/xyz' => sub{ return decode_xyz($_[0]) };
		mount "/" => sub { 
			my ($env) = @_;

			return [ 200, [ 'Content-Type' => 'text/plain' ], [ serialize($env->{'parsecontent.data'}) ] ];
		};
	};

=head1 DESCRIPTION

Parse input content and save it to plack env as 'parsecontent.data'.

For complete RestAPI in Perl use: 

=over 4

=item * Plack::App::REST

=item * Plack::Middleware::FormatOutput

=back

=head1 CONSTANTS

=head2 DEFAULT MIME TYPES

=over 4

=item * application/json

=item * text/yaml

=item * text/plain

=back

=cut

my $Mime_types = {
    'application/json'   => sub { &decode_json($_[0]) },
    'text/yaml'          => sub { &YAML::Syck::Load($_[0]) },
    'text/plain'         => sub { $_[0] },
};

sub prepare_app {
    my $self = shift;

    # Add new mime types to env
	foreach my $par (keys %$self){
		next unless ref $self->{$par} eq 'CODE'; # just add mime types that are reference to sub
		$Mime_types->{$par} = $self->{$par};
	}
}

sub call {
	my($self, $env) = @_;

	### Get method
	my $method = $env->{REQUEST_METHOD};

	### Get dat from env
	my $data;

	my $req = Plack::Request->new($env);
	if ($method eq 'POST' or $method eq 'PUT') {
		my $contentType = $req->content_type;
		my $content = '';

		### Get data for form or from body
		if ($env->{CONTENT_TYPE} =~ /application\/x-www-form-urlencoded/) {
			my $alldata = $req->body_parameters;

			# Parse encode type from parameters
			if (exists $alldata->{enctype}){
				$contentType = delete $alldata->{enctype};
			}
			if (exists $alldata->{DATA}){
				$content = delete $alldata->{DATA};
			}else{
				$content = $alldata->as_hashref;
			}

		} else {
			$content = $req->content();
		}

		### Parse data by content-type
		my $acceptedMimeType;
		if ($contentType){
			($acceptedMimeType) = grep( exists $Mime_types->{$_} , split(/;/, $contentType, 2));
		}else{
			$acceptedMimeType = 'text/plain'; # set default mime type
		}

		### Parsed data
		my $parsed;
		if ($content && $acceptedMimeType){
			$data = eval {$Mime_types->{$acceptedMimeType}->($content)};
			HTTP::Exception::400->throw(status_message => "Parser error: $@") if $@;
		}

	}elsif ($method eq 'GET'){
		$data = $req->query_parameters;		
	}

	$env->{'parsecontent.data'} = $data if $data;

	return $self->app->($env);
}

=head1 STORED PARAMS TO ENV (Fulfill the PSGI specification)

=over 4

=item parsecontent.data

Store parsed data from input content.

=back

=head1 TUTORIAL

L<http://psgirestapi.dovrtel.cz/>

=head1 AUTHOR

Vaclav Dovrtel, C<< <vaclav.dovrtel at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to github repository.

=head1 ACKNOWLEDGEMENTS

Inspired by L<https://github.com/towhans/hochschober>

=head1 REPOSITORY

L<https://github.com/vasekd/Plack-Middleware-ParseContent>

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Vaclav Dovrtel.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

=cut

1; # End of Plack::Middleware::ParseContent
