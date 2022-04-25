# 研修

## 資料

[doc](https://docs.google.com/document/d/1FXNSqwIKe-nEdo6YZdaV-udLnd1oKV6XxlZ7SuT_yKU/edit)

## セットアップ

基本的にはssh接続できるようにしておいてください

```bash
git clone git@github.com:minty1202/kensyu.git
make init
make up
```

## commit メッセージについて

コミットメッセージは以下のルールに基づいて行ってください

先頭に [add] [fix] [update] [remove] のうちどれかをつける

- fix: バグ修正
- add: 新規（ファイル）機能追加
- update: 機能修正（バグではない）
- remove: 削除（ファイル）

[ ] の後にissue番号をつける

実装した内容を一言でまとめる(日本語、英語かどちらでも良いです)

例 [update] #1 hogeのviewファイル追記
