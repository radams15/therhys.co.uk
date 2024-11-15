Title: CSAW 2024 writeup: Charlie's Angels
Tags: ctf, csaw-2024, writeup
Published: 10/09/2024
Disabled: 1

---
# CSAW 2024 writeup: Charlie's Angels

This challenge was based around auditing open-source code.

The challenge was composed of two webservers - one accessible nodejs server which called an inaccessible python server.


Looking at the code of `app.py` shows there are two interesting routes: `/backup` which stores uploaded files to the server, and `/restore` which runs any script `request.args.get('id')` in the backups folder.

This, therefore, is our attack vector - upload a malicious script using the `/backup` route, then run it using `/restore`.

## Uploading the script

The problem is, we can't directly access the python server. We have to go through the nodejs server.

Unfortunately this is not as straightforward. The nodejs server has the routes `/angel` (both get and post), and `/restore`. The interesting route for uploading is the `/angel` post route:

    app.post('/angel', (req, res) => {
        for (const [k,v] of Object.entries(req.body.angel)) {
            if (k != "talents" && typeof v != 'string') {
                return res.status(500).send("ERROR!");
            }
        }
        req.session.angel = {
            name: req.body.angel.name,
            actress: req.body.angel.actress,
            movie: req.body.angel.movie,
            talents: req.body.angel.talents
        };
        const data = {
            id: req.sessionID,
            angel: req.session.angel
        };
        const boundary = Math.random().toString(36).slice(2) + Math.random().toString(36).slice(2);
        needle.post(BACKUP + '/backup', data, {multipart: true, boundary: boundary},  (error, response) => {
            if (error){
                console.log(error);
                return res.status(500).sendFile('public/html/error.html', {root: __dirname});
            }
        });
        return res.status(200).send(req.sessionID);
    });

As we can see here, all the data is checked to be a string, except for the "talents" key which is normally an array.

This data is then passed as it was sent directly into the `needle.post` call. This is our vector for attacking the nodejs server.

To see how to upload our data I looked in the source for needle at [https://www.npmjs.com/package/needle](https://www.npmjs.com/package/needle). Here, on line 58 is the code `if (part.buffer) return append(part.buffer, filename);`. This shows us that specifying a `buffer` key in the `talents` object allows us to upload arbitrary data to the server.

We also have to specify a `filename` key. For the `/restore` route to run the correct file this needs to be in the format `[SESSION_ID].py`. Session ID can be got from calling the `GET /angel` route and copying the `id` key, e.g:

    GET /angel
    {
      "id": "xQjGE1ZPUslL0tE2QsCQIl4AjWJjJPW1",
      "angel": {
        "name": "Natalie Cook",
        "actress": "Cameron Diaz",
        "movie": "Charlies Angels: Full Throttle",
        "talents": {
          "0": "Unarmed Combat",
          "1": "Driving",
          "2": "Helicopter Piloting",
          "3": "Disguise"
        }
      }
    }

We also need the HTTP session id (separate from the app session id), which can be copied from the cookies debug menu in your browser.


