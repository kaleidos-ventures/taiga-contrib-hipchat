Taiga contrib HipChat
=====================

The Taiga plugin for HipChat integration.

Installation
------------

### Taiga Back

Clone this repo, then copy back/taiga_contrib_hipchat folder in the root of your Taiga back project.

Modify your settings/local.py and include the line:

```python
  INSTALLED_APPS += ["taiga_contrib_hipchat"]
```

Then run the migrations to generate the new need table:

```bash
  python manage.py migrate taiga_contrib_hipchat
```

### Taiga Front

Download in your `dist/js/` directory of Taiga front the `taiga-contrib-hipchat` compiled code:

```bash
  cd dist/js
  wget "https://raw.githubusercontent.com/taigaio/taiga-contrib-hipchat/master/front/dist/hipchat.js"
```

Include in your dist/js/conf.json in the contribPlugins list the value `"/js/hipchat.js"`:

```json
...
    "contribPlugins": ["/js/hipchat.js"]
...
```
