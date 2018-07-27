package lianliankan {
    public class LLK_Config {
        public static const BOARD_SIZE_X:int = 15;
        public static const BOARD_SIZE_Y:int = 10;
        public static const BOARD_SIZE:int = BOARD_SIZE_X * BOARD_SIZE_Y;
        public static const ORIGIN_X:int = 80;
        public static const ORIGIN_Y:int = 30;
        public static const OFFSET:int = 50;

        /**
         * 路径的最大转向次数
         * 出发算一次
         */
        public static const MAX_TURN_COUNT:int = 3;

        private static const CLS_PREFIX:String = "mmo.lianliankan.";

        public static function cls(clsName:String):String
        {
            return CLS_PREFIX + clsName;
        }

        public function LLK_Config()
        {

        }
    }

}
