# カルガモカウンター API仕様

## 概要

Flutterアプリから送信された打刻データを、Google Apps Script（GAS）で受け取り、Googleスプレッドシートの `logs` シートへ保存する。


## 送信先

GASのウェブアプリURLを使用する。

```text
https://script.google.com/macros/s/xxxxxxxxxxxxxxxx/exec
```


## メソッド

POST


## Content-Type

application/json


## 送信データ形式

```json
{
  "logs": [
    {
      "driver_name": "テスト太郎",
      "driver_phone": "09000000000",
      "device_id": "atom-001",
      "press_count": 1,
      "interval_ms": 1200,
      "recorded_at": "2026-04-25T10:00:00+09:00",
      "memo": "Flutter送信テスト"
    }
  ]
}
```


## 項目説明

| 項目           | 内容               |
| ------------ | ---------------- |
| driver_name  | 運転者名             |
| driver_phone | 運転者の電話番号         |
| device_id    | Atom Liteなどの端末ID |
| press_count  | 押下回数             |
| interval_ms  | 前回押下からの経過時間（ミリ秒） |
| recorded_at  | スマホ側で記録した時刻      |
| memo         | メモ               |


## 保存先シート

シート名：logs

列構成：
| 列 | 項目           |
| - | ------------ |
| A | id           |
| B | driver_name  |
| C | driver_phone |
| D | device_id    |
| E | press_count  |
| F | interval_ms  |
| G | recorded_at  |
| H | created_at   |
| I | memo         |


## 成功レスポンス

HTTPステータス：200

```json
{
  "status": "success",
  "saved_count": 1
}
```


## 失敗レスポンス

HTTPステータス：500

```json
{
  "status": "error",
  "message": "エラー内容"
}
```


## 送信例

curl例：

```bash
curl -X POST https://script.google.com/macros/s/xxxx/exec \
  -H "Content-Type: application/json" \
  -d '{ "logs": [...] }'
```


## 現在の実装状況

- Thunder ClientからのPOST送信確認済み
- FlutterアプリからのPOST送信確認済み
- Googleスプレッドシートへの保存確認済み
- 現在はテストデータ送信で動作確認済み
- 今後はスマホ内に一時保存した複数ログを、送信ボタンで一括送信する形式にする


## 注意事項

- recorded_at はAtom Liteではなく、スマホアプリ側で付与する
- GAS側の created_at はスプレッドシートに保存した時刻
- 送信成功後、スマホ側の未送信データは削除または送信済みに更新する



## 注意事項（デプロイ）

※デプロイ時は「全員（匿名ユーザー）」アクセス可能にすること


