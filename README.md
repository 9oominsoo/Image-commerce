# ImageCommerce
visit https://stark-badlands-07065.herokuapp.com/

## Install

### Clone the repository

```shell
git clone https://github.com/9oominsoo/Image-commerce.git
cd Image-commerce
```

### Ruby version

```shell
2.4.2
```

### Database 

```
PostgreSql
```


### Install dependencies

Using [Bundler](https://github.com/bundler/bundler) 

```shell
bundle install
```

### Set environment variables

To use Google OAuth2 fill out config/application.yml
```
GOOGLE_CLIENT_ID:
GOOGLE_CLIENT_SECRET:
```
### Initialize the database

```shell
rails db:create db:migrate 
```

## Serve

```shell
rails s
```
