# README
## 起動の仕方
### サーバー起動まで
ローカルにclone
```
git clone　https://github.com/tateyama1201/u_test.git
```

```
cd u_test
```
サーバー起動
```
 bin/rails server
```

### ユーザー作成

コンソール起動
```
 bin/rails c
```

ユーザー作成(このユーザーでログインが可能)
```
User.create(name: #{任意の名前}, email: #{任意のemail}, password: #{任意のpassword})
```

## 備考
ブラウザを閉じるとログインが切れます。

テストがなく、エラーハンドリングがほぼありません。時間切れでした。よろしくお願いします。

