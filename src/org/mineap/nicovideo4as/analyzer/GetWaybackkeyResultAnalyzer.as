package org.mineap.nicovideo4as.analyzer {
    /**
     * getWaybackkey APIレスポンスを解析するクラス
     * 
     * getWaybackkey APIは過去のコメントを取得する際に必要なwaybackkeyを提供します。
     * このクラスはAPIレスポンスからwaybackkeyを抽出します。
     * 
     * レスポンス形式: waybackkey=xxxxx
     * 
     * 注意: APIエンドポイントが nvapi.nicovideo.jp に変更されました。
     * 
     * @author shiraminekeisuke
     *
     */
    public class GetWaybackkeyResultAnalyzer {

        private var _waybackkey: String = null;

        private var WAYBACKKEY_PATTERN: RegExp = new RegExp("waybackkey=(.*)");

        /**
         *
         *
         */
        public function GetWaybackkeyResultAnalyzer() {
        }

        /**
         *
         * @param result
         * @return
         *
         */
        public function analyzer(result: String): Boolean {

            if (result == null) {
                return false;
            }

            var array: Array = WAYBACKKEY_PATTERN.exec(result);

            if (array != null && array.length > 1) {
                this._waybackkey = array[array.length - 1];
            }

            return true;

        }

        /**
         *
         * @return
         *
         */
        public function get waybackkey(): String {
            return this._waybackkey;
        }


    }
}