# 研修

## 資料

研修資料ドキュメント  
[doc](https://docs.google.com/document/d/1FXNSqwIKe-nEdo6YZdaV-udLnd1oKV6XxlZ7SuT_yKU/edit)

画面遷移図（参考）  
[figma](https://www.figma.com/file/EDu4fCsjIgVB4fkORBP4w8/kensyu?node-id=0%3A1)

ER図  
[ER](https://drive.google.com/file/d/1nSC0CR6MFjV5bqcC1Vbo6FUVvA6cEO_o/view?usp=sharing)

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
