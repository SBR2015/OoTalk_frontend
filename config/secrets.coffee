Secrets = {
  development: {
    db: process.env.MONGOLAB_URI
    key_base: "jUJDjum6uJV4ZVMZeYpwfuFAtfTLPb2KKNDdD4xejbwPpaxQbYzpnxXTCEwDyTVTK6VvWfLamEvn7QaqUyhC6Kw6isRAWuvLiRWkHsjC6LLHWHUyjvGyyGh7kJmc6REU"
    new_relic_license_key: "no license"
  }
  test: {
    db: "mongodb://travis:test@localhost:27017/mydb_test"
    key_base: "YHpVYaPtCWzoAy2YsRiEqTkdxCxiKReKhgALuAPdEm38qsZ3oHjoLgGH88ntmGVqyjsFMBGazCp6XMHijjrhqYvuw3zarqKGGMQnzqVJEKJJfsDKiFFvPH3pCgKrKQpX"
    new_relic_license_key: "no license"
  }
  production: {
    db: process.env.MONGOLAB_URI
    key_base: process.env.SESSION_KEY_BASE
    new_relic_license_key: process.env.NEW_RELIC_LICENSE_KEY
  }
}
module.exports = Secrets
