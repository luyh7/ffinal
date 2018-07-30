package lianliankan {

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.system.ApplicationDomain;

import lianliankan.LLK_Config;

public class LLK_View extends Sprite {

        private static var _instance:LLK_View;
        private var _domain:ApplicationDomain = ApplicationDomain.currentDomain;
        private var _model:LLK_Model = LLK_Model.instance;
        private var _stage:Sprite;
        public function LLK_View()
        {

        }
        public static function get instance():LLK_View
        {
            if (_instance == null)
            {
                _instance = new LLK_View();
            }
            return _instance;
        }
        public function init(stage: Sprite):void
        {
            clearStage();

            this._stage = stage;
            var background = getClass("Background") as MovieClip;
            _stage.addChild(background);
            initChessBoard();
            addListeners();
        }

        private function clearStage():void
        {
            //todo 清空舞台
        }

        private function addListeners():void
        {

        }

        private function getClass(clsName:String):*
        {
            return LLK_Util.getInstance(LLK_Config.cls(clsName), _domain);
        }

        private function initChessBoard():void
        {
            for(var i:int = 0; i < LLK_Config.BOARD_SIZE_Y; ++i)
            {
                for(var j:int = 0; j < LLK_Config.BOARD_SIZE_X; ++j)
                {
                    var iconContainer = getClass("IconContainer") as MovieClip;

                    iconContainer.x = LLK_Config.ORIGIN_X + j *  LLK_Config.OFFSET;
                    iconContainer.y = LLK_Config.ORIGIN_Y + i *  LLK_Config.OFFSET;
                    iconContainer.gotoAndStop(1);
                    var icons = getClass("Icons") as MovieClip;
                    //todo 生成连连看阵列
                    _model.chessBoardMatrix[i + 1][j + 1] = 1;
                    icons.gotoAndStop(int(Math.random() * 30));

                    iconContainer.addChild(icons);
                    iconContainer.mouseChildren = false; // todo
                    iconContainer.id = i * LLK_Config.BOARD_SIZE_X + j;
                    iconContainer.type = icons.currentFrame;
                    _stage.addChild(iconContainer);
                    iconContainer.addEventListener(MouseEvent.CLICK, onClickIcon)
                }
            }
        }

        private function onClickIcon(evt:MouseEvent):void
        {
            var icon = evt.currentTarget as MovieClip;
            var id:int = icon.id;

           _model.checkAndEliminate(icon, function (success:Boolean,anotherIcon:MovieClip = null, track:Object = null)
           {
               if(success)
               {
                   playEliminateMovie(icon, anotherIcon, track);
               }
               updatePanel();
           })
        }

        private function playEliminateMovie(icon:MovieClip, anotherIcon:MovieClip, track:Object):void
        {
            playThunderMovie(track);
            _stage.removeChild(icon);
            _stage.removeChild(anotherIcon);
            //todo 播放消除动画
        }

        private function playThunderMovie(track:Object)
        {
            var p:Object = track;
            while(p.next)
            {
                var x = LLK_Config.ORIGIN_X + (p.j-1) * LLK_Config.OFFSET + 24;
                var y = LLK_Config.ORIGIN_Y + (p.i-1) * LLK_Config.OFFSET + 24;
                var thunder = getClass("Line") as MovieClip;
                thunder.x = x;
                thunder.y = y;
                thunder.scaleX = 0.5;
                var direction:Object = {"x":p.next.j - p.j, "y":p.next.i-p.i};
                trace("rotation: " + direction.x + "," + direction.y)
                thunder.x -= direction.x == -1? LLK_Config.OFFSET:0;
                thunder.rotationZ = 90 * direction.y;

                thunder.addFrameScript(thunder.totalFrames - 1, function ()
                {
//                    if(_stage.contains(thunder))
//                    {
//                        _stage.removeChild(thunder);
//                    }
                    thunder.visible = false;
                    thunder.addFrameScript(thunder.totalFrames - 1,null)
                })
                _stage.addChild(thunder);
                p = p.next;
            }
        }

        private function updatePanel():void
        {
            for(var i:int = 0; i < _stage.numChildren; ++i)
            {
                var child = _stage.getChildAt(i) as MovieClip;
//                child.gotoAndStop(1);
                if(_model.selectedIcon != null && child.id == _model.selectedIcon.id)
                {
                    child.gotoAndStop(2);
                }
                else if(child.id != null)
                {
                    child.gotoAndStop(1);
                }
            }
        }
    }

}
