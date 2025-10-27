# 変更履歴 (CHANGELOG)

## 最新版 (2025-10-27)

### 重要な変更

Niconico動画のAPI仕様変更に対応し、ライブラリを最新のAPIに対応させました。

### 追加・変更

#### API エンドポイント
- ✅ `ApiGetWaybackkeyAccess`: エンドポイントを `nvapi.nicovideo.jp` に更新
- ⚠️ `ApiGetFlvAccess`: 廃止予定（`WatchVideoPage` + `WatchDataAnalyzer` を使用）
- ⚠️ `ApiGetBgmAccess`: 廃止予定（ニコ割機能は利用不可能）

#### 機能強化
- `WatchVideoPage`: 複数のJSON形式に対応
  - 旧形式: `watchAPIDataContainer`
  - 中間形式: `js-initial-watch-data` の `data-api-data`
  - 新形式: `js-initial-watch-data` の `data-client-data`
- User-Agentを Chrome 120 に更新
- ネストされたレスポンス構造への対応強化

#### ドキュメント
- `API_UPDATES.md`: 詳細なAPI変更ガイドを追加
- `README.md`: API変更の概要を追加
- クラス・メソッドのドキュメントを大幅に改善

### 廃止予定の機能

以下のAPIは廃止されていますが、後方互換性のために残されています：

1. **getflv API**
   - 状態: 使用不可
   - 代替: `WatchVideoPage` と `WatchDataAnalyzer` を使用
   
2. **getbgm API**
   - 状態: 使用不可
   - 代替: なし（ニコ割機能自体が利用不可）

### 移行方法

#### getflv API からの移行

```actionscript
// 旧: getflv API を直接使用
var getflv:ApiGetFlvAccess = new ApiGetFlvAccess();
getflv.addEventListener(Event.COMPLETE, onGetFlvComplete);
getflv.getAPIResult(videoId, false);

// 新: WatchVideoPage を使用
var watchPage:WatchVideoPage = new WatchVideoPage();
watchPage.addEventListener(WatchVideoPage.WATCH_SUCCESS, function(e:Event):void {
    var analyzer:WatchDataAnalyzer = new WatchDataAnalyzer();
    analyzer.analyze(watchPage);
    
    // 既存コードとの互換性を保つ場合
    var adapter:WatchDataAnalyzerGetFlvAdapter = new WatchDataAnalyzerGetFlvAdapter();
    adapter.wrap(analyzer);
    
    // adapter を GetFlvResultAnalyzer として使用可能
    var threadId:String = adapter.threadId;
    var userId:String = adapter.userId;
    // ...
});
watchPage.watchVideo(videoId, false);
```

### 後方互換性

- 既存のインターフェースは変更していません
- `WatchDataAnalyzerGetFlvAdapter` により段階的な移行が可能
- 古いJSON形式にも引き続き対応

### 技術詳細

#### 対応するAPIフォーマット

1. **旧形式** (廃止済み)
   ```html
   <div id="watchAPIDataContainer" style="display:none">{...}</div>
   ```

2. **中間形式** (一部利用可能)
   ```html
   <div id="js-initial-watch-data" data-api-data="{...}">
   ```

3. **新形式** (現行)
   ```html
   <div id="js-initial-watch-data" data-client-data="{...}">
   ```

#### JSON構造の例

新しいAPI形式では、以下のような構造のJSONが返されます：

```json
{
  "video": {
    "id": "sm12345678",
    "title": "動画タイトル",
    "description": "説明文",
    "duration": 180,
    ...
  },
  "owner": {
    "id": "12345",
    "nickname": "投稿者名",
    ...
  },
  "comment": {
    "server": {
      "url": "wss://..."
    },
    "threads": [...]
  },
  "media": {
    "delivery": {
      "movie": {
        "session": {...}
      }
    }
  }
}
```

### 動作確認環境

- ActionScript 3.0
- Flash Player 11.0以降

### 既知の問題

- ニコ割機能 (`ApiGetBgmAccess`) は利用できません
- 一部の古いAPIエンドポイントは将来的に完全に削除される可能性があります

### 参考リンク

- [Qiita: ニコニコ動画のコメント取得API変更について](https://qiita.com/gcrtnst/items/5bd1358af8cc636e3f4f)
- [Niconicome (参考実装)](https://github.com/Hayao-H/Niconicome)
- [API_UPDATES.md (詳細ガイド)](API_UPDATES.md)

---

## 以前のバージョン

以前の変更履歴については Git のコミット履歴を参照してください。
