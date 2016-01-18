# Localization

## Steps

### add this into the middleware in app.coffee
    
    res.locals.variable_name = res.__("key")

### add the translation correspoding to "key" to locales/*.json.
### replace strings with locaization variable

    <%= @variable_name %>