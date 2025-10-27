package org.mineap.nicovideo4as.loader.api {
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLVariables;
    import flash.utils.setInterval;

    /**
     * DMC (Direct Media Cloud) セッションを管理するクラス
     * 
     * DMCはNiconicoの新しい動画配信システムです。
     * このクラスはDMCセッションの作成とハートビート送信を担当します。
     * 
     * 使用方法:
     * 1. createDmcSession() でセッションを作成
     * 2. 定期的(40秒ごと推奨)に beatDmcSession() でハートビートを送信
     * 3. セッションが有効な間、動画URLにアクセス可能
     * 
     * 注意:
     * - セッションは一定時間後に自動的に期限切れになります
     * - ハートビートを送信し続ける必要があります
     * - 複数の動画を同時に視聴する場合、それぞれにセッションが必要です
     * 
     * @author Various contributors
     */
    public class ApiDmcAccess extends URLLoader {
        private var movieId: String;
        private var apiUrl: String;

        public function ApiDmcAccess(request: URLRequest = null) {
            super(request);
        }

        /**
         * DMCセッションを作成する
         * 
         * 動画の視聴を開始する前に、このメソッドでセッションを作成する必要があります。
         * セッション作成に成功すると、content_uriが返され、そのURLから動画をダウンロードできます。
         * 
         * @param movieId 動画ID (例: "sm12345678")
         * @param apiUrl DMC APIのURL (WatchDataAnalyzerから取得)
         * @param session セッションパラメータ (DmcInfoAnalyzer.getSession()で生成)
         */
        public function createDmcSession(movieId: String, apiUrl: String, session: Object): void {
            var getAPIRequest: URLRequest;

            this.movieId = movieId;
            this.apiUrl = apiUrl;

            getAPIRequest = new URLRequest(apiUrl + "/?_format=json");
            getAPIRequest.method = "POST";
            getAPIRequest.data = JSON.stringify(session);
            getAPIRequest.requestHeaders = [new URLRequestHeader("Accept", "application/json"), new URLRequestHeader("Content-Type", "application/json"), new URLRequestHeader("Referer", "https://www.nicovideo.jp/watch/" + movieId), new URLRequestHeader("Origin", "https://www.nicovideo.jp")];

            this.load(getAPIRequest);
        }

        /**
         * DMCセッションのハートビートを送信する
         * 
         * セッションを維持するため、定期的(40秒ごと推奨)にこのメソッドを呼び出す必要があります。
         * ハートビートの送信に失敗すると、セッションが無効になり、動画のダウンロードができなくなります。
         * 
         * @param sessionId セッション作成時に返されたセッションID
         * @param session セッションパラメータ (作成時と同じもの)
         */
        public function beatDmcSession(sessionId: String, session: Object): void {
            var getAPIRequest: URLRequest;

            getAPIRequest = new URLRequest(this.apiUrl + "/" + sessionId + "?_format=json&_method=PUT");
            getAPIRequest.method = "POST";
            getAPIRequest.data = JSON.stringify(session);
            getAPIRequest.requestHeaders = [new URLRequestHeader("Accept", "application/json"), new URLRequestHeader("Content-Type", "application/json"), new URLRequestHeader("Referer", "https://www.nicovideo.jp/watch/" + this.movieId), new URLRequestHeader("Origin", "https://www.nicovideo.jp")];

            this.load(getAPIRequest);
        }
    }
}
