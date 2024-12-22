# Bean Mind Orderspace Ruby Client

:bomb: **This gem is under development, USE AT YOUR OWN RISK**

A Ruby client to connect and use the Orderspace API (https://apidocs.orderspace.com/).

![Orderspace Logo](orderspace-logo.png)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add orderspace-ruby

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install orderspace-ruby

## Usage

Before you start you will have to setup a _"private app"_ in Orderspace.

```https://[your_company_name].orderspace.com/admin/apps/new```

In the form you will have to name the app and add a contact email address. Once you've done so, you will be given
a `client_id` and a `client_secret`. These two values are the ones you'll need when using this client.

### Initialising the client

The client is initialised with the `client_id` and the `client_secret` you acquired when setting up a new private app
in Orderspace as described above.

```ruby
client = Orderspace::Client.with(client_id, client_secret)
```

This will use the OAuth endpoint to grab the `auth token` and insert it in the headers for each subsequent call to the API.

Please note that Orderspace's Auth tokens work for a limited time.

:warning: DO NOT STORE YOUR AUTH TOKEN AS IT MIGHT NOT WORK IN LATER REQUESTS! :warning:

### Customers Endpoint

Things you can do with the customers endpoint.

#### Creating a customer

```ruby
customer = Orderspace::Structs::Customer.new.tap do |c|
  c.company_name = "Your Customers Company"
  # other attributes you might want to set.
end

# This customer will have an id as assigned by Orderspace during creation
created_customer = client.customers.create_customer(customer)
```

#### Listing customers

Listing customers will return a `Orderspace::Structs::CustomerList` struct.

```ruby
customers = client.customers.list_customers
```

You can also pass options to narrow your list down like so:

```ruby
options = { query: { limit: 42, status: 'active' } }
customers = client.customers.list_customers(options)
```

Refer to the [list customers](https://apidocs.orderspace.com/#list-customers) endpoint documentation for further options you can use.

#### Getting a customer

```ruby
customer_id = 'cu_dnwz8gnx'
customer = client.customers.get_customer(customer_id)
```

#### Updating a customer

To update a customer you will have to first get the customer (so that the id and other fields are properly populated).

```ruby
customer = client.customers.get_customer(customer_id)
customer.company_name = "New Company Name"

updated_customer = client.customers.edit_customer(customer)
```

### Orders Endpoint

Things you can do with orders.

#### List orders

Listing orders will return a `Orderspace::Structs::OrderList` struct.

```ruby
orders = client.orders.list_orders
```

You can also pass options to narrow your list down like so:

```ruby
options = { query: { limit: 20, status: 'preorder' } }
orders = client.orders.list_orders(options)
```

Refer to the [list orders](https://apidocs.orderspace.com/#list-orders) endpoint documentation for further options you can use.

#### Getting an order

```ruby
order_id = 'or_l5DYqeDn'
order = client.orders.get_order(order_id)
```

### Webhooks Endpoint

Things you can do with webhooks.

#### Creating a webhook

```ruby
webhook = Orderspace::Structs::Webhook.new.tap do |w|
  w.endpoint = 'https://your/uri/to/receive/the/event'
  w.events = %w[order.created dispatch.created]
end

new_webhook = client.webhooks.create(webhook)
```

#### Listing webhooks

Listing webhooks will return a `Orderspace::Structs::WebhookList` struct.

```ruby
webhooks = client.webhooks.list_webhooks
```

#### Getting a webhook

```ruby
webhook_id = 'wh_o9ernm4p'
webhook = client.webhooks.get_webhook(webhook_id)
```

#### Updating a webhook

To update a webhook you will have to first get the webhook (so that the id field is properly populated).

```ruby
webhook = client.webhooks.get_webhook(webhook_id)
webhook.events = %w[order.created order.deleted]

updated_webhook = client.webhooks.update_webhook(webhook)
```

#### Deleting a webhook

To delete a webhook you will have to first get the webhook (so that the id field is properly populated).

It will return a `Orderspace::Structs::Webhook` struct with only it's `id` and `deleted` attributes as a confirmation.

```ruby
webhook = client.webhooks.get_webhook(webhook_id)
deleted = client.webhooks.delete_webhook(webhook)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bean-mind/orderspace-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/orderspace-ruby/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Orderspace::Ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ecomba/orderspace-ruby/blob/main/CODE_OF_CONDUCT.md).
