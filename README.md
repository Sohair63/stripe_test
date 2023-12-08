# Stripe Test

This is for a Stripe test implementation

## Development Setup

1. Clone the project repository.
2. Install Ruby 3.2.1.
3. Go to the project directory.
4. Run `bundle install`
5. Run `rails db:create`
6. Run `rails db:migrate`
7. Run `rails server` to spin up the project.

### Development/Test Credential Keys

```bash
    touch config/credentials/development.key
    echo -n "98426d8fc9165e3d4b10d04b1030d584" > config/credentials/development.key

    touch config/credentials/test.key
    echo -n "d1de1890edffc13e3fd6894654207bec" > config/credentials/test.key
```

# How to test?

1. Setup your stripe account, if you want to test it. Else you won't be able to test webhooks. But still can test APIs.
2. Copy the secret key and put it in credentials file.

## Creating Charges

1. Use postman OR curl with URL `http://localhost:3000/charges`
2. Use the following JSON params
    ```
    {
        "charge": {
            "amount": 1000,
            "currency": "usd",
            "source": "tok_visa"
        }
    }
    ```
3. It should return you 200 (OK) response with the stripe charge object

## Creating Refunds

1. Use postman OR curl with URL `http://localhost:3000/charges/refund`
2. Use the following JSON params
    ```
    {
    "refund": {
        "charge": "{CHARGE_ID}"
    }
}
    ```
4. Replace {CHARGE_ID} with the one returned while creating charges.
3. It should return you 200 (OK) response with the stripe charge object

## Testing webhooks (if you setup your own Stripe account)

1. Install ngrok.
2. Run the server `rails server`
3. Run `ngrok http 3000`
4. Copy the forwarding URL and put it in the Stripe UI for webhook details.
5. Copy the webhook secret from Stripe and put it in credentials using `EDITOR=nano rails credentials:edit --environment=development`
6. Select events for charge.succeeded & charge.refunded while creating webhook.
