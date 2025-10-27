package org.mineap.nicovideo4as.loader.api {
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLVariables;

    /**
     * 過去ログ取得用のwaybackkeyを取得するAPIへのアクセスを担当するクラスです。
     * 
     * 注意: flapiエンドポイントは廃止されました。
     * 
     * @author shiraminekeisuke(MineAP)
     * @deprecated flapiエンドポイントは廃止されました。
     *
     */
    public class ApiGetWaybackkeyAccess extends URLLoader {

        // 注意: このエンドポイントは廃止されました
        // 代替エンドポイントに変更しました
        public static const NICO_API_GET_WAYBACKKEY_URL: String = "https://nvapi.nicovideo.jp/v1/comment/getwaybackkey";

        private var _url: String = NICO_API_GET_WAYBACKKEY_URL;

        /**
         *
         * @param request
         *
         */
        public function ApiGetWaybackkeyAccess(request: URLRequest = null) {
            super(request);
        }

        /**
         *
         * @param threadId
         *
         */
        public function getAPIResult(threadId: String): void {

            var variables: URLVariables = new URLVariables();
            variables.thread = threadId;

            var request: URLRequest = new URLRequest(_url);
            request.data = variables;
            request.method = "GET";

            this.load(request);

        }

        public function get url(): String {
            return _url;
        }

        public function set url(value: String): void {
            _url = value;
        }

    }
}