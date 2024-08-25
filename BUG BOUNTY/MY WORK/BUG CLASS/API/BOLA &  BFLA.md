==https://dsopas.github.io/MindAPI/play/#download-interactive ==


- Broken Object Level Authorization



![[Pasted image 20240825235643.png]]


- API retrive information from Backend using id (UID,username)
- Fails to confirm user's privilege which requesting API
	- eg . normal user doesnt have priv to fetch /admin/fetch_user_details.php


#### Example
```
const express = require('express');
const UserHandler = require('UserHandler');
const SecretsHandler = require('SecretsHandler');

const app = express();
const router = app.router;

router.get('/api/:userId/secrets', (req, res) => {
    const userId = req.params.userId;

    const user = UserHandler.getUserDetails(userId);
    const secrets = SecretsHandler.getSecretsByUser(user);

    return res.status(200).send({
        user,
        secrets,
    });
});

//...
```

- `:userId ` is like parameter in API , fetched using `req.params.userId`
- any user can get user,secret of other users

#### Mitigation
- user should get `userId ` from session,implement Access control
```
const express = require('express');
const UserHandler = require('UserHandler');
const SecretsHandler = require('SecretsHandler');

const app = express();
const router = app.router;

router.get('/api/secrets', (req, res) => {

    const userId = req.session.userId;
    if (!userId) {
        res.status(403).send('Unauthorized. You shall not hack!');
    }

    const user = UserHandler.getUserDetails(userId);
    const secrets = SecretsHandler.getSecretsByUser(user);

    return res.status(200).send({
        user,
        secrets,
    });
});
```

- having unpredictable user id obfuscation `/api/e48e13207341b6bffb7fb1622282247b/secrets/` (Not recommended)

- ==access control policy + an impeccable session==



- **Broken Function Level Authorization**
- normal user can perform actions using API
	- eg `DELETE /api/invites/25128`







