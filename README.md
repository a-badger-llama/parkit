# Vehicle Storage Location Finder

A Ruby on Rails API that helps find optimal storage locations for vehicles of
different lengths.

## Tech Stack

- Ruby 3.4.2
- Rails 8.0.2
- PostgreSQL
- Puma web server

## Making API Requests

The API accepts POST requests to find storage locations for vehicles. Here's how to
use it:

### Endpoint

```bash
POST https://rails-pjc8.onrender.com
```

The endpoint expects the following request structure:

```bash
curl -X POST "https://rails-pjc8.onrender.com" -H "Content-Type: application/json" -d '[
    {
      "length": 10,
      "quantity": 1
    },
    {
      "length": 20,
      "quantity": 2
    },
    {
      "length": 25,
      "quantity": 1
    }
]'
```
