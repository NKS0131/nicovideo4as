package org.mineap.nicovideo4as.analyzer {
    /**
     * DMCセッション作成のレスポンスを解析するクラス
     * 
     * DMC APIからのレスポンスJSON (セッション情報) を解析し、
     * セッションIDや動画URLなどの重要な情報を抽出します。
     * 
     * レスポンス構造:
     * {
     *   "data": {
     *     "session": {
     *       "id": "セッションID",
     *       "content_uri": "動画のURL",
     *       ...
     *     }
     *   }
     * }
     * 
     * @author Various contributors
     */
    public class DmcResultAnalyzer {
        private var _result: Object;

        public function DmcResultAnalyzer() {
            /** do nothing */
        }

        /**
         * Analyze result from Dmc Session
         * @param result
         */
        public function analyze(result: String): void {
            this._result = JSON.parse(result);
        }

        public function get isValid(): Boolean {
            return this._result != null;
        }

        public function get sessionId(): String {
            return this._result.data.session.id;
        }

        public function get session(): Object {
            return this._result.data;
        }

        public function get contentUri(): String {
            return this._result.data.session.content_uri;
        }

        public function reset(): void {
            this._result = null;
        }
    }
}
