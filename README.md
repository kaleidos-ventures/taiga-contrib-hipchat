Taiga contrib HipChat
=====================

The Taiga plugin for HipChat integration.

Installation
------------

#### Taiga Back

In your Taiga back python virtualenv install the pip package taiga-contrib-hipchat with:

```bash
  pip install taiga-contrib-hipchat
```

Modify your settings/local.py and include the line:

```python
  INSTALLED_APPS += ["taiga_contrib_hipchat"]
```

Then run the migrations to generate the new need table:

```bash
  python manage.py migrate taiga_contrib_hipchat
```

#### Taiga Front

Download in your `dist/js/` directory of Taiga front the `taiga-contrib-hipchat` compiled code:

```bash
  cd dist/js
  wget "https://raw.githubusercontent.com/taigaio/taiga-contrib-hipchat/$(pip show taiga-contrib-hipchat | awk '/^Version: /{print $2}')/front/dist/hipchat.js"
```

Include in your dist/js/conf.json in the contribPlugins list the value `"/js/hipchat.js"`:

```json
...
    "contribPlugins": ["/js/hipchat.js"]
...
```

How to use
----------

Follow the instructions on our support page [Taiga.io Support > Contrib Plugins > HipChat integration](https://taiga.io/support/hipchat-integration/ "Taiga.io Support > Contrib Plugins > HipChat integration")
