# JSON VAT

You'll likely have heard about the impending ~~doom~~ changes which will hit EU tech businesses in January 2015. At present, there is no government sponsored API for accessing the current VAT rates for a given country. This very simple Ruby client allows you to access up-to-date VAT rates for any EU country.

This uses the [jsonvat.com](http://jsonvat.com) service to obtain its data. Full details can be [seen here](http://github.com/adamcooke/vat-rates).

## Important notes

This information is provided on an as-is basis. The authors or contributors cannot be held responsible for its accuracy or completeness. You use the data provided by jsonvat.com entirely at your own risk.

The API returns the standard & reduced VAT rates for EU countries. In some circumstances, you may need to charge other rates for certain types of product. For a full list, see [this document](http://ec.europa.eu/taxation_customs/resources/documents/taxation/vat/how_vat_works/rates/vat_rates_en.pdf).

## Installation

```ruby
gem 'json_vat', '~> 1.0'
```

## Usage

You can look up the current rate for any country by providing it's ISO-3166-1-alpha2
code, like so.

```ruby
JSONVAT.country('GB').rate              #=> 20.0
JSONVAT.country('GB').rate(:reduced)    #=> 5.0
```

If you want to look up the rate for a different time:

```ruby
date = Date.new(2005, 1, 5)
JSONVAT.country('GB').rate_on(date)             #=> 20.0
JSONVAT.country('GB').rate_on(date, :reduced)   #=> 5.0
```

If a country doesn't exist, nil will be returned from the call to the `country`
method. If no rate is found, nil will be returned from the `rate` or `rate_on`
methods.

### Caching

By default, this will cache the contents of the rates array in a temporary file
in `/tmp/jsonvat.json`. If this file exists, any future reads will be taken from
this file.

```ruby
# Recache the rates from jsonvat.com. This should be scheduled to run on a semi
# regular basis. If you are setting this up on a cron, please run this at a random
# time to avoid load on our servers at peak times (like midnight).
JSONVAT.cache

# To download the current rates manually, you can use this method. This will return
# a string of the data currently available on jsonvat.com
JSONVAT.download

# Disable caching and always download the latest data from jsonvat.com
JSONVAT.perform_caching = false
```

If you need to change the cache path, you can do so with this command:

```ruby
JSONVAT.cache_backend.path = File.join('other', 'path', 'rates.json')
```

You can also create your own cache backends if you want to store data somewhere
other than on your file system. To do this, you need to create a class which
responds to the following methods:

* `read` - must return the cached data or nil if no data has been cached.
* `write(data)` - must write the data to the cache. Return value is not important.

You can find an example in the `lib/json_vat/file_cache_backend` path which is
the default cache used for file system storage.

Once you have created your class, you should set it as the cache backend.

```ruby
JSONVAT.cache_backend = MyCustomBackend.new
```
