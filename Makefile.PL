use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Plack::Middleware::ParseContent',
    AUTHOR           => q{Vaclav Dovrtel <vaclav.dovrtel@gmail.com>},
    VERSION_FROM     => 'lib/Plack/Middleware/ParseContent.pm',
    ABSTRACT_FROM    => 'lib/Plack/Middleware/ParseContent.pm',
    LICENSE          => 'Perl_5',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Plack::Request' => 0,
        'JSON::XS' => 0,
        'YAML::Syck' => 0,
        'HTTP::Exception' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Plack-Middleware-ParseContent-*' },
);
