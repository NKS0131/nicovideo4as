# Niconico API Updates

このドキュメントは、nicovideo4asライブラリで行われたAPI更新について説明します。

## 更新概要

Niconico動画のAPIが大幅に変更されたため、このライブラリも最新のAPIに対応するよう更新されました。

### 主な変更点

1. **廃止されたAPIエンドポイントの更新**
2. **新しいAPI形式への対応**
3. **後方互換性の維持**

## 廃止されたAPI

以下のAPIは廃止され、使用できなくなっています：

### 1. getflv API (廃止)

- **旧URL**: `https://flapi.nicovideo.jp/api/getflv/`
- **影響**: `ApiGetFlvAccess` クラス
- **代替方法**: `WatchVideoPage` と `WatchDataAnalyzer` を使用してください
- **詳細**: 動画情報は視聴ページ (`https://www.nicovideo.jp/watch/{video_id}`) のHTMLに埋め込まれたJSONから取得します

```actionscript
// 推奨される使用方法
var watchPage:WatchVideoPage = new WatchVideoPage();
watchPage.addEventListener(WatchVideoPage.WATCH_SUCCESS, function(e:Event):void {
    var analyzer:WatchDataAnalyzer = new WatchDataAnalyzer();
    analyzer.analyze(watchPage);
    
    // GetFlvResultAnalyzer形式で使用する場合
    var adapter:WatchDataAnalyzerGetFlvAdapter = new WatchDataAnalyzerGetFlvAdapter();
    adapter.wrap(analyzer);
    // これで既存のGetFlvResultAnalyzerインターフェースで利用可能
});
watchPage.watchVideo(videoId, false);
```

### 2. getwaybackkey API (更新)

- **旧URL**: `https://flapi.nicovideo.jp/api/getwaybackkey`
- **新URL**: `https://nvapi.nicovideo.jp/v1/comment/getwaybackkey`
- **影響**: `ApiGetWaybackkeyAccess` クラス
- **状態**: エンドポイントを更新済み
- **注意**: 新しいエンドポイントでも将来的に変更される可能性があります

### 3. getbgm API (廃止)

- **旧URL**: `https://flapi.nicovideo.jp/api/getbgm`
- **影響**: `ApiGetBgmAccess` クラス
- **状態**: 廃止（ニコ割機能は現在利用不可能と思われる）
- **注意**: このAPIは後方互換性のために残されていますが、正常に動作しない可能性があります

## 新しいAPI形式

### Watch Page API

動画視聴ページから直接JSONデータを取得する方式が標準となりました。

#### データ取得元の変遷

1. **旧形式**: `<div id="watchAPIDataContainer">` (廃止)
2. **中間形式**: `<div id="js-initial-watch-data" data-api-data="...">` (一部利用可能)
3. **新形式**: `<div id="js-initial-watch-data" data-client-data="...">` (現行)

`WatchVideoPage` クラスはこれらすべての形式に対応しています。

#### JSON構造

新しいAPI形式のJSONには以下の情報が含まれます：

- `video`: 動画情報（ID、タイトル、説明文、長さ、投稿日時など）
- `owner`: 投稿者情報（ID、ニックネーム、アイコンURLなど）
- `channel`: チャンネル情報（存在する場合）
- `viewer`: 視聴者情報（プレミアム会員かどうかなど）
- `comment`: コメント関連情報（サーバーURL、スレッドIDなど）
- `media`: 動画配信情報（DMC session情報など）

## DMC (Direct Media Cloud)

### 概要

DMCはNiconicoの新しい動画配信システムです。従来のSmile Serverに代わり、より高品質で安定した配信を提供します。

### 対応状況

- `DmcInfoAnalyzer`: DMC配信情報の解析
- `ApiDmcAccess`: DMCセッションの作成・維持
- `DmcResultAnalyzer`: DMCレスポンスの解析

### セッション管理

DMC配信では、視聴開始時にセッションを作成し、定期的にハートビートを送信する必要があります。

```actionscript
// セッション作成
var dmcAccess:ApiDmcAccess = new ApiDmcAccess();
dmcAccess.createDmcSession(movieId, apiUrl, sessionData);

// ハートビート送信（40秒ごと推奨）
dmcAccess.beatDmcSession(sessionId, sessionData);
```

## 継続して使用できるAPI

以下のAPIは現在も使用可能です：

### 1. getthreadkey API
- **URL**: `https://ext.nicovideo.jp/api/getthreadkey`
- **クラス**: `ApiGetThreadkeyAccess`
- **用途**: 公式動画のコメント取得時に必要なスレッドキーを取得

### 2. getthumbinfo API
- **URL**: `https://ext.nicovideo.jp/api/getthumbinfo/`
- **クラス**: `ApiGetThumbInfoAccess`
- **用途**: 動画のサムネイル情報を取得

### 3. 検索API
- **URL**: `https://snapshot.search.nicovideo.jp/api/v2/snapshot/video/contents/search`
- **クラス**: `ApiSearchAccess`
- **用途**: 動画検索

### 4. getrelation API
- **URL**: `https://ext.nicovideo.jp/api/getrelation`
- **クラス**: `ApiGetRelation`
- **用途**: 関連動画の取得

## 移行ガイド

### 既存コードからの移行

#### GetFlvを使用している場合

```actionscript
// 旧コード
var getflv:ApiGetFlvAccess = new ApiGetFlvAccess();
getflv.getAPIResult(videoId, false);

// 新コード (推奨)
var watchPage:WatchVideoPage = new WatchVideoPage();
watchPage.addEventListener(WatchVideoPage.WATCH_SUCCESS, function(e:Event):void {
    var analyzer:WatchDataAnalyzer = new WatchDataAnalyzer();
    analyzer.analyze(watchPage);
    
    // 既存のGetFlvResultAnalyzerベースのコードをそのまま使う場合
    var adapter:WatchDataAnalyzerGetFlvAdapter = new WatchDataAnalyzerGetFlvAdapter();
    adapter.wrap(analyzer);
    
    // adapter を GetFlvResultAnalyzer として使用可能
    var threadId:String = adapter.threadId;
    var userId:String = adapter.userId;
    // ...
});
watchPage.watchVideo(videoId, false);
```

### 注意事項

1. **User-Agent**: 最新のChrome User-Agentを使用するよう更新されました
2. **HTTPS**: すべてのAPI通信はHTTPSで行われます
3. **エラーハンドリング**: 廃止されたAPIを使用すると予期しないエラーが発生する可能性があります

## 参考資料

- [Qiita: ニコニコ動画のコメント取得API変更について](https://qiita.com/gcrtnst/items/5bd1358af8cc636e3f4f)
- [Niconicome GitHub Repository](https://github.com/Hayao-H/Niconicome)

## 今後の展望

NiconicoのAPIは今後も変更される可能性があります。このライブラリは可能な限り後方互換性を維持しながら、新しいAPIに対応していく予定です。

---

最終更新: 2025-10-27
