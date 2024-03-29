# Josef

## What's This?

Josef is manage Google Group on Google Workspace cli tool. It can dump Google Groups, specific domain's in `domains.yml`. And, apply and dry run with dumped yaml.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'josef'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install josef

## Usage

### Environment Variables

You can configure setting for domains file and actor with environment valiables.

`GOOGLE_WORKSPACE_ACTOR` : Josef use Service Account Key, and Admin SDK. So, You must set Googlge Workspace Administrator's primary mail address.

`DOMAINS_FILE_PATH` : Google Group API is include domain in List Groups request. Josef is not manage Domains. You can configure josef manage target domains in yaml file. Please see `domains.yaml.sample`

### dump groups and members yaml file

```sh
josef dump
```

### dry run(show diff)

```sh
josef diff ./local_group_file.yml
```

### apply

```sh
josef apply ./local_group_file.yml
```

Josef can config exculusion group mail addresses.example

```yaml
---
exclued_groups:
  - hoge@ml.example.com
  - foo@example.com
```

```sh
josef apply ./local_group_file.yml --exclude ./excluded_groups.yml
```

## Notes

When the email address of a Google Group changes, josef will delete the Google Group with the old email address and create a Google Group with the new email address.
This is because the josef configuration file uses the Google Groups email address as the unique ID of the Google Groups, and although we considered using the internal ID available in the API, we decided not to implement it because it would make the configuration file less user-friendly. We considered using the internal ID available in the API, but decided not to implement it because it would not be a user-friendly configuration file. If you have a good idea, please create an Issue and let me know:)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/josef.

## Future

### Oauth Token?

This tool manages Google Groups based on yaml. Therefore, I think that the administrator of Google WorkSpace may run it in the local environment. If the purpose is achieved with the service account and you want to use oauth authentication, we will handle it.

### Domain Management?

I'm not thinking about domain management for now. It doesn't make sense to be able to add it (because it also requires changing the DNS server settings), and I think it's a little too big to be able to delete it.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
