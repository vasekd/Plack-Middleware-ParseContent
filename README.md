# NAME

Plack::Middleware::ParseContent - Parse content of input data by Content-Type header.

# SYNOPSIS

        use Plack::Middleware::ParseContent;

        builder {
                enable 'ParseContent', 'application/xyz' => sub{ return decode_xyz($_[1]) };
                mount "/" => sub { 
                        my ($env) = @_;

                        return [ 200, [ 'Content-Type' => 'text/plain' ], [ serialize($env->{'parsecontent.data'}) ] ];
                };
        };

# DESCRIPTION

Parse input content and save it to plack env as 'parsecontent.data'.

For complete RestAPI in Perl use: 

- Plack::App::REST
- Plack::Middleware::FormatOutput

# CONSTANTS

## DEFAULT MIME TYPES

- application/json
- text/yaml
- text/plain
- application/x-www-form-urlencoded

            As default two keys are expected: enctype and DATA.
            "enctype" is definition of type that is serialized in DATA.

# STORED PARAMS TO ENV (Fulfill the PSGI specification)

- parsecontent.data

    Store parsed data from input content.

# TUTORIAL

[http://psgirestapi.dovrtel.cz/](http://psgirestapi.dovrtel.cz/)

# AUTHOR

Václav Dovrtěl <vaclav.dovrtel@gmail.com>

# BUGS

Please report any bugs or feature requests to github repository.

# ACKNOWLEDGEMENTS

Inspired by [https://github.com/towhans/hochschober](https://github.com/towhans/hochschober)

# REPOSITORY

[https://github.com/vasekd/Plack-Middleware-ParseContent](https://github.com/vasekd/Plack-Middleware-ParseContent)

# COPYRIGHT

Copyright 2015- Václav Dovrtěl

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
