package lianliankan {

    import flash.display.Sprite;

    public class LLK_Controller extends Sprite {
        private static var _instance:LLK_Controller;
        private var _view:LLK_View = LLK_View.instance;
        public function LLK_Controller()
        {

        }
        public static function get instance():LLK_Controller
        {
            if (_instance == null)
            {
                _instance = new LLK_Controller();
            }
            return _instance;
        }
        public function init(stage: Sprite):void
        {
            _view.init(stage);
        }
    }

}
