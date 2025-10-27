package org.mineap.nicovideo4as.analyzer {
    import org.mineap.nicovideo4as.WatchVideoPage;

    /**
     * 動画ページ(WatchPage)のJSON APIデータを解析するクラス
     * 
     * Niconico動画の視聴ページから取得したJSON形式のAPIデータを解析し、
     * アクセス可能な形式で保持する。
     * 
     * 対応するAPI形式:
     * - HTML5形式 (js-initial-watch-data data-api-data)
     * - 新形式 (js-initial-watch-data data-client-data)
     * - 旧形式 (watchAPIDataContainer) - 後方互換性のため
     * 
     * @author Various contributors
     */
    public class WatchDataAnalyzer {
        private var _result: Object;
        private var _isHTML5: Boolean = true;
        private var _done: Boolean = false;

        public function WatchDataAnalyzer() {
            /** do nothing */
        }

        /**
         * Analyze WatchAPI Data Container JSON
         * @param result WatchVideoPage
         */
        public function analyze(result: WatchVideoPage): void {
            this._result = result.jsonData;
            this._isHTML5 = result.isHTML5;
            this._done = true;
        }

        public function get data(): Object {
            return this._result;
        }
    }
}
