# README

### Getting Started
* download foreman
* bin/dev to run dev server
* DON'T FORGET TO PASS MASTER KEY AT `config/credentials/development.key`

### API/Documentation issues

* dunkin.xml sample has mismatched zipcode with the state
* the [create accounts endpoint](https://docs.methodfi.com/api/core/accounts/create/)
requires a "type" field for liabilities but not for "ach"?

* the [create accounts page](https://docs.methodfi.com/api/core/accounts/create/) forgets
to include the required "type" attribute in the liability example

* kept getting cryptic "amount" error creating payments
"Invalid amount received. Amounts should be integers expressed as decimals."
