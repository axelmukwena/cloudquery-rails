# Cloudquery for Rails

A Ruby wrapper which abstracts and handle [Cloudquery](https://github.com/cloudquery/cloudquery) commands with ease.

## Installation

This gem requires Cloudquery. Checkout their documentation at https://cloudquery.io/ to get started.

Once installed, you need to generate a `config.hcl` file that will describe which cloud provider you want to use and which resources you want CloudQuery to ETL.

You can do this by running the command `cloudquery init provider` (example below) in your Rails project's root folder:
```
$ cloudquery init aws
```

If you already have the `config.hcl`, just copy it to your project's root folder.

Remember to update your `dsn` string to connect to your projects database:

```hcl

dsn = "postgres://postgres:pass@localhost:5432/example_development?sslmode=disable"

// With history and TimescaleDB enabled
dsn = "tsdb://postgres:pass@localhost:5432/example_development?sslmode=disable"
```

---

Add this line to your application's Gemfile:

```ruby
gem 'cloudquery'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cloudquery

## Getting started

>> #### AWS

---

For this provider, a `credentials` and a `config` file are generated at the users root directory: `Users/username/.aws/credentials` and `Users/username/.aws/config`.

Depending on how you store your credentials, either in `.env` file or in database encrypted column, find below:

___Default Profile___

```ruby
aws_credentials = {
  aws_access_key_id: @aws_credentials.aws_access_key_id,
  aws_secret_access_key: @aws_credentials.aws_secret_access_key,
  region: @aws_credentials.aws_region,  # default region = us-west-2
}

Cloudquery.aws(aws_credentials)
```


```dotenv
# ~ Users/username/.aws/credentials
[default]
aws_access_key_id = D4583BBC129B3
aws_secret_access_key = a8x2YsMFOMDNGk38CsT4UNHKEG4mjLFz
```

```dotenv
# ~ Users/username/.aws/config
[default]
region = us-west-1
```

___Temp Profile___


```ruby
aws_credentials = {
  aws_access_key_id: @aws_credentials.aws_access_key_id,
  aws_secret_access_key: @aws_credentials.aws_secret_access_key,
  aws_session_token: @aws_credentials.aws_session_token,
  region: @aws_credentials.aws_region,  # default region = us-west-2
}

Cloudquery.aws(aws_credentials)
```

```dotenv
# ~ Users/username/.aws/credentials
[temp]
aws_access_key_id = D4583BBC129B3
aws_secret_access_key = a8x2YsMFOMDNGk38CsT4UNHKEG4mjLFz
aws_session_token = rmR7nwmSdkUv7LpCUD9iErJmx9jUM4dd
```

```dotenv
# ~ Users/username/.aws/config
[default]
region = us-west-1
```

You can read up on how AWS consumes credentials [here](https://aws.github.io/aws-sdk-go-v2/docs/configuring-sdk/#creating-the-credentials-file).

>> #### GCP

---

For this provider...

### Querying extracted data from Database

Lets say you do ETL on multiple aws account and store the data. You can query the database to view all the `aws_s3_buckets` where `account_id = "123456789012"`:
```ruby

aws_accounts_table = ActiveRecord::Base.connection.data_source_exists? 'aws_s3_buckets'

if aws_accounts_table
  aws_accounts_sql = "SELECT * FROM aws_s3_buckets WHERE account_id = '123456789012'"
  @aws_accounts = ActiveRecord::Base.connection.execute(aws_accounts_sql).to_a
end
```

Or querying from history tables
```ruby
aws_accounts_table = ActiveRecord::Base.connection.data_source_exists? 'history.aws_s3_buckets' 

if aws_accounts_table
  aws_accounts_sql = "SELECT * FROM history.aws_s3_buckets WHERE account_id = '123456789012'"
  @aws_accounts = ActiveRecord::Base.connection.execute(aws_accounts_sql).to_a
end
```

## Development

---

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

---

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cloudquery-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/cloudquery-rails/blob/main/CODE_OF_CONDUCT.md).

### Developer Notes

---

#### Updating `cloudquery.go`
After edit, go to Go files root folder and build/create the shared object binary
```
$ cd lib
$ go build -o cloudquery.so -buildmode=c-shared cloudquery.go
```
Go back to gem root folder, and do more as suit
```
$ cd -
// $ gem build cloudquery.gemspec
...
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cloudquery Rails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cloudquery-rails/blob/main/CODE_OF_CONDUCT.md).
