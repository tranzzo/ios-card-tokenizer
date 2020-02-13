## Token data encryption guide
If you are using `TranzzoTokenier.tokenizeEncrypt` method, in success response you will get a JSON object in form of

```json
    {
      "data": "${IV}:${CRYPTOGRAM}"
    }
``` 

You need to implement your own decryption algorithm to parse the token and additional card data from this response

`${CRYPTOGRAM}` is an encrypted json, that follows the following format
```json
    {
    "token": "",
    "expires_at": "",
    "card_mask": ""
    }
```
Encryption is executed using these parameters

| Name           | Value                                               |
| ------         | ------                                              |
| Format         | `base64_encode(${IV}):base64_encode(${CRYPTOGRAM})` |
| Algorithm      | AES-256 (AES/CBC/PKCS5Padding)                      |
| IV length      | 128 bits (16 bytes)                                 |
| Encryption key | `utf8_bytes(${SECRET_KEY})`                         |

To get your own `SECRET_KEY` you need to be signed up to Tranzzo and have access to your dashboard, where you can generate an API secret key. For more, visit our [documentation](https://cdn.tranzzo.com/tranzzo-api/index.html#introduction).
