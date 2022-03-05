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

### AWS

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

### GCP

---

Cloudquery uses a credential file which can be obtained from the [Google Cloud Console](https://developers.google.com/workspace/guides/create-credentials#create_credentials_for_a_service_account). Do make sure a user's Cloud Resource Manager API for `myproject` is enabled by checking the [Resource Manager](https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com).

For a multi-user application, you should copy the contents of each `json` credential file and save them in a string column, for instance.

```json
{
  "type": "service_account",
  "project_id": "myproject",
  "private_key_id": "82f6d09efb316fd6163143224hjk234b,m42",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBAgjhhjjhjGHJngvjhgGJHghkGVHMGu48+EAAoIBAQC6mV+IwUX6GOCY\nUE5YjHT0Jxgqt/oO2gJ6SFbtOioUNwsXxk+bhJH<B+KJGUKHJB78+o8/jf++\n4YKuTLiu4tzYKMdOh0LGxtQA0Alu+CqcsY1pNGVqNk9f/HKJH<GJL8973420\nNB9ofOTjYIIQhoYMqzmMUHKBB<8oyugjhlfd73iHJGkgjg42VIGN71u6yZozNGU\n16Fp6anbQSOrI8lo0aom5rSZLLUD/m+nb7cdMVl6/B1+GB0WO7I96kooduPZLNZm\nJ3RT892O13O2h3jMxXdpgUCVMkpeMJ8YNv0U+rHDgCzivuqjQllQBhg6rw9yrgWG\nagknl4TrAgMBAAECggEABKzXEewVvsBk0Cwi6mEKhRt9pYRahYi8yyeI1gTBDSSb\n6IqVb2BoT6QnLzxRhDeOqsdE9CvK7wK1x6iKx6cwcWFJuzi6VaNZ7vUIVsTfl6Is\nHyTrsBkZ+WFG99a5F9zRlwR3LFUzb1n5kpsZtlp6uZ+vYo6cSTD5DiUBO2+j3/gK\n1iOgaL/oQCsrltTOMaYBzCknwZ1NDkprSSNIU0gCaQcWq5d/X7tzygxdVuGJ2L8p\n6dXJVC1UpiHKcDWNkuWvRHrrO1nztU1CKwUMz3vcrIgKkL3yFels4O+thgWzBUX7\naIbWdIUBw4NJ4VMTV9RE2B4igriD55KvuMXHQRHrUQKBgQD5rQ/VoGjGRruoVESi\ntcXQDoyJQAg4OSghUNh4pRGqtUDOdiuee9GkqQrMLhJIywEmPB/viUjcXpa34M0j\nEhG5TEsRhmekETYeozouOzkNQh/8wSHq5dvk33GATHHECEq8ZETuvXy9z/3aDq9u\nFLSppNIkJbB4B1pP8we6eW2L1wKBgQC/U0+TeQ9csKVhfEAzGaJnv7SSOzG3DvwQ\nD9XFhh3kK7Etz+pMGSYjMSDqGFXdrcMvsdQelG3REqlInZslmaON9zSgHQq38jhI\nFp15xk5HCjBHIPiaFcLIvRzGkTbaD+Un2LOKO4M1qcG3cu/joGMspXAJJut5KNF7\nCfOb4M6NDQKBgHPYYKh2LScSWq/XqaD1RjsrBPoJw8aSfpQ2troDnRbf0pn5KnP2\nb2c/J8tk9Qbhaj8bVpYF1NCq8rOOkp/bGm4ngA05l40Aj2PXyH7665XDQKQ92Ebt\nMAIZysgEsCSM1GBlBbbgJKjNgLNUbQFeihTMbNRoyGBoyPafhM542OMxAoGARaBh\n8z85MfgvF10KWA5aJfuEETttijrvzECXAT0fn6uu3QcvMuZsFJ6KZebZSMU1pSPI\nGCDYHh/2bzC8B2D0PnPaOPKYtfx2MvXX9TsPvZadnyUGk7ybmEYKNNEf7xedw3R/\nUiz6QQs4LjSrzGDP9q12Kj55rywFoAstFmsnf/kCgYADQYdNX5jGlC70NJa0+Tn1\ndT/wghJkBvZczI4/XWG6irrcXAqef+GVYkHgmvjmnbHKGjhgvghkHGkkj\nKgpUZgmmIyRAQvjsAYEtlkinRH2rnfimpyoJ0GPz36QkGMO8Tg0gMFU10P7WLKdw\nflhwebjGHkugjhvbKJHBghiviy==\n-----END PRIVATE KEY-----\n",
  "client_email": "myproject@myproject.iam.gserviceaccount.com",
  "client_id": "331492471020045136432",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/myproject%myproject.iam.gserviceaccount.com"
}
```

You should add the following environment variable, where `username` is your machine's host user to your `.profile` file:

```shell
# Users/username/.profile
export GOOGLE_APPLICATION_CREDENTIALS=/Users/username/.gcp/credentials.json
```

The gem will use the variable above as a constant. This gem will generate/replace the `credentials.json` specific to the current user in the location `/Users/username/.gcp/credentials.json` at fly before `cloudquery fetch gcp` is executed.

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
