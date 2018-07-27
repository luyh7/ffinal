package lianliankan {

    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class LLK_Model extends Sprite {

        private static var _instance:LLK_Model;
        private var _selectedIcon:MovieClip;
        private var _eliminateCount:int = 0;
        private var _chessBoardMatrix:Array;
        private var _track:Object;
        private const MOVE_START = 0;
        private const MOVE_UP = 1;
        private const MOVE_RIGHT = 2;
        private const MOVE_DOWN = 3;
        private const MOVE_LEFT = 4;

        private const DIRECTION = [[0, 0], [-1, 0], [0, 1], [1, 0], [0, -1]];

        public function LLK_Model()
        {
            _chessBoardMatrix = new Array();
            for(var i = 0; i < LLK_Config.BOARD_SIZE_Y + 2; ++i)
            {
                var rows:Array = new Array();
                for(var j = 0; j < LLK_Config.BOARD_SIZE_X + 2; ++j)
                {
                    rows.push(0);
                }
                _chessBoardMatrix.push(rows);
            }
        }
        public static function get instance():LLK_Model
        {
            if (_instance == null)
            {
                _instance = new LLK_Model();
            }
            return _instance;
        }

        public function get selectedIcon():MovieClip
        {
            return _selectedIcon;
        }

        public function set selectedIcon(icon:MovieClip):void
        {
            this._selectedIcon = icon;
        }

        public function get chessBoardMatrix():Array
        {
            return _chessBoardMatrix;
        }

        public function set chessBoardMatrix(chessBoardMatrix:Array):void
        {
            this._chessBoardMatrix = chessBoardMatrix;
        }

        public function get isWin():Boolean
        {
            return _eliminateCount >= LLK_Config.BOARD_SIZE;
        }

        /**
         * 消除图标
         * @param icon 当前点击的图标
         * @return
         */
        public function checkAndEliminate(icon:MovieClip, callback:Function):void
        {
            var anotherIcon:MovieClip = _selectedIcon;
            if(linkable(icon))
            {
                _chessBoardMatrix[getPoint(icon).i][getPoint(icon).j] = 0
                _chessBoardMatrix[getPoint(_selectedIcon).i][getPoint(_selectedIcon).j] = 0
                _selectedIcon = null;

                _eliminateCount += 2;
                callback.apply(null,[true, anotherIcon, _track]);
            }
            else
            {
                _selectedIcon = icon;
                callback.apply(null,[false]);
            }
        }

        private function linkable(icon:MovieClip):Boolean
        {
            if(_selectedIcon == null || _selectedIcon.type != icon.type)
            {
                return false;
            }
            //todo 判断两个图标之间是否可连接
            return reachable(icon);
        }

        private function reachable(icon:MovieClip):Boolean
        {
            if(icon == _selectedIcon)
            {
                return false;
            }
            var start:Object = getPoint(_selectedIcon);
            var end:Object = getPoint(icon);
            if(pointsReachable(start, end, MOVE_START, 0))
            {
                trace("----------Success---------")
                var p:Object = start;
                trace("Node: " + p.i + "," + p.j);
                while(p.next)
                {
                    p = p.next;
                    trace("Node: " + p.i + "," + p.j);
                }
                _track = start;
                return true;
            }
            else
            {
                trace("----------Fail---------")
                return false;
            }
        }

        private function turnCount(icon:MovieClip):int
        {
            return 0;
        }

        private function pointsReachable(start:Object, end:Object, direction, turnCount)
        {
            //超过最大转向次数，寻路失败
            if(turnCount > LLK_Config.MAX_TURN_COUNT)
            {
                return false;
            }
            //超出边界，寻路失败
            if(outOfRange(start))
            {
                return false;
            }
            //寻路成功
            if(start.i == end.i && start.j == end.j)
            {
                return true;
            }

            if(_chessBoardMatrix[start.i][start.j] != 0 && direction != MOVE_START)
            {
                return false;
            }

            return pointsReachable(move(start, MOVE_UP), end, MOVE_UP, direction == MOVE_UP? turnCount:turnCount + 1) ||
            pointsReachable(move(start, MOVE_RIGHT), end, MOVE_RIGHT, direction == MOVE_RIGHT? turnCount:turnCount + 1) ||
            pointsReachable(move(start, MOVE_DOWN), end, MOVE_DOWN, direction == MOVE_DOWN? turnCount:turnCount + 1) ||
            pointsReachable(move(start, MOVE_LEFT), end, MOVE_LEFT, direction == MOVE_LEFT? turnCount:turnCount + 1);

        }

        private function outOfRange(point:Object)
        {
            if(point.i < 0 || point.j < 0)
            {
                return true;
            }
            if(point.i > LLK_Config.BOARD_SIZE_Y + 1 || point.j > LLK_Config.BOARD_SIZE_X + 1)
            {
                return true;
            }
            return false;
        }

        private function move(point:Object, direction)
        {
            var nextPoint:Object = {i: point.i + DIRECTION[direction][0], j: point.j + DIRECTION[direction][1]}
            point.next = nextPoint;
            return nextPoint;
        }

        private function getPoint(icon:MovieClip):Object
        {
            var row:int = icon.id / LLK_Config.BOARD_SIZE_X;
            var colume:int = icon.id % LLK_Config.BOARD_SIZE_X;
            return {i: row + 1, j: colume + 1};
        }
    }

}
